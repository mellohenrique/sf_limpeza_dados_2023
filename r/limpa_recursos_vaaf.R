# Limpa dados de VAAR ----

## Carrega dados do VAAR ----
recursos_vaaf = readxl::read_excel('dados/bruto/copy2_of_ReceitaeComplementaoporentefederadoFundeb2023.xlsx', na = '-', guess_max = 5e3, skip = 1)

## Seleciona colunas de interesse ----
recursos_vaaf = recursos_vaaf[, 1:4]

## Corrige nomes das colunas ----
names(recursos_vaaf) = c('uf', 'ibge', 'nome', 'recursos_vaaf')

## Removendo colunas desnecessarias ----
recursos_vaaf = recursos_vaaf[recursos_vaaf$nome != 'TOTAL GERAL',]
recursos_vaaf = recursos_vaaf[recursos_vaaf$nome != 'GOVERNO MUNICIPAL',]

## Corrigindo valores faltantes de ibge ----
recursos_vaaf = tidyr::fill(recursos_vaaf, ibge)
recursos_vaaf$ibge = ifelse(recursos_vaaf$nome == 'GOVERNO DO ESTADO', recursos_vaaf$ibge %/% 100000, recursos_vaaf$ibge)
recursos_vaaf$ibge = ifelse(recursos_vaaf$uf == 'DF', 53, recursos_vaaf$ibge) # Há um erro com essa operação para o DF por não ter municipio

## Adicionando vetores do simulador
recursos_vaaf$nf = 1
recursos_vaaf$nse = 1

## Salva valores ----
readr::write_excel_csv2(recursos_vaaf, 'dados/intermediario/recursos_vaaf.csv')
