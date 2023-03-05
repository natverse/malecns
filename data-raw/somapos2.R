soma_sides.csv=read.csv('data-raw/2023-27-2 soma_sides.csv')
head(soma_sides.csv)

soma_sides.csv$instance_side=mcns_soma_side(soma_sides.csv$body, method = 'instance')
soma_sides.csv %>%
  with(table(soma_side, instance_side, useNA = 'i'))

soma_sides.csv %>%
  filter(soma_side!=instance_side) %>%
  write.csv('data-raw/2023-27-2 soma_sides_toreview.csv')

soma_sides.csv %>%
  filter(soma_side!=instance_side) %>%
    googlesheets4::write_sheet(ss = 'https://docs.google.com/spreadsheets/d/1VsjXoEkWKXvqXEF2GapJQRxNTbIai4XeX0wI1_NcJFs/edit#gid=0', sheet = 'v2-instance-mismatch')

soma_sides.csv2 <- soma_sides.csv %>%
  rename(body_id=body) %>%
  mutate(islatest=with_mcns(malevnc::manc_islatest(body_id)))

soma_sides.csv2 %>%
  count(islatest)

soma_sides.csv2 %>%
  filter(!islatest) %>%
  slice_sample(n=20) %>%
  pull(body_id) %>%
  clipr::write_clip()

soma_sides.csv2 %>%
  filter(islatest) %>%
  filter(!is.na(soma_side)) %>%
  select(body_id, soma_side) %>%
  rename(bodyid=body_id) %>%
  write.csv('data-raw/2023-27-2 soma_sides_gj.csv')

soma_sides.csv2 %>%
  filter(islatest) %>%
  filter(!is.na(soma_side)) %>%
  select(body_id, soma_side) %>%
  rename(bodyid=body_id) %>%
  # slice_head(n=100) %>%
  mcns_annotate_body(chunksize = 30, test = F)

soma_sides.csv3 <- soma_sides.csv2 %>%
  filter(islatest) %>%
  mutate(status=mcns_dvid_annotations(body_id)$status)
nrow(mdabb)
soma_sides.csv3 %>%
  count(status)

soma_sides.csv3 %>%
  filter(status %in% c("Anchor", "Prelim Roughly traced", "Primary Anchor", "Roughly traced" )) %>%
  select(body_id, soma_side) %>%
  rename(bodyid=body_id) %>%
  # head
  mcns_annotate_body(chunksize = 30, test = F)


# What about the ones that we didn't record because of updates?

soma_sides.csv2.updated <- soma_sides.csv2 %>%
  filter(!islatest) %>%
  filter(!is.na(soma_side)) %>%
  rename(bodyid.old=body_id) %>%
  mutate(bodyid=mcns_xyz2bodyid(cbind(nx,ny,nz), units='raw')) %>%
  mutate(status=mcns_dvid_annotations(bodyid)$status)

table(soma_sides.csv2.updated$status)


soma_sides.csv2.updated %>%
  filter(!status %in% c("Anchor", "Prelim Roughly traced", "Primary Anchor", "Roughly traced" ) & !is.na(status)) %>%
  filter(!duplicated(bodyid)) %>%
  mcns_scene(open=T)

soma_sides.csv2.updated %>%
  count(islatest=with_mcns(malevnc::manc_islatest(bodyid)))

soma_sides.csv2.updated %>%
  select(bodyid, soma_side) %>%
  filter(!duplicated(bodyid)) %>%
  mcns_annotate_body(chunksize = 30, test = F)

# what about the ones that were up to date but had a bad status
soma_sides.csv3.badstatus <- soma_sides.csv3 %>%
  filter(!status %in% c("Anchor", "Prelim Roughly traced", "Primary Anchor", "Roughly traced" )) %>%
  select(body_id, soma_side) %>%
  rename(bodyid=body_id)
myfun <- function(x,...) {
  sc=mcns_scene(x$bodyid, open = F)
  sc2=fafbseg::ngl_decode_scene(sc)
  sc3=fafbseg::ngl_add_colours(sc2,colours = x, layer = 'seg-v0.3.4')
  browseURL(as.character(sc3))
}

soma_sides.csv3.badstatus %>%
  mutate(col=ifelse(soma_side=='R', 'red', 'green')) %>%
  select(bodyid, col) %>%
  slice_sample(n = 100) %>%
  myfun

# keep the ones with a somaLocation

soma_sides.csv3.badstatus.mnp <-
  soma_sides.csv3.badstatus %>%
  filter(!duplicated(bodyid)) %>%
  with(left_join(., mcns_neuprint_meta(.), by='bodyid')) %>%
  filter(!is.na(somaLocation))

soma_sides.csv3.badstatus.mnp %>% head

soma_sides.csv3.badstatus.mnp %>%
  mutate(islatest=with_mcns(malevnc::manc_islatest(bodyid))) %>%
  count(islatest)

soma_sides.csv3.badstatus.mnp %>%
  select(bodyid, soma_side) %>%
  mcns_annotate_body(chunksize = 100, test = F)
