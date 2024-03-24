mapa = sf::read_sf('../mapa_simplificado/BR_Municipios_2022.shp')
mapa = sf::st_as_sf(mapa)

mapa = mapa[, c('CD_MUN', 'geometry')]

names(mapa) = c('ibge', 'geometry')

save(mapa, file = 'dados/dash_simulador_fundeb/mapa.rda')

merge(complementos, mapa)
