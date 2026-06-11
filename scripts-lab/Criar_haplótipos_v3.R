#################################
########## HAPLOTYPES ###########
#################################

# 1. Instalar os pacotes (se ainda não o fez)
install.packages("haplotypes", dependencies = TRUE)
install.packages("seqinr", dependencies = TRUE)

# 2. Carregar os pacotes
library(haplotypes)
library(seqinr)

# 3. Ler o arquivo FASTA (alinhamento)
ali_geral <- read.fas(file = "input/gymnotus-edited.fasta")

# 4. Calcular a distância das sequências (opcional, para conferência)
d <- haplotypes::distance(ali_geral, indels = "missing")
print(d)

# 5. Detectar os haplótipos
h <- haplotype(ali_geral, indels = "missing")
print(h)

# 6. Obter vetor associando sequência original ao haplótipo (número)
hapind <- h@hapind

# 7. Identificar a sequência original que representa cada haplótipo (primeira sequência que o possui)
unique_haplo <- unique(hapind)
representantes <- sapply(h@haplist, `[`, 1)
representantes

# representantes <- sapply(unique_haplo, function(hap_num) {
#   names(hapind[hapind == hap_num])[1]
# })

# 8. Converter os haplótipos para objeto DNAbin
haplotypes_dna <- as.dna(h)

# 9. Converter DNAbin para lista de vetores de caracteres
seq_list <- lapply(as.list(haplotypes_dna), as.character)

# 10. Atribuir nomes das sequências originais representativas aos haplótipos
names(seq_list) <- representantes

# 11. Criar pasta de saída se não existir
if (!dir.exists("output")) {
  dir.create("output")
}

# 12. Exportar os haplótipos para arquivo FASTA com nomes originais representativos
write.fasta(sequences = seq_list,
            names = names(seq_list),
            file.out = "input/gymnotus_hap.fas")

print("Arquivo FASTA exportado com nomes originais representativos.")

# 13. Criar matriz de presença/ausência: linhas = sequências originais, colunas = haplótipos
seq_names <- names(hapind)

# aqui foi alterado
seq_names <- unique(unlist(lapply(h@hapind, names)))
haplo_labels <- paste0("hap", seq_along(h@hapind))
haplo_labels
pa_matrix <- matrix(
  0,
  nrow = length(seq_names),
  ncol = length(h@hapind),
  dimnames = list(seq_names, haplo_labels)
)
for (i in seq_along(h@hapind)) {
  pa_matrix[names(h@hapind[[i]]), i] <- 1
}
head(pa_matrix)
write.csv(pa_matrix, "input/PIRARUCU/run1/arapaima_hap_presence_absence.csv")

# delimtools
sample_hap <- data.frame(
  unlist(lapply(h@hapind, names)),
  rep(seq_along(h@hapind),
      times = sapply(h@hapind, length))
)
head(sample_hap)

write.table(sample_hap,
            "input/PIRARUCU/run1/arapaima_hap2.csv",
            sep = ",",
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE)

#####################################

# original
haplo_labels <- paste0("hap", sort(unique(hapind)))

# inicializa matriz com zeros
haplo_freq <- matrix(0, nrow = length(seq_names), ncol = length(haplo_labels),
                     dimnames = list(seq_names, haplo_labels))

# preencher matriz: 1 onde sequência pertence ao haplótipo
for(i in seq_along(hapind)) {
  haplo_name <- paste0("hap", hapind[i])
  haplo_freq[i, haplo_name] <- 1
}

# 14. Salvar matriz de presença/ausência em CSV
write.csv(haplo_freq, file = "output/matriz_presenca_ausencia.csv", row.names = TRUE)

print("Matriz de presença/ausência exportada para output/matriz_presenca_ausencia.csv")
