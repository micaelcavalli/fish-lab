# 🐟 fish-lab

Repositório pessoal e acadêmico voltado para o armazenamento e organização de **protocolos laboratoriais de genética/biologia molecular** e **scripts de análise de dados em R**.

---

## 📁 Estrutura do Repositório

O repositório está organizado nas seguintes pastas:

### 🧪 [protocols-lab/](./protocols-lab/)
Contém protocolos detalhados em formato PDF para rotinas de laboratório:
*   🧬 **Extração de DNA**:
    *   [Protocolo de Extração DNA - Qiagen](./protocols-lab/Protocolo%20de%20Extração%20DNA%20-%20Qiagen.pdf) — Protocolo utilizando kit comercial Qiagen.
    *   [Protocolo de Extração de DNA - CELLCO v1](./protocols-lab/Protocolo%20de%20Extração%20de%20DNA%20-%20CELLCO_v1.pdf) — Protocolo de extração com kit CELLCO.
    *   [Protocolo de Extração de DNA - Fenol v1](./protocols-lab/Protocolo%20de%20Extração%20de%20DNA%20-%20Fenol_v1.pdf) — Protocolo clássico de extração utilizando Fenol-Clorofórmio.
*   🧪 **Reação em Cadeia da Polimerase (PCR)**:
    *   [Protocolo de PCR - CELLCO v1](./protocols-lab/Protocolo%20de%20PCR%20-%20CELLCO_v1.pdf) — Reagentes e condições para PCR com produtos CELLCO.
*   📊 **Eletroforese**:
    *   [Protocolo de Gel Agarose 1% v1](./protocols-lab/Protocolo%20de%20Gel%20Agarose%201%25_v1.pdf) — Preparação e corrida de gel de agarose a 1%.

### 💻 [scripts-lab/](./scripts-lab/)
Espaço dedicado para scripts em R voltados à análise de dados biológicos, ecológicos e genéticos:
*   📈 **Crescimento e Biometria**:
    *   [Relação Peso-Comprimento](./scripts-lab/relacao_peso_comprimento.R) — Script R para estimar parâmetros $a$ e $b$ de crescimento alométrico e gerar gráficos elegantes com `ggplot2`.
*   🧬 **Genética de Populações**:
    *   [Diversidade Genética e Haplótipos](./scripts-lab/calculo_diversidade_genetica.R) — Script R usando `ape` e `pegas` para cálculo de diversidade nucleotídica, sítios segregantes e desenho de rede de haplótipos.
    *   [Diferenciação Populacional e AMOVA](./scripts-lab/amova_fst_populacional.R) — Script R para cálculo de $F_{ST}$ (Phi_ST) e Análise de Variância Molecular (AMOVA) usando `ape` e `pegas`.
*   📊 **Ecologia e Comunidades**:
    *   [NMDS e Curvas de Acumulação](./scripts-lab/analise_comunidades_nmds.R) — Script R usando `vegan` para realizar Escalonamento Multidimensional Não-Métrico (NMDS) e plotar curvas de acumulação de espécies.


---

## 🚀 Como Utilizar

Você pode clonar este repositório para ter acesso local aos arquivos e scripts:

```bash
git clone https://github.com/micaelcavalli/fish-lab.git
```

---

## 👨‍🔬 Autor

**Micael Cavalli**
*   🎓 Mestre em Zoologia – Universidade Federal do Amazonas (UFAM)
*   🧬 Biólogo – Universidade do Estado do Amazonas (UEA)
*   📅 Criado em: 24 de fevereiro de 2026

Se você tiver alguma dúvida sobre os protocolos ou quiser colaborar nos scripts, sinta-se à vontade para entrar em contato!

---

## 🪶 Licença e Uso

Este repositório tem fins estritamente **pessoais e acadêmicos**. 
Se você reutilizar ou se basear em algum script ou protocolo contido aqui, por favor, **cite o autor**.

