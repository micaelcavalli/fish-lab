# Carrega os pacotes necessários
library(treeio)
library(ggtree)
library(here)
library(ggplot2)

# Lê a árvore anotada do BEAST
tree_beast <- read.beast(here("assets/CHARACIFORMES.tre"))

# Mostra os nomes das pontas (tip labels)
cat("Pontas da árvore:\n")
print(tree_beast@phylo$tip.label)

# Define os ramos que você deseja remover
# 🔁 Edite essa lista com os nomes reais dos ramos que quer tirar
to_remove <- c("NC080887.1")

# Remove os ramos indesejados mantendo as anotações do BEAST
tree_podada <- treeio::drop.tip(tree_beast, tip = to_remove)

# Plota a árvore podada (opcional)
ggtree(tree_podada) + 
  geom_tiplab(size = 2) + 
  ggtitle("Árvore podada com anotações")

# Salva a nova árvore podada com anotações
write.beast(tree_podada, file = here("assets/CHARACIFORMES_2.tre"))

cat("Árvore podada salva com sucesso!\n")
