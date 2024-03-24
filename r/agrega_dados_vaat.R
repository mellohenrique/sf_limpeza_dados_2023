# Agrega dados de VAAT ----

## Carrega dados ----
recursos_vaaf = readr::read_csv2('dados/intermediario/recursos_vaaf.csv')
vaar = readr::read_csv2('dados/intermediario/vaar.csv')
recursos_vaat = readr::read_csv2('dados/intermediario/recursos_vaat.csv')
habilitados_vaat = readr::read_csv2('dados/intermediario/habilitados_vaat.csv')

## Carrega dados ----
dados_complementares = merge(recursos_vaaf, recursos_vaat)
dados_complementares = merge(dados_complementares, vaar, all.x = TRUE)
dados_complementares$peso_vaar = ifelse(is.na(dados_complementares$peso_vaar), 0, dados_complementares$peso_vaar)
dados_complementares$inabilitados_vaat = ifelse(dados_complementares$ibge %in% habilitados_vaat$ibge, FALSE, TRUE)

## Salva resultados ----
readr::write_excel_csv2(dados_complementares, 'dados/dados_complementares.csv')
