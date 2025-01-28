# function uses a nest function within
# using spectra pen files provided by costanza the .csv are read in two parts
# the first contains the spectral data and the seconed the Date and Time info
# the function requires a file pathname to run and the nested function 
# the nested function creates a new data frame by convertiing data from wide to long

tidy_specpen_data <- function(path = './Data/spectrapen and ASD data_from_Costanza/Spectrapen/Spectrapen/week_2/beech_pp_VIS_week2.csv'
){
  Time <- read.csv(path, 
                     sep = "", header = F, fill = T, skip = 1, nrows = 1)
    # the spectral data
    data <- read.csv(path, 
                     skip =5, sep = "", header = F)
    # take only date observations
    date_seq <- seq(from = 2, to =(length(Time)), by = 2)
    # take time observations
    time_seq <- seq(from = 3, to =(length(Time)), by = 2)
    
  df <- bind_rows(lapply(2:(ncol(data)), function(x){
    # the date and time element
   
  
    # create new data frame
    df <- data.frame(ID = str_sub(strsplit(path, split = '/')[[1]][6], 0,-5),
                     week = strsplit(path, split = '/')[[1]][5],
                     date = Time[,c(date_seq)][[(x-1)]],
                     time = Time[,c(time_seq)][[(x-1)]],
                     nm = data[,1],
                     refl = data[,x],
                     rep = (x-1))
    # return this data frame to the larger function
    return(df)
  }
  )
  )
  return(df)
}