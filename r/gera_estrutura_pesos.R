# Gera tabela para escrever pesos
## Gera tabela com a estrutura de etapas de ensino que será preenchida a mão

## Carrega dados
alunos = readr::read_csv2('dados/alunos.csv')

## Define base de pesos
pesos = data.frame(etapas = names(alunos)[2:38],
           peso_vaaf = 0,
           peso_vaat = 0)

## Salva tabela
openxlsx::write.xlsx(pesos, 'dados/intermediario/pesos_base.xlsx')
