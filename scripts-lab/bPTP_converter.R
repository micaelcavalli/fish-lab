
###############################
##### bPTP converter ##########
###############################

input_file <- here::here("input/PIRARUCU/run3/delimitacao/arapaima.nwk.bPTP_input.txt")

# Ler o conteúdo do arquivo como texto
lines <- readLines(input_file)

# Inicializar vetores para armazenar os dados
labels <- c()
bptp <- c()

# Loop para extrair Species ID e os nomes
for (i in seq_along(lines)) {
  line <- lines[i]
  
  # Detecta o início de uma nova espécie
  if (grepl("^Species [0-9]+", line)) {
    specie_id <- sub("^Species ([0-9]+).*", "\\1", line)  # pega apenas o número
    
    # A próxima linha contém os IDs, então pegamos ela
    i <- i + 1
    id_line <- lines[i]
    
    # Dividir a linha de IDs e limpar espaços
    id_list <- unlist(strsplit(id_line, ","))
    id_list <- trimws(id_list)
    
    # Armazenar os dados
    labels <- c(labels, id_list)
    bptp <- c(bptp, rep(specie_id, length(id_list)))
  }
}

# Criar um data frame sem nomes de colunas
df <- data.frame(labels, bptp, stringsAsFactors = FALSE)
df

# Salvar CSV sem nomes de colunas e sem aspas
write.table(df, file = "input/PIRARUCU/run3/delimitacao/arapaima.nwk.bPTP_output.csv", 
            sep = ",", row.names = FALSE, col.names = FALSE, quote = FALSE)
