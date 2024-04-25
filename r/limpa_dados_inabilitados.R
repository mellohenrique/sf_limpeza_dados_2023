# Limpa dados de inabilitados para a etapa VAAT

## Carrega dados ----
inabilitados_vaat = purrr::map_dfr(readxl::excel_sheets('dados/bruto/Relacao_de_Entes_VAAT_2023Final.xlsx'),
                        ~readxl::read_excel('dados/bruto/Relacao_de_Entes_VAAT_2023Final.xlsx', sheet = .x))

## Corrige nomes para limpeza
inabilitados_vaat = janitor::clean_names(inabilitados_vaat)

## Criando coluna reduntante de ibge
inabilitados_vaat$ibge = inabilitados_vaat$codigo_ibge

## Criando coluna reduntante de ibge
inabilitados_vaat$verificao =  ifelse(is.na(inabilitados_vaat$veficacao_preliminar_do_disposto_no_4o_do_art_13_da_lei_no_14_113_20), inabilitados_vaat$veficacao_preliminar_do_disposto_no_4o_do_art_13_pendencia_identificada_da_lei_no_14_113_20, inabilitados_vaat$veficacao_preliminar_do_disposto_no_4o_do_art_13_da_lei_no_14_113_20)

## Coluna com entes inabilitados
inabilitados_vaat$inabilitados_vaat = stringr::str_detect(inabilitados_vaat$verificao, 'Inobs')

## Seleciona colunas
inabilitados_vaat = inabilitados_vaat[, c('ibge', 'inabilitados_vaat')]

## Salvando resultados ----
readr::write_excel_csv2(inabilitados_vaat, 'dados/intermediario/inabilitados_vaat.csv')
