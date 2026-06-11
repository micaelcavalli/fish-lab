# Instalar pacotes
install.packages("futile.logger")
install.packages("VennDiagram")

# Carregar pacote
library(VennDiagram)

# Definir os conjuntos
morfologia <- c("Geophagus sp1*", "Apistogramma sp2", "Crenicichla sp1", "Leporinus sp1*", "Brachyhypopomus sp1")
coi_concordante <- c("Geophagus sp1*", "Apistogramma sp2", "Brachyhypopomus sp1")
s12_concordante <- c("Apistogramma sp2", "Crenicichla sp1")

# Criar diagrama de Venn
venn.plot <- venn.diagram(
  x = list(
    Morfologia = morfologia,
    COI = coi_concordante,
    `12S` = s12_concordante
  ),
  filename = NULL,
  fill = c("skyblue", "lightgreen", "lightcoral"),
  alpha = 0.6,
  cex = 1.2,
  cat.cex = 1.3,
  cat.fontface = "bold",
  margin = 0.1
)

# Plotar
grid.newpage()
grid.draw(venn.plot)

# Legenda opcional para explicar o asterisco
grid.text("* Espécies com discordância molecular", x = 0.5, y = 0.05, gp = gpar(fontsize = 10, fontface = "italic"))
