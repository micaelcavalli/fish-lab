# ==============================================================================
# Script: Análise Multivariada de Comunidades Ecológicas (NMDS e Acumulação)
# Autor: Micael Cavalli
# Descrição: Realiza Escalonamento Multidimensional Não-Métrico (NMDS) e plota
#            curvas de acumulação de espécies usando o pacote 'vegan'.
# ==============================================================================

# 1. Carregamento dos Pacotes --------------------------------------------------
# Instale o pacote 'vegan' caso não o possua:
# install.packages("vegan")
library(vegan)
library(ggplot2)

# 2. Geração de Dados Fictícios de Comunidades ---------------------------------
# Simulando dados de 15 pontos amostrais (linhas) e 10 espécies de peixes (colunas)
set.seed(7)
matriz_comunidade <- matrix(
  rpois(150, lambda = 5), 
  nrow = 15, ncol = 10
)
colnames(matriz_comunidade) <- paste0("Especie_", 1:10)
rownames(matriz_comunidade) <- paste0("Ponto_", 1:15)

# Variável ambiental fictícia (ex: Tipo de Habitat - Correnteza vs. Remanso)
habitat <- factor(c(rep("Correnteza", 7), rep("Remanso", 8)))

# 3. Escalonamento Multidimensional Não-Métrico (NMDS) -------------------------
# Utilizando a distância de Bray-Curtis (comum para dados de abundância)
nmds_resultado <- metaMDS(matriz_comunidade, distance = "bray", k = 2, trymax = 50, trace = FALSE)

cat("--- Resultado do NMDS ---\n")
cat("Stress do NMDS:", round(nmds_resultado$stress, 4), "\n")
if(nmds_resultado$stress < 0.2) {
  cat("Avaliação: O stress é aceitável (< 0.20). A representação bidimensional é confiável.\n")
} else {
  cat("Avaliação: Atenção, stress elevado (> 0.20). Considere aumentar o número de dimensões (k).\n")
}

# Extraindo as coordenadas para plotar no ggplot2
nmds_coordenadas <- as.data.frame(scores(nmds_resultado, display = "sites"))
nmds_coordenadas$Habitat <- habitat

# Plotando NMDS no ggplot2
grafico_nmds <- ggplot(nmds_coordenadas, aes(x = NMDS1, y = NMDS2, color = Habitat, shape = Habitat)) +
  geom_point(size = 4, alpha = 0.8) +
  stat_ellipse(linewidth = 1, linetype = 2) +
  scale_color_manual(values = c("#2980b9", "#27ae60")) +
  labs(
    title = "Ordenação NMDS da Comunidade de Peixes",
    subtitle = paste("Stress:", round(nmds_resultado$stress, 3)),
    caption = "Dados simulados | Distância de Bray-Curtis"
  ) +
  theme_bw(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "right"
  )

print(grafico_nmds)

# 4. Curva de Acumulação de Espécies (Coletores) -------------------------------
cat("\nCalculando Curva de Acumulação de Espécies...\n")
curva_acumulacao <- specaccum(matriz_comunidade, method = "random", permutations = 100)

# Plotando a curva usando a função padrão do R
plot(curva_acumulacao, 
     ci.type = "poly", 
     col = "#2c3e50", 
     lwd = 2, 
     ci.col = "#ecf0f1", 
     main = "Curva de Acumulação de Espécies",
     xlab = "Número de Pontos Amostrais",
     ylab = "Número de Espécies Encontradas")
