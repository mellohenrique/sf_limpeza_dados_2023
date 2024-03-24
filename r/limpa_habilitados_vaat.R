# Limpa dados de inabilitados_vaat inabilitados

## Carrega dados ----
habilitados_vaat = readxl::read_excel('dados/intermediario/AnexoIIIPortariaInterm.n7de29.12.2023.xlsx', skip = 2, na = '-')

## Altera nome
habilitados_vaat$ibge = habilitados_vaat$`Código IBGE`

## Criando coluna reduntante de ibge

## Seleciona colunas
habilitados_vaat = habilitados_vaat[, c('ibge')]

## Salvando resultados ----
readr::write_excel_csv2(habilitados_vaat, 'dados/intermediario/habilitados_vaat.csv')
