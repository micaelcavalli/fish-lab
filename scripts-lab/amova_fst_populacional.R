# ==============================================================================
# Script: Análise de Diferenciação Populacional (Fst e AMOVA)
# Autor: Micael Cavalli
# Descrição: Calcula a diferenciação genética entre populações (Phi_ST/Fst) 
#            e realiza a Análise de Variância Molecular (AMOVA) usando o 'pegas' e 'ape'.
# ==============================================================================

# 1. Carregamento dos Pacotes --------------------------------------------------
# Instale os pacotes caso ainda não os possua:
# install.packages(c("ape", "pegas"))
library(ape)
library(pegas)

# 2. Geração de Dados de DNA e Populações Simulados ----------------------------
cat("Simulando sequências de DNA e fatores populacionais...\n")
set.seed(42)

# Simulando 15 indivíduos com sequências de 10 pb
# Vamos simular duas populações com frequências de nucleotídeos diferentes para gerar estrutura
pop_A <- matrix(sample(c("a", "g"), 80, replace = TRUE, prob = c(0.8, 0.2)), nrow = 8, ncol = 10)
pop_B <- matrix(sample(c("t", "c"), 70, replace = TRUE, prob = c(0.7, 0.3)), nrow = 7, ncol = 10)

matriz_dna <- rbind(pop_A, pop_B)
rownames(matriz_dna) <- c(paste0("PopA_Ind", 1:8), paste0("PopB_Ind", 1:7))

# Converter para a classe 'DNAbin' (formato ape)
dna <- as.DNAbin(matriz_dna)

# Criando o vetor de populações (fator populacional)
populacoes <- factor(c(rep("Rio_Negro", 8), rep("Rio_Solimoes", 7)))

# 3. Matriz de Distância Genética (dist.dna) -----------------------------------
# Calcula a distância genética par a par entre os indivíduos (ex: modelo K80 ou Tamura-Nei)
distancia_genetica <- dist.dna(dna, model = "K80")

# 4. Análise de Variância Molecular (AMOVA) ------------------------------------
# A fórmula 'distancia_genetica ~ populacoes' testa a variação entre as populações
amova_resultado <- amova(distancia_genetica ~ populacoes, nperm = 1000)

cat("\n--- Resultado da AMOVA (Analysis of Molecular Variance) ---\n")
print(amova_resultado)

# Nota sobre a AMOVA do pegas:
# O valor de Phi_ST (equivalente ao Fst para dados de distância/sequência) 
# mede o grau de diferenciação genética entre as populações.
# A significância é calculada via teste de permutação (p-value).

# 5. Cálculo de Fst Populacional (Phi_ST) --------------------------------------
# Extraindo os componentes de variância para calcular Phi_ST manualmente da tabela
var_componentes <- amova_resultado$varcomp
sigma_entre_pop <- var_componentes[1]  # Variância entre populações
sigma_dentro_pop <- var_componentes[2] # Variância dentro das populações (resíduos)

phi_st <- sigma_entre_pop / (sigma_entre_pop + sigma_dentro_pop)

cat("\n--- Estatística de Diferenciação Populacional ---\n")
cat("Phi_ST (Fst analógico):", round(phi_st, 5), "\n")
cat("Significância (p-valor do teste de permutação):", amova_resultado$prob[1], "\n")

# Interpretando o resultado:
# Phi_ST < 0.05: Baixa diferenciação genética
# 0.05 <= Phi_ST <= 0.15: Diferenciação moderada
# 0.15 < Phi_ST <= 0.25: Alta diferenciação
# Phi_ST > 0.25: Diferenciação genética muito alta (provável isolamento forte)
