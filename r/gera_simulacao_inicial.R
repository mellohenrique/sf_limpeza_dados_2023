# Carrega dados
pesos = readxl::read_excel('dados/pesos.xlsx')
alunos = readr::read_csv2('dados/alunos.csv', guess_max = 1e10)
complementos = readr::read_csv2('dados/dados_complementares.csv')

# simulacao
simulacao_inicial = simulador.fundeb::simula_fundeb(
  dados_alunos = alunos,
  dados_complementar = complementos,
  dados_peso = pesos,
  complementacao_vaaf = 22905221182.2,
  complementacao_vaat = 14315763238.90,
  complementacao_vaar = 1717891588.66
)

sum(simulacao_inicial$complemento_vaaf)

# Agregando simulacao inicial
simulacao_inicial_agregada = stats::aggregate(
  list(complemento_uniao = simulacao_inicial$complemento_uniao),
       by = list(uf = simulacao_inicial$uf),
       FUN=sum)

# Salvando resultados para o dashboard
save(complementos, file =  'dados/dash_simulador_fundeb/complementos.rda')
save(alunos, file =  'dados/dash_simulador_fundeb/alunos.rda')
save(pesos, file =  'dados/dash_simulador_fundeb/pesos.rda')
save(simulacao_inicial, file =  '../dash_simulador_fundeb/simulacao_inicial.rda')
save(simulacao_inicial_agregada, file =  'dados/dash_simulador_fundeb/simulacao_inicial_agregada.rda')
