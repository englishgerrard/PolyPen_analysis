source('./Scripts/.PACKAGES.R')
source('./Scripts/.FUNCTIONS.R')

spec_files <- list.files('./Data/spectrapen and ASD data_from_Costanza/', recursive = F, full.names = TRUE)
file_list <- spec_files[grepl('.csv', basename(spec_files))]

################################################################################


read_feild_spec <- function(x){
  
d <- read.csv(file_list[x], skip = 1)

d <- d[,-c(2153:2158)]

df <- d %>%
  pivot_longer(
    cols = -wavelength, # All columns except the first (ID column)
    names_to = "nm", # Column for wavelength values
    values_to = "refl"       # Column for reflection values
  ) %>%
  rename(ID = wavelength) # Rename the first column to "ID"

df$nm <- as.numeric(str_sub(df$nm, 2,-1))
df$tree <-  str_split_i(df$ID, pattern = '_', 2)
df$C_pos. <-  str_split_i(df$ID, pattern = '_', 3)
df$week <- x+1 
df$rep <- as.numeric(gsub("\\D", "", df$tree)) 
df <- add_treatment(df)
df$sensor <- 'FS'
df$device <- 'FS'
return(df)}

df <- bind_rows(lapply(1:4, read_feild_spec))

write.csv(df, './Data/tidy_feildspec.csv')

ggplot(filter(df, C_pos. == 'mc'), aes(x = nm, y = refl, colour = tree, group = ID)) +
  geom_point() +
  facet_wrap(~week)
