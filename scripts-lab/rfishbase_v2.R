# ============================================================
# Verificar validade de nomes de espécies usando o FishBase
# Autor: Micael Cavalli
# Data: 03 de nov. de 2025
# ============================================================

# ------------------------------------------------------------
# 0. Abrir pacotes necessários
# ------------------------------------------------------------
library(rfishbase)
library(dplyr)
library(readr)

# ------------------------------------------------------------
# 1. Ler arquivo CSV
# ------------------------------------------------------------
dados <- read_csv("output/dados_simplificado.csv")

# ------------------------------------------------------------
# 2. Obter lista de espécies únicas
# ------------------------------------------------------------
lista_especies <- unique(dados$specie)
cat("Número de espécies encontradas:", length(lista_especies), "\n")

# ------------------------------------------------------------
# 3. Consultar informações básicas no FishBase
# ------------------------------------------------------------
info_species <- species(lista_especies) %>%
  select(any_of(c("SpecCode", "Genus", "Species", "Family", "Order")))

# ------------------------------------------------------------
# 4. Buscar sinônimos e nomes válidos
# ------------------------------------------------------------
info_synonyms <- synonyms(lista_especies) %>%
  transmute(
    SpecCode,
    Original_Name = synonym,
    Current_Valid_Name = Species,
    Taxonomic_Status = Status
  )

# ------------------------------------------------------------
# 5. Preparar tabela de nomes válidos + dados locais
# ------------------------------------------------------------
resultado_final <- info_synonyms %>%
  left_join(info_species, by = "SpecCode") %>%
  # Junta novamente com o dataset original para recuperar as colunas de presença
  left_join(
    dados %>%
      select(specie, aripuana, madeira) %>%
      distinct(),
    by = c("Original_Name" = "specie")
  ) %>%
  select(
    Original_Name,
    Current_Valid_Name,
    Taxonomic_Status,
    aripuana,
    madeira
  )

# ------------------------------------------------------------
# 6. Salvar resultados em CSV
# ------------------------------------------------------------
write_csv(resultado_final, "output/validacao_fishbase2.csv")

