
library(readr)
library(tidyverse)
library(janitor)


#
# Transformei o arquivo em csv para evitar problemas de configuração.
# Na importação já transformei a coluna no formato "Date" de dia, mês e ano.


violenciaf <- read_csv("violenciaf.csv", col_types = cols(data = col_date(format = "%d/%m/%Y")))



##### Conferência dos dados #####  

#ver https://dplyr.tidyverse.org/articles/rowwise.html 

# Quero conferir esta tabela, então começarei a unir por uf

vio01 <- violenciaf %>% group_by(uf) %>% summarise(nrows=nrow(pick(everything())))

# Quando abro vio1, vejo que tem as UFs, mas tem tb um ameaçados de morte e NAs, isso precisa ser corrigido.
# Abra o arquivo no googleplanilhas e cheque (gerei um print no arquivo Captura de tela...).

# Vc deve ir corrigindo/checando cada uma destas inconsistências. Por exemplo, ao lançar o comando abaixo
# visualizei que havia um ano com NA, precisa ir lá e ver o que houve...

vio02 <- violenciaf %>% group_by(ano) %>% summarise(nrows=nrow(pick(everything())))

vio03 <- violenciaf %>% group_by(ocorrencias) %>% summarise(nrows=nrow(pick(everything())))

vio04 <- violenciaf %>% group_by(municipios) %>% summarise(nrows=nrow(pick(everything())))
# no vio4, vc precisa ver se tem cidades com nome repetidos, se tiver precisa arrumar e deixar a mesma escrita.

# se quiser trazer a informação de uf, basta fazer:

vio05 <- violenciaf %>% group_by(municipios, uf) %>% summarise(nrows=nrow(pick(everything())))

# acrescentando a ocorrencia e ano:
vio06 <- violenciaf %>% group_by(municipios, uf, ocorrencias, ano) %>% summarise(nrows=nrow(pick(everything())))



##### Cruzando os dados ####

# ver: https://www.statology.org/dplyr-crosstab/ 

# Quero gerar uma tabela com UF e Ano, tendo como conteúdo o número de ocorrências. 

# Gero a tabela básica.

vio07 <- violenciaf %>% group_by(uf, ano) %>% summarise(nrows=nrow(pick(everything())))

vio08 <- vio07 %>% group_by(uf,ano) %>%
                  tally() %>%
                  spread(ano, n)

## como vc observa, o vio8 não colocou no conteúdo a soma que está na coluna nrows, pois fiz exatamente
## como o exemplo do site. Por isso, para fazer o próximo, inseri a coluna "nrows".

vio09 <- vio07 %>% group_by(uf,ano,nrows) %>%
  tally() %>%
  spread(ano, nrows)

# Agora vamos criar uma coluna que somará todas as ocorrências por UF e uma linha que somará todas por ano.
# se abrir o vio9 no na aba ao lado "environment" observará que as colunas de ano estão como "int" e precisam virar 
# numéricas. 

# Precisa checar se continua sendo da coluna 2 a 9.

vio09 [2:9] <- lapply(vio09[2:9], as.numeric)

# Além disto, preciso remover o NA da tabela

# Na coluna da UF, vou transformar em "ND" de não disponível. e nas demais em zero.

vio09[1] <- vio09 [1] %>% replace(is.na(.), "ND")

# Cria-se a coluna sum com a soma de todas as colunas que são numéricas e ignorando os NAs

vio10 <-  vio09 %>% mutate(sum = rowSums(across(where(is.numeric)), na.rm=TRUE))

# o mesmo para a linha, mas é preciso usar o pacote "Janitor".


vio11 <-  vio10 %>% adorn_totals("row")

