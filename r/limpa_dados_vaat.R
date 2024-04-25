# Limpa dados de VAAT ----

## Carrega dados do VAAT ----
recursos_vaat_stn = readxl::read_excel('dados/bruto/ReceitaSTN2021nominalparapublicao.xlsx', na = '-', guess_max = 5e3, skip = 1)
recursos_vaat_programas = readxl::read_excel('dados/bruto/ProgramasUniversais2021nominalparapublicao.xlsx', na = '-', guess_max = 5e3, skip = 1)

## Seleciona colunas de interesse ----
recursos_vaat_stn = recursos_vaat_stn[, c(3, 18)]
recursos_vaat_programas = recursos_vaat_programas[, c(3, 9)]

## Corrige nomes ----
names(recursos_vaat_stn) = c('ibge', 'recursos_vaat_stn')
names(recursos_vaat_programas) = c('ibge', 'recursos_vaat_programas')

# Unindo bases
recursos_vaat = merge(recursos_vaat_stn, recursos_vaat_programas)

# Removendo linhas com totais
recursos_vaat = recursos_vaat[!is.na(recursos_vaat$ibge),]

# Somando valores
recursos_vaat$recursos_vaat = recursos_vaat$recursos_vaat_stn + recursos_vaat$recursos_vaat_programas

# Adicionando inflacao
recursos_vaat$recursos_vaat =  recursos_vaat$recursos_vaat * 1.4432

# Seleciona colunas
recursos_vaat = recursos_vaat[, c('ibge', 'recursos_vaat')]

## Salva valores ----
readr::write_excel_csv2(recursos_vaat, 'dados/intermediario/recursos_vaat.csv')

# Fontes
## Correcao monetaria: https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/vaat/NotaTcnicaSTNn42380CorreoMonetriaVAAT.pdf
