# Testa os resultados da simulação em relação aos resultados obtidos pelo INEP;

# Carrega pacotes ----
library(tidyverse)

# Carrega dados ----
## Simulação
simulacao = readr::read_csv2('dados/simulacao/simulacao_inicial.csv')

## Dados brutos
### Alunos
matriculas_teste_bruto = openxlsx2::read_xlsx('dados/bruto/matriculas.xlsx', na.strings =  '-')

### VAAF
#### Recursos
recursos_vaaf_bruto = openxlsx2::read_xlsx('dados/bruto/copy2_of_ReceitaeComplementaoporentefederadoFundeb2023.xlsx', start_row = 2, na.strings = '-')
#### VAAF
vaaf_bruto = openxlsx2::read_xlsx('dados/teste/Portaria Interm. nº 7, de 29.12.2023.xlsx', start_row = 18, na.strings = '-')

### VAAT
vaat_bruto = openxlsx2::read_xlsx('dados/bruto/AnexoIIIPortariaInterm.n7de29.12.2023.xlsx', start_row = 3, na.strings = '-')

### VAAR
vaar_bruto = readxl::read_excel('dados/bruto/AnexoVPortariaInterm.n7de29.12.2023.xlsx', na = '-', guess_max = 5e3, skip = 2)

### Portaria

# Testes ----
## Teste matriculas ----
### Limpando matriculas ----
matriculas_teste = matriculas_teste_bruto %>%
  select(ibge, prop_vaaf = coeficiente_de_distribuicao_vaaf ) %>%
  mutate(across(everything(), as.numeric))

### Teste matriculas vaaf ----
simulacao %>%
  group_by(uf) %>%
  mutate(prop = alunos_vaaf/sum(alunos_vaaf)) %>%
  ungroup() %>%
  select(ibge, prop) %>%
  left_join(matriculas_teste, by = 'ibge') %>%
  mutate(teste = abs(prop - prop_vaaf) > 0.0000005)  %>%
  filter(teste)
  #summarise(mean(teste))

## Teste VAAF entes ----

### Limpando recursos VAAF ----
recursos_teste = recursos_vaaf_bruto %>%
  filter(!`ENTE FEDERADO` %in% c('GOVERNO MUNICIPAL', 'TOTAL GERAL')) %>%
  mutate(uf_cod = `CÓDIGO IBGE` %/% 100000) %>%
  mutate(uf_cod = ifelse(UF == 'DF', 53, uf_cod)) %>%
  fill(uf_cod) %>%
  mutate(ibge = ifelse(is.na(`CÓDIGO IBGE`), uf_cod, `CÓDIGO IBGE`)) %>%
  select(ibge, recursos_vaaf_inicial_planilha = `RECEITA DA CONTRIBUIÇÃO DE ESTADOS E MUNICÍPIOS AO FUNDEB`, recursos_vaaf_final_planilha = `TOTAL DAS RECEITAS ESTIMADAS`)

### Teste recursos vaaf ----
simulacao %>%
  select(ibge, recursos_vaaf, recursos_vaaf_final) %>%
  left_join(recursos_teste) %>%
  mutate(teste_pre = recursos_vaaf - recursos_vaaf_inicial_planilha,
         teste_pos = recursos_vaaf_final - recursos_vaaf_final_planilha) %>%
  summarise(
    recursos_vaaf_inicial = sum(abs(teste_pre) > 1),
    recursos_vaaf_final = mean(abs(teste_pos) > 1)
  )

### Teste VAAF estados ----
#### Limpeza vaaf por estado ----
vaaf = vaaf_bruto[, c(1, 10)] %>%
  set_names(c('uf', 'vaaf_inep')) %>%
  drop_na() %>%
  mutate(uf = str_remove_all(uf, '[:punct:]') %>% str_trim(),
         vaaf_inep = as.numeric(vaaf_inep))

#### Teste VAAF por estado ----
simulacao %>% group_by(uf) %>%
  summarise(vaaf = round(mean(vaaf_final), 2)) %>%
  left_join(vaaf, by = 'uf') %>%
  mutate(teste_vaaf =  abs(vaaf - vaaf_inep)) %>% View()

## VAAT ----
### Limpeza dados vaat ----
vaat = vaat_bruto[,c(3, 4, 5)] %>%
  set_names('ibge', 'vaat_pre_inep', 'vaat_final_inep')

### Teste vaat pre ----
ibge_corretos = simulacao %>%
  filter(!inabilitados_vaat) %>%
  select(ibge, vaat_pre, vaat_final)  %>%
  left_join(vaat, by = 'ibge') %>%
  mutate(teste_pre = abs(round(vaat_pre, 2) - vaat_pre_inep),
         teste_pos = abs(round(vaat_final, 2) - vaat_final_inep)) %>%
  filter(teste_pre > 0 | teste_pos >0 )
  select(ibge, teste)


## VAAR ----
### Limpeza dados vaar ----

vaar = rbind(vaar_bruto_1[, c(2, 7)] %>%
  set_names(c('ibge', 'complementacao_vaar_inep')),
vaar_bruto_2[, c(2, 7)] %>%
  set_names(c('ibge', 'complementacao_vaar_inep'))) %>%
  mutate(complementacao_vaar_inep = ifelse(is.na(complementacao_vaar_inep), 0, complementacao_vaar_inep))

### Teste VAAR estados ----
simulacao %>%
  select(ibge, recursos_vaar) %>%
  left_join(vaar, by = 'ibge') %>%
  mutate(teste = abs(recursos_vaar - complementacao_vaar_inep) < 1) %>%
  pull(teste) %>% all()
