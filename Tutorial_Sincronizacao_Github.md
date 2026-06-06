# Sincronização do Antigravity com GitHub

Este guia prático explica como manter a sua pasta de workspace do Antigravity sincronizada em múltiplos computadores usando o Git e o GitHub.

---

## 1. Como funciona a Sincronização
O Antigravity funciona sobre as pastas locais do seu computador. Para sincronizá-las entre dispositivos, usamos o **Git** para rastrear e registrar as alterações, e o **GitHub** como a ponte de armazenamento na nuvem.

---

## 2. Configuração Feita no Computador Atual (Computador A)
No seu computador atual, nós já configuramos o seguinte:
1. Inicializamos o repositório local (`git init`).
2. Criamos um arquivo `.gitignore` para ignorar arquivos temporários e de cache.
3. Configuramos sua identidade global do Git:
   ```bash
   git config --global user.name "Micael Cavalli"
   git config --global user.email "micaelcavalli@gmail.com"
   ```
4. Vinculamos o projeto à sua chave SSH e ao repositório remoto no GitHub:
   ```bash
   git remote add origin git@github.com:micaelcavalli/antigravity.git
   git branch -M main
   git push -u origin main
   ```

---

## 3. Configurando no Segundo Computador (Computador B)

Para acessar seus arquivos no segundo computador, siga estes passos:

### Passo 1: Verificar/Adicionar Chave SSH no GitHub
1. Abra o terminal no computador B.
2. Veja se você já possui uma chave SSH ativa:
   ```bash
   ls -la ~/.ssh
   ```
3. Se não tiver arquivos como `id_ed25519` e `id_ed25519.pub`, gere uma nova chave:
   ```bash
   ssh-keygen -t ed25519 -C "micaelcavalli@gmail.com"
   ```
   *(Pressione Enter para todas as perguntas para usar as opções padrão).*
4. Copie o conteúdo da chave pública gerada:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
5. Cole essa chave nas configurações do seu GitHub em [github.com/settings/keys](https://github.com/settings/keys) clicando em **"New SSH key"**.

### Passo 2: Clonar o Repositório
No terminal do Computador B, navegue até a pasta onde deseja guardar o projeto (ex: `~/Documentos`) e execute o clone:
```bash
git clone git@github.com:micaelcavalli/antigravity.git
```

### Passo 3: Abrir no Antigravity
Abra o Antigravity no Computador B e selecione a pasta `antigravity` que acabou de ser clonada como o seu workspace ativo.

---

## 4. Fluxo de Trabalho Diário (Sincronização Contínua)

Para garantir que você nunca perca nada e evite conflitos de versão, certifique-se de que seu terminal está sempre na pasta do projeto (`cd ~/Documentos/Antigravity`) antes de rodar os comandos Git. Siga este fluxo simples:

### 💾 Ao terminar de trabalhar em um computador:
*(Primeiro garanta que está na pasta: `cd ~/Documentos/Antigravity`)*

Antes de desligar ou trocar de computador, salve e envie as suas alterações para o GitHub. Você pode fazer isso no terminal ou pedindo para o próprio assistente do Antigravity rodar:
```bash
git add .
git commit -m "atualização das notas"
git push
```

### 📥 Ao começar a trabalhar no outro computador:
*(Primeiro garanta que está na pasta: `cd ~/Documentos/Antigravity`)*

Antes de abrir ou editar qualquer arquivo no Antigravity, garanta que está com a versão mais recente rodando:
```bash
git pull
```

---
*Dica: Como o Antigravity possui acesso ao terminal, você pode simplesmente pedir em linguagem natural "sincronize minhas alterações no github" ou "puxe as atualizações do github" que o assistente fará os comandos `push` ou `pull` para você!*
