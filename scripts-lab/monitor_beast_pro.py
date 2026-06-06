#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import time
import re
import subprocess

# Caminhos padrão no Santos Dumont
DEFAULT_DIR = "/scratch/bioevopeixes/micael.silva/beast/"
LOG_FILE_PATH = os.path.join(DEFAULT_DIR, "beast.log")
XML_FILE_PATH = os.path.join(DEFAULT_DIR, "beast.xml")

# Cores ANSI para deixar o terminal bonito
GREEN = '\033[92m'
BLUE = '\033[94m'
YELLOW = '\033[93m'
RED = '\033[91m'
NC = '\033[0m'
BOLD = '\033[1m'
CLEAR = '\033[H\033[J'

def get_slurm_status(user="micael.silva"):
    """Consulta a fila do SLURM para ver se há jobs do BEAST ativos."""
    try:
        output = subprocess.check_output(["squeue", "-u", user, "-o", "%i %j %T %M %R"], stderr=subprocess.DEVNULL)
        lines = output.decode("utf-8").strip().split("\n")
        jobs = []
        for line in lines[1:]:
            parts = line.split()
            if len(parts) >= 3:
                job_id = parts[0]
                name = parts[1]
                state = parts[2]
                time_limit = parts[3] if len(parts) > 3 else "N/A"
                nodelist = parts[4] if len(parts) > 4 else "N/A"
                if "beast" in name.lower() or "beast2" in name.lower():
                    jobs.append({"id": job_id, "name": name, "state": state, "time": time_limit, "node": nodelist})
        return jobs
    except Exception:
        return []

def get_chain_length(xml_path):
    """Extrai a chainLength do arquivo xml do BEAST."""
    if not os.path.exists(xml_path):
        return 100000000  # Padrão fallback se não achar o XML
    try:
        with open(xml_path, 'r', errors='ignore') as f:
            content = f.read()
            match = re.search(r'chainLength="([0-9]+)"', content)
            if match:
                return int(match.group(1))
    except Exception:
        pass
    return 100000000

def get_last_generation(log_path):
    """Lê as informações da última linha do arquivo de log do BEAST."""
    if not os.path.exists(log_path):
        return 0, 0.0, 0.0
    try:
        # Lê apenas o final do arquivo para desempenho (arquivos de log podem ser enormes)
        with open(log_path, 'rb') as f:
            f.seek(0, os.SEEK_END)
            size = f.tell()
            buffer_size = 8192
            if size < buffer_size:
                buffer_size = size
            f.seek(-buffer_size, os.SEEK_END)
            lines = f.read().decode('utf-8', errors='ignore').splitlines()
            
            # Filtra linhas de dados válidos (desconsidera comentários do BEAST com #)
            data_lines = [l.strip() for l in lines if l.strip() and not l.strip().startswith('#')]
            if data_lines:
                last_line = data_lines[-1]
                parts = last_line.split()
                if len(parts) >= 3:
                    # Tenta converter a primeira coluna em int (Geração)
                    try:
                        gen = int(parts[0])
                        post = float(parts[1])
                        like = float(parts[2])
                        return gen, post, like
                    except ValueError:
                        pass
    except Exception:
        pass
    return 0, 0.0, 0.0

def format_time(seconds):
    """Formata o tempo em segundos para um formato legível (H:M:S)."""
    if seconds is None:
        return "Calculando..."
    if seconds < 60:
        return f"{int(seconds)}s"
    elif seconds < 3600:
        m = int(seconds // 60)
        s = int(seconds % 60)
        return f"{m}m {s}s"
    else:
        h = int(seconds // 3600)
        m = int((seconds % 3600) // 60)
        s = int(seconds % 60)
        return f"{h}h {m}m {s}s"

def main():
    log_file = LOG_FILE_PATH
    xml_file = XML_FILE_PATH
    
    # Permite passar outros arquivos via argumento
    if len(sys.argv) > 1:
        log_file = sys.argv[1]
    if len(sys.argv) > 2:
        xml_file = sys.argv[2]
        
    chain_length = get_chain_length(xml_file)
    
    # Primeira amostragem
    last_gen, _, _ = get_last_generation(log_file)
    last_time = time.time()
    
    # Armazena histórico de amostras de velocidade para calcular média móvel mais estável
    speed_history = []
    
    try:
        while True:
            current_time = time.time()
            current_gen, posterior, likelihood = get_last_generation(log_file)
            
            # Evita divisões por zero e calcula porcentagem
            percentage = (current_gen / chain_length) * 100 if chain_length > 0 else 0
            
            # Calcula a variação de gerações e tempo desde a última leitura
            elapsed = current_time - last_time
            gen_diff = current_gen - last_gen
            
            if elapsed > 2 and gen_diff > 0:
                inst_speed = gen_diff / elapsed  # gerações por segundo
                speed_history.append((inst_speed, elapsed))
                if len(speed_history) > 12:  # Mantém as últimas 12 amostras (~1 minuto)
                    speed_history.pop(0)
                
                # Atualiza referências para a próxima medição
                last_gen = current_gen
                last_time = current_time
            
            # Calcula velocidade média ponderada pelo tempo decorrido de cada amostra
            avg_speed = None
            if speed_history:
                total_gen = sum(speed * duration for speed, duration in speed_history)
                total_duration = sum(duration for _, duration in speed_history)
                if total_duration > 0:
                    avg_speed = total_gen / total_duration
            
            # Estima o tempo restante (ETA)
            remaining_gen = chain_length - current_gen
            eta_seconds = None
            if avg_speed and avg_speed > 0:
                eta_seconds = remaining_gen / avg_speed
            
            # Consulta status dos jobs no SLURM
            jobs = get_slurm_status()
            
            # Limpa o terminal e atualiza a tela
            sys.stdout.write(CLEAR)
            print(f"{BOLD}=================================================={NC}")
            print(f"         {BOLD}MONITOR DE PROGRESSO DO BEAST 2{NC}")
            print(f"{BOLD}=================================================={NC}")
            print(f"Pasta de Execução: {YELLOW}{os.path.dirname(os.path.abspath(log_file))}{NC}")
            print(f"Arquivo de Log:    {YELLOW}{os.path.basename(log_file)}{NC}")
            print(f"Arquivo XML:       {YELLOW}{os.path.basename(xml_file)}{NC}")
            print(f"--------------------------------------------------")
            
            # Exibe status da fila do SLURM
            if jobs:
                print(f"Status no SLURM:")
                for j in jobs:
                    state_color = GREEN if j['state'] == 'RUNNING' else (YELLOW if j['state'] == 'PENDING' else RED)
                    print(f"  • Job ID: {j['id']} | Estado: {state_color}{j['state']}{NC} | Tempo: {j['time']} | Nó: {j['node']}")
            else:
                print(f"Status no SLURM: {RED}Nenhum job de BEAST ativo na fila do usuário.{NC}")
            
            print(f"--------------------------------------------------")
            
            # Progresso do MCMC
            print(f"Geração Atual:   {BOLD}{current_gen:,}{NC}")
            print(f"Geração Alvo:    {BOLD}{chain_length:,}{NC}")
            print(f"Progresso:       {BOLD}{GREEN}{percentage:.2f}%{NC}")
            
            # Desenha a barra de progresso visual
            bar_length = 30
            filled_length = int(round(bar_length * current_gen / chain_length)) if chain_length > 0 else 0
            bar = '█' * filled_length + '░' * (bar_length - filled_length)
            print(f"[{GREEN}{bar}{NC}]")
            
            print(f"--------------------------------------------------")
            
            # Estatísticas científicas da última geração
            print(f"Posterior:       {YELLOW}{posterior}{NC}")
            print(f"Likelihood:      {YELLOW}{likelihood}{NC}")
            
            print(f"--------------------------------------------------")
            
            # Estatísticas de velocidade e tempo restante
            if avg_speed and avg_speed > 0:
                speed_per_hour = avg_speed * 3600
                print(f"Velocidade:      {GREEN}{speed_per_hour:,.0f} gerações/hora{NC}")
                print(f"Tempo Restante:  {BOLD}{BLUE}{format_time(eta_seconds)}{NC}")
            else:
                print(f"Velocidade:      {YELLOW}Calculando velocidade...{NC}")
                print(f"Tempo Restante:  {YELLOW}Aguardando gravação de novas iterações...{NC}")
            
            print(f"{BOLD}=================================================={NC}")
            print("Pressione Ctrl+C para sair. Atualizando a cada 5s...")
            
            time.sleep(5)
            
    except KeyboardInterrupt:
        print(f"\n{GREEN}Monitoramento encerrado pelo usuário.{NC}\n")

if __name__ == '__main__':
    main()
