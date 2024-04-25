# Limpa dados de alunos ----

## Carrega dados de alunos ----
alunos = readxl::read_excel('dados/bruto/matriculas.xlsx', na = '-', guess_max = 5e3)

## Seleciona colunas de interesse ----
alunos = alunos[, 2:39]

## Corrige tipo de valores ----
alunos[] = lapply(alunos, as.numeric)
alunos[] = lapply(alunos, function(x){ifelse(is.na(x), 0, x)})

## Corrige nomes das colunas ----
alunos = janitor::clean_names(alunos)

## Salva valores ----
readr::write_excel_csv2(alunos, 'dados/alunos.csv')
