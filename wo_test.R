library(tidyverse)
# read SpectraPen / PolyPen
source('./Scripts/func_tidy_spectraPen.R')
# get file names
spec_files <- list.files('./Data/spectrapen and ASD data_from_Costanza/Spectrapen', recursive = TRUE, full.names = TRUE)
spec.csv <- spec_files[grepl('.csv', basename(spec_files))]

spec.csv[1:3]

# file 1 is in doifferent format
df <- bind_rows(lapply(spec.csv[2:8], tidy_specpen_data))

tidy_specpen_data(path ="./Data/spectrapen and ASD data_from_Costanza/Spectrapen/week_2/beech_pp_NIR_week2.csv")

tidy_specpen_data(path = './Data/spectrapen and ASD data_from_Costanza/Spectrapen/week_3/beech_pp_VIS_week3.csv'
)
