================================================================================
💻 Pasta de Scripts em R - fish-lab
================================================================================

Esta pasta contém scripts em R estruturados e documentados para análise de
dados biológicos, ecológicos e genéticos.

--------------------------------------------------------------------------------
📦 Pacotes Necessários
--------------------------------------------------------------------------------
Para rodar todos os scripts desta pasta, você precisará dos seguintes pacotes.
Abra o R ou RStudio e execute o seguinte comando no console para instalá-los:

install.packages(c("ggplot2", "ape", "pegas", "vegan"))

--------------------------------------------------------------------------------
📋 Scripts Disponíveis
--------------------------------------------------------------------------------

1. relacao_peso_comprimento.R
   - Ajusta o modelo de crescimento alométrico W = a * L^b.
   - Gera gráficos biométricos elegantes usando o ggplot2.

2. calculo_diversidade_genetica.R
   - Processa sequências de DNA em formato FASTA.
   - Calcula diversidade nucleotídica (pi), sítios segregantes e haplótipos.
   - Constrói e plota redes de haplótipos (TCS-like).

3. amova_fst_populacional.R
   - Realiza a Análise de Variância Molecular (AMOVA) usando o pegas.
   - Estima a diferenciação genética populacional par a par (Fst / Phi_ST).
   - Testa a significância estatística de diferenciação através de permutações.

4. analise_comunidades_nmds.R
   - Executa ordenação por Escalonamento Multidimensional Não-Métrico (NMDS).
   - Calcula a distância de Bray-Curtis para matrizes de abundância/presença.
   - Plota ordenações com elipses de confiança e curvas de acumulação de espécies.

--------------------------------------------------------------------------------
💡 Dicas de Uso
--------------------------------------------------------------------------------
- Todos os scripts vêm com geradores de dados fictícios simulados integrados.
  Isso permite que você os rode diretamente ("out of the box") para ver os plots.
- Para usar seus próprios dados reais, substitua os geradores de dados de exemplo
  pela leitura dos seus arquivos locais (ex: read.table(), read.csv() ou read.dna()).
