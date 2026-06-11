# Criar os objetos das tabelas
tabela1 <- read.csv("input/file_a.csv")
tabela2 <- read.csv("input/file_b.csv")

# Mescla as tabelas
merged_table <- merge(tabela1, tabela2, by = "voucher", all.x = TRUE)

# Salva a tabela mesclada
write_csv(merged_table, "output/table_merged.csv")
