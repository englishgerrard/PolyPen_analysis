source('./Scripts/.PACKAGES.R')
source('./Scripts/.FUNCTIONS.R')

pp <- read.csv('./Data/tidy_spectrapen.csv') 

# adjust rep for poly pen and add treatment coloum
pp$rep <- pp$rep-1
pp <- add_treatment(pp)
pp$sensor <- 'PP'

pp$ID <- paste0(pp$ID,'_',pp$rep)

pp_v <- pp %>% filter(device == 'VIS')

interpolated_df <- pp_v %>%
  group_by(ID) %>%
  group_split() 

nm_seq <- seq(from = 323, to =793, by =1)   
int_v <- bind_rows(lapply(1:56, interpolate))

pp_n <- pp %>% filter(device == 'NIR')
interpolated_df <- pp_n %>%
  group_by(ID) %>%
  group_split() 

nm_seq <- seq(from = 628, to =1062, by =1)   
int_n <- bind_rows(lapply(1:58, interpolate))

inter<-na.omit(bind_rows(int_v, int_n))
write.csv(inter, './Data/interpolated_polypen.csv')

