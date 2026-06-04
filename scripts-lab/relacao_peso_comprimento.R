# ==============================================================================
# Script: Relação Peso-Comprimento em Peixes (W = a * L^b)
# Autor: Micael Cavalli
# Descrição: Ajusta a curva de crescimento alométrico e plota dados biológicos
#            de peixes utilizando o ggplot2.
# ==============================================================================

# 1. Instalação e Carregamento de Pacotes --------------------------------------
# Caso não tenha o ggplot2 instalado, remova o '#' da linha abaixo para instalar:
# install.packages("ggplot2")
library(ggplot2)

# 2. Geração de Dados Fictícios de Exemplo -------------------------------------
# Simulando dados de 100 indivíduos de peixes (ex: Tucunaré, Cichla sp.)
set.seed(42)
comprimento <- runif(100, min = 15, max = 60) # Comprimento padrão (cm)

# Relação biológica real aproximada: W = 0.015 * L^3.0 + erro
b_real <- 3.05
a_real <- 0.012
peso <- a_real * (comprimento ^ b_real) * rnorm(100, mean = 1, sd = 0.1) # Peso (g)

# Criando o data frame
dados_peixes <- data.frame(
  ID = 1:100,
  Comprimento_cm = comprimento,
  Peso_g = peso
)

# 3. Ajuste do Modelo Não-Linear -----------------------------------------------
# W = a * L^b
# Podemos linearizar usando logaritmo: log(W) = log(a) + b * log(L)
modelo <- lm(log(Peso_g) ~ log(Comprimento_cm), data = dados_peixes)

# Extraindo os parâmetros
a_estimado <- exp(coef(modelo)[1])
b_estimado <- coef(modelo)[2]

cat("--- Parâmetros Estimados da Relação Peso-Comprimento ---\n")
cat("Fórmula: W = a * L^b\n")
cat("a (fator de condição):", round(a_estimado, 5), "\n")
cat("b (alometria):", round(b_estimado, 3), "\n")

# Classificação do crescimento:
# b = 3: Isométrico
# b > 3: Alométrico positivo (peixe fica mais gordo à medida que cresce)
# b < 3: Alométrico negativo (peixe fica mais magro à medida que cresce)
if (round(b_estimado, 1) == 3.0) {
  cat("Tipo de Crescimento: Isométrico (b ~ 3)\n")
} else if (b_estimado > 3) {
  cat("Tipo de Crescimento: Alométrico Positivo (b > 3)\n")
} else {
  cat("Tipo de Crescimento: Alométrico Negativo (b < 3)\n")
}

# 4. Construção do Gráfico com ggplot2 -----------------------------------------
# Gerando pontos preditos para desenhar a linha do modelo ajustado
comprimento_seq <- seq(min(dados_peixes$Comprimento_cm), max(dados_peixes$Comprimento_cm), length.out = 200)
peso_predito <- a_estimado * (comprimento_seq ^ b_estimado)
dados_linha <- data.frame(Comprimento_cm = comprimento_seq, Peso_g = peso_predito)

grafico <- ggplot(dados_peixes, aes(x = Comprimento_cm, y = Peso_g)) +
  # Adiciona os pontos observados
  geom_point(color = "#2c3e50", alpha = 0.7, size = 2.5) +
  # Adiciona a curva ajustada
  geom_line(data = dados_linha, aes(x = Comprimento_cm, y = Peso_g), 
            color = "#e74c3c", linewidth = 1.2) +
  # Títulos e Rótulos
  labs(
    title = "Relação Peso-Comprimento",
    subtitle = paste0("Modelo Ajustado: W = ", round(a_estimado, 4), " * L^", round(b_estimado, 2)),
    x = "Comprimento Padrão (cm)",
    y = "Peso Total (g)",
    caption = "Dados simulados | Script por Micael Cavalli"
  ) +
  # Tema visual clean e moderno
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", color = "#2c3e50", size = 16),
    plot.subtitle = element_text(color = "#7f8c8d", size = 12),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# Salvar o gráfico como imagem (PNG)
# ggsave("relacao_peso_comprimento.png", plot = grafico, width = 8, height = 6, dpi = 300)

# Exibir o gráfico no RStudio/R console
print(grafico)
