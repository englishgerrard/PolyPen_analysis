# read SpectraPen / PolyPen
source('./Scripts/.PACKAGES.R')
source('./Scripts/func_tidy_spectraPen.R')
# get file names
spec_files <- list.files('./Data/spectrapen and ASD data_from_Costanza/Spectrapen', recursive = TRUE, full.names = TRUE)
spec.csv <- spec_files[grepl('.csv', basename(spec_files))]

# file 1 is in doifferent format
f1 <- read.csv(spec.csv[1])
# so is calculated seperately
df1 <- data.frame(ID = str_sub(strsplit(spec.csv[1], split = '/')[[1]][6], 0,-5),
                  week =  strsplit(spec.csv[1], split = '/')[[1]][5],
                  date = '19/07/2024',
                  time = sapply(1:15, function(x){strsplit(as.character(unname(f1[1,-c(1,17)])), split = ' ')[[x]][2]}),
                  nm = as.numeric(f1$Transmitance[-c(1:4)]),
                  refl = as.numeric(bind_rows(lapply(2:16, function(x){data.frame(r = f1[,x][-c(1:4)])}))$r),
                  rep = rep(1:15, each=256)
)
# the remaing files are tidied and combined with the first 
df <- bind_rows(lapply(spec.csv[2:8], tidy_specpen_data), df1)


# get device
# takes ages to run - should adress this.. put earlier in functions?
# df$device <- sapply(1:29184, function(x){strsplit(df$ID, split = '_')[[x]][3]})


write.csv(df, './Data/tidy_spectrapen.csv')

ggplot(filter(df, device == 'NIR' & nm > 400), aes( x = nm, y = refl, colour = as.factor(rep)))+
  geom_line() +
  facet_wrap(~week)
