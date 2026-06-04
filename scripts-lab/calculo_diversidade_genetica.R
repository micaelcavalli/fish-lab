# ==============================================================================
# Script: Cálculo de Diversidade Genética e Haplotípica (Marcadores Moleculares)
# Autor: Micael Cavalli
# Descrição: Lê sequências de DNA (formato FASTA), calcula índices de diversidade
#            haplotípica (hd) e nucleotídica (pi), e gera rede de haplótipos.
# ==============================================================================

# 1. Carregamento dos Pacotes --------------------------------------------------
# Instale os pacotes caso ainda não os possua:
# install.packages(c("ape", "pegas"))
library(ape)
library(pegas)

# Nota: Este script espera um arquivo FASTA no diretório de trabalho.
# Exemplo de como carregar suas próprias sequências:
# dna <- read.dna("suas_sequencias.fasta", format = "fasta")

# 2. Criação de Dados de DNA de Exemplo (Simulação) ----------------------------
# Caso você não tenha um arquivo FASTA em mãos, vamos simular uma matriz de DNA:
cat("Simulando dados de DNA de teste...\n")
set.seed(123)
matriz_dna <- matrix(
  c("a", "a", "g", "t", "c",
    "a", "a", "g", "t", "c",
    "a", "g", "g", "t", "c",
    "t", "g", "g", "t", "a",
    "t", "g", "g", "t", "a",
    "t", "g", "a", "t", "a"),
  nrow = 6, ncol = 5, byrow = TRUE
)
rownames(matriz_dna) <- paste0("Individuo_", 1:6)

# Converter para a classe 'DNAbin' usada pelo pacote ape
dna <- as.DNAbin(matriz_dna)

# 3. Estatísticas de Diversidade Genética ---------------------------------------
# Número de sítios segregantes (polimórficos)
sitios_segregantes <- segregating.sites(dna)
num_sitios_seg <- length(sitios_segregantes)

# Diversidade Nucleotídica (Pi)
pi_nucleotidica <- nuc.div(dna)

# Identificação dos Haplótipos
haplotipos <- haplotype(dna)
num_haplotipos <- length(attr(haplotipos, "index"))

cat("\n--- Estatísticas de Diversidade Genética ---\n")
cat("Número de indivíduos analisados:", nrow(dna), "\n")
cat("Comprimento do alinhamento (pb):", ncol(dna), "\n")
cat("Sítios polimórficos (segregantes):", num_sitios_seg, "\n")
cat("Número de Haplótipos identificados:", num_haplotipos, "\n")
cat("Diversidade Nucleotídica (pi):", round(pi_nucleotidica, 5), "\n")

# 4. Rede de Haplótipos --------------------------------------------------------
# Construção da rede de haplótipos (TCS-like network)
rede <- haploNet(haplotipos)

# Plotando a rede de haplótipos
# O tamanho do círculo representa a frequência do haplótipo
plot(rede, size = attr(rede, "freq"), 
     fast = FALSE, 
     bg = "#3498db", 
     labels = TRUE,
     main = "Rede de Haplótipos (Simulação)")

# Para salvar a imagem gerada no computador:
# png("rede_haplotipos.png", width = 800, height = 800, res = 150)
# plot(rede, size = attr(rede, "freq"), bg = "#3498db", main = "Rede de Haplótipos")
# dev.off()
