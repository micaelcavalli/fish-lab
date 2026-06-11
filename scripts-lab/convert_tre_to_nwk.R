library(ape)
library(phangorn)

# load data fas
alignment <- read.dna("input/PIRARUCU/run3/delimitacao/arapaima.fas", format = "fasta")
MANICORE.fa <- phyDat(alignment, type = "DNA")

# precisa descobrir qual é o melhor modelo
modeltest <- phangorn::modelTest(MANICORE.fa)
modeltest$Model[which.min(modeltest$AIC)]

# load data tree
MANICORE.beast.tr <- ape::read.nexus(here::here("input/PIRARUCU/run3/delimitacao/arapaima.tre"))

# calc NWK
ml.haps.tr <- optim.pml(
  pml(tree = as.phylo(MANICORE.beast.tr), data = phangorn::as.phyDat(MANICORE.fa), model = "GTR", k = 4),
  model = "GTR",
  optInv = TRUE,
  optGamma = TRUE,
  optNni = FALSE,
  optEdge = TRUE
)

# calc TIM2
ml.haps.tr <- optim.pml(
  pml(tree = as.phylo(MANICORE.beast.tr), data = phangorn::as.phyDat(MANICORE.fa), model = "TIM2", k = 4),
  model = "TIM2",
  optInv = TRUE,
  optGamma = TRUE,
  optNni = TRUE,
  optEdge = TRUE
)

# calc TPM1u
ml.haps.tr <- optim.pml(
  pml(
    tree  = as.phylo(MANICORE.beast.tr),
    data  = phangorn::as.phyDat(MANICORE.fa),
    model = "TPM1u",
    k     = 4),
  model    = "TPM1u",
  optInv   = TRUE,
  optGamma = TRUE,
  optNni   = TRUE,
  optEdge  = TRUE)

# calc HKY
ml.haps.tr <- optim.pml(
  pml(tree = as.phylo(MANICORE.beast.tr), data = phangorn::as.phyDat(MANICORE.fa), model = "HKY", k = 4),
  model = "HKY",
  optInv = TRUE,
  optGamma = TRUE,
  optNni = FALSE,
  optEdge = TRUE
)

# plota a árvore
plot(ml.haps.tr)

tr <- midpoint(ml.haps.tr$tree)
is.binary(tr)
sort(tr$edge.length, decreasing = TRUE)
ml.haps.tr$call

# salva a árvore .nwk
write.tree(tr, file = "input/PIRARUCU/run3/delimitacao/arapaima.nwk")
