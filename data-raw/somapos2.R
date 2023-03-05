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

soma_sides.csv2 %>%
  filter(!islatest) %>%
  filter(!is.na(soma_side)) %>%
  rename(bodyid.old=body_id) %>%
  mutate(bodyid=with_mcns(malevnc::manc_xyz2bodyid()))
  select(body_id, soma_side) %>%

