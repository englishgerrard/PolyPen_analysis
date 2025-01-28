source('./Scripts/.PACKAGES.R')
source('./Scripts/.FUNCTIONS.R')

sp <- read.csv('./Data/combined_spectra_1nm.csv') %>%
  filter(rep != 16) %>% filter(week != 3)


sp$treeID <- paste0(sp$week, '_', sp$rep)

correlations <- function(x){
tFS <- sp %>% filter( nm == x) %>%
  filter(sensor == 'FS')

tPP <- sp %>% filter( nm == 700) %>%
  filter(sensor == 'NIR')

return(data.frame(nm = x, cor = cor(tFS$refl, tPP$refl)))}


df <- bind_rows(lapply(629:1061, correlations))


# corrlation (feild spec v poly pen) for all trees
ggplot(df, aes( x = nm, y = cor)) +
  geom_point()
summary(lm(refl ~ sensor, data = test))
################################


tFS <-sp %>% filter(nm %in% 629:1061) %>%
  filter(sensor == 'FS') %>%
  arrange(treeID, week, nm)
tPP <- sp %>%
  filter(sensor == 'NIR') %>%
  arrange(treeID, week, nm)


d <- data.frame(rep = tPP$rep, nm = tPP$nm, ppRef = tPP$refl, fsRef = tFS$refl)

c <- d %>% group_by(nm, rep) %>%
  summarize(
    correlation = cor(ppRef, fsRef, use = "complete.obs"),
    .groups = "drop"
  )
  
# absolute corrlation for each tree (3 weeks combined)
ggplot(c, aes(x = nm, y = abs(correlation))) +
  geom_point() +
  facet_wrap(~rep)


