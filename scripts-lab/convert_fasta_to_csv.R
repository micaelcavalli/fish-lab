
library(Biostrings)
library(ape)

# Caminho do arquivo FASTA
fasta_file <- ape::read.FASTA(here::here("assets/COI.fasta"))
# Lê o arquivo FASTA
fasta <- readDNAStringSet(fasta_file)

# Extrai os nomes (headers) e as sequências
names_vec <- names(fasta_file)
seqs <- as.character(fasta_file)

# Cria um dataframe separando os nomes por "_"
names.df <- tibble(name = names_vec, sequence = seqs) %>%
  separate(name, into = paste0("col_", 1:10), sep = "_", fill = "right")

# Salva como CSV
write_csv(names.df, "seqs_coi.csv")


###################################

library(Biostrings)
library(tidyverse)
library(here)

# Lê o arquivo FASTA como DNAStringSet
fasta <- readDNAStringSet(here("assets/COI_SEQREF_AP004439.fasta"))

# Extrai nomes e sequências
names_vec <- names(fasta)
seqs <- as.character(fasta)

# Cria dataframe e separa os nomes por "_"
names.df <- tibble(name = names_vec, sequence = seqs) %>%
  separate(name, into = paste0("col_", 1:10), sep = "_", fill = "right")

# Salva como CSV
write_csv(names.df, "assets/coi_names.csv")

