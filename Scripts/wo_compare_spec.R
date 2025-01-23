source('./Scripts/.PACKAGES.R')
source('./Scripts/.FUNCTIONS.R')

fs <- read.csv('./Data/tidy_feildspec.csv') %>% filter(C_pos. == 'mc')
pp <- read.csv('./Data/tidy_spectrapen.csv') 

# adjust rep for poly pen and add treatment coloum
pp$rep <- pp$rep-1
pp <- add_treatment(pp)
pp$sensor <- 'PP'


# combine the two spectra to one data.fram
c_df <-
data.frame(ID = c(fs$ID, pp$ID),
           nm = c(fs$nm, pp$nm),
           refl = c(fs$refl, pp$refl),
           week = c(fs$week, str_split_i(pp$week, pattern = '_', i = 2)),
           rep = c(fs$rep, pp$rep),
           treatment = c(fs$treatment, pp$treatment),
           sensor = c(fs$sensor, pp$sensor),
           device = c(fs$device, pp$device))

m_df <- c_df %>% filter(device != 'VIS') %>%
  group_by(week, treatment, sensor, device, nm) %>%
  summarise_each(mean, c('refl'))


ggplot(m_df, aes(x = nm, y = refl, colour = device, linetype = treatment))+
         geom_line()+
         facet_wrap(~week)

       