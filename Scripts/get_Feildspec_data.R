source('./Scripts/.PACKAGES.R')

spec_files <- list.files('./Data/spectrapen and ASD data_from_Costanza/', recursive = F, full.names = TRUE)
file_list <- spec_files[grepl('.csv', basename(spec_files))]

read_feild_spec <- function(x){

d <- read.csv(file_list[x])

reflectance_list <- bind_rows(lapply(2:2152, function(x){data.frame(R = d[-1,x])}))
unique(d[1,])

df <- data.frame(ID = rep(d[-1,1], each =2151),
           nm = 350:2500,
           refl = reflectance_list$R,
           week = x+1
           )
df$tree <-  str_split_i(df$ID, pattern = '_', 2)
df$C_pos. <-  str_split_i(df$ID, pattern = '_', 3)
return(df)}

df <- bind_rows(lapply(1:4, read_feild_spec))

write.csv(df, './Data/tidy_feildspec.csv')
