# function to add treatmnt bsed on rep number, requires data frame to have plant reps 
# assigne (1:15)
add_treatment <- function(data = data){
  data %>% mutate(treatment = ifelse(rep %in% 1:5, 'control',
                                     ifelse(rep %in% 6:10, 'drought', 'f')))
}