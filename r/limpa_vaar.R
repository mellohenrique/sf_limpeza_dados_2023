# Limpa dados de VAAR ----

## Carrega dados do VAAR ----
vaar = readxl::read_excel('dados/bruto/AnexoVPortariaInterm.n7de29.12.2023.xlsx', na = '-', guess_max = 5e3, skip = 2)

## Seleciona colunas de interesse ----
vaar = vaar[, 3:4]

## Corrige nomes das colunas ----
names(vaar) = c('ibge', 'peso_vaar')

## Salva valores ----
readr::write_excel_csv2(vaar, 'dados/intermediario/vaar.csv')
