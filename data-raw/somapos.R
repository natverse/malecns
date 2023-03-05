soma_sides.csv=read.csv('data-raw/2023-21-2 soma_sides.csv')
head(soma_sides.csv)
library(dplyr)

soma_sides.csv %>%
  count(soma_side)

nopen3d()
soma_sides.csv%>%
  with(points3d(8*cbind(nx,ny,nz), col=c("red","blue", "green")[factor(soma_side)]))

soma_sides.csv.nm <- soma_sides.csv%>%
  mutate(x=8*nx, y=8*ny, z=8*nz)
somalm <- soma_sides.csv.nm %>%
  # mutate(soma_side=factor(soma_side)) %>%
  mutate(isright=soma_side=='R') %>%
  lm(isright~x+y+z, data=.)

table(predict(somalm)>0.5, soma_sides.csv.nm$soma_side)

soma_sides.csv.nm$psoma=predict(somalm)

soma_sides.csv.nm %>%
  filter(psoma>0.5 & soma_side=='L') %>%
  mutate(bodyid=body) %>%
  mcns_scene(open = T)


soma_sides.csv.nm %>%
  select(-(nx:nz)) %>%
  filter(psoma>0.5 & soma_side=='L' | psoma<0.5 & soma_side=='R') %>%
  mutate(bodyid=body) %>%
  write.csv('data-raw/2023-21-2 soma_sides_toreview.csv')


soma_sides.csv.nm %>%
  select(-(nx:nz)) %>%
  filter(psoma>0.5 & soma_side=='L' | psoma<0.5 & soma_side=='R') %>%
  mutate(bodyid=body) %>%
  googlesheets4::write_sheet(ss = 'https://docs.google.com/spreadsheets/d/1VsjXoEkWKXvqXEF2GapJQRxNTbIai4XeX0wI1_NcJFs/edit#gid=0', sheet = 'lrmismatch')


