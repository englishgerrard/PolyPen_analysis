source('./Scripts/.PACKAGES.R')
source('./Scripts/.FUNCTIONS.R')

fs <- read.csv('./Data/tidy_feildspec.csv') %>% filter(C_pos. == 'mc')
pp <- read.csv('./Data/interpolated_polypen.csv') 

pp <- add_treatment(pp)


pp$numbers <- lapply(pp$week, function(x) regmatches(x, gregexpr("\\d+", x))[[1]])
pp$week <- sapply(pp$numbers, paste, collapse = ", ")


# combine the two spectra to one data.frame
c_df <-
data.frame(ID = c(fs$ID, pp$ID),
           nm = c(fs$nm, pp$nm),
           refl = c(fs$refl, pp$refl),
           week = c(fs$week, pp$week),
           rep = c(fs$rep, pp$rep),
           treatment = c(fs$treatment, pp$treatment),
           sensor = c(fs$sensor, pp$sensor),
           device = c(fs$device, pp$device))

m_df <- c_df %>% filter(device != 'VIS') %>%
  group_by(week, treatment, sensor, device, nm) %>%
  summarise_each(mean, c('refl'))

write.csv(c_df, './Data/combined_spectra_1nm.csv')


ggplot(m_df, aes(x = nm, y = refl, colour = device, linetype = treatment))+
         geom_line()+
         facet_wrap(~week)

ggsave('./inital_plot.png', dpi = 300)
       