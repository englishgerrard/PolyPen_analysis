# function to add treatmnt bsed on rep number, requires data frame to have plant reps 
# assigne (1:15)
add_treatment <- function(data = data){
  data %>% mutate(treatment = ifelse(rep %in% 1:5, 'control',
                                     ifelse(rep %in% 6:10, 'drought', 'f')))
}


## interpolate cpstanzes polypen files
interpolate <- function(x){   
  a <- interpolated_df[[x]]  
  df <- data.frame(ID = unique(a$ID),
                   nm =nm_seq,
                   refl = approx(x = a$nm, y = a$refl,
                                 xout = c(nm_seq))$y)
  df <-  df %>%
    separate(ID, c('tree', 'device', 'sensor', 'week', 'rep'), '_', remove = F)
  return(df)}
