
library(readxl)
library(tidyr)
library(dplyr)
library(lubridate)

setwd("D:/User/Documents/mestrado")

Dadosprincipais=read_excel("dados de violencia.xlsx")

#Seleção dos dados Uf=MA
tabela1 = dplyr::filter(Dadosprincipais, uf == "AM")         


# Seleção dos dados uf=AC
tabela2 = dplyr::filter(Dadosprincipais, uf == "AC",ocorrencias == "ameacados de morte")

#Seleção dos dados Uf=MT
tabela3 = dplyr::filter(Dadosprincipais, uf == "MT") 

#Seleção dos dados Uf=PA
tabela4 = dplyr::filter(Dadosprincipais, uf == "PA") 

#Seleção coluna UF, OCORRENCIA,ANO
tabela5=select(Dadosprincipais,uf,ocorrencias,ano)



#Seleção dos dados Uf=AC
tabela7 = dplyr::filter(Dadosprincipais, uf == "AC")


#Seleção dos dados ocorrencias ano=2015
tabela8 = dplyr::filter(Dadosprincipais, ano == "2015")
