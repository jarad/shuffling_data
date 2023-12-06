setwd("~/Desktop/research/shuffling/shuffling_data/data")
library("dplyr")
library("tidyr")
library("readr")

# cut function 
cut <- function(original_order, shuffle_order) {
  cut_index <- which(original_order != shuffle_order)[1]
  cut_num <- shuffle_order[cut_index]
  order_in_original <- which(original_order == cut_num)
  top_half <- original_order[((order_in_original):52) + 1]
  return(length(top_half))
}

process_file <- function(file_path) {
  df <- read.csv(file_path)
  top_half_lengths <- numeric(ncol(df) - 1)
  for (i in 1:(ncol(df) - 1)) {
    original_order <- df[, i]
    shuffle_order <- df[, i + 1]
    top_half_lengths[i] <- cut(original_order, shuffle_order)
  }
  df_top_half <- data.frame(top_half_number = top_half_lengths)
  return(df_top_half)
}

# read in all csv files
base_dir <- "shuffling/Fiona"
file_paths <- list.files(path = base_dir, pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)



#file_paths <- c('shuffling/Fiona/2023/10/01/8b78cae.csv','shuffling/Fiona/2023/10/02/c36c55.csv', 'shuffling/Fiona/2023/10/02/049ca4.csv',
#               'shuffling/Fiona/2023/10/02/9de59a.csv', 'shuffling/Fiona/2023/10/03/977aaa.csv', 'shuffling/Fiona/2023/10/03/56d382.csv',
#               'shuffling/Fiona/2023/10/14/2b5fb0.csv', 'shuffling/Fiona/2023/10/20/675263.csv', 'shuffling/Fiona/2023/10/21/56d382.csv',
#               'shuffling/Fiona/2023/10/21/8b78ca.csv', 'shuffling/Fiona/2023/10/24/c36c55.csv', 'shuffling/Fiona/2023/10/24/9de59a.csv',
#               'shuffling/Fiona/2023/10/25/2b5fb0.csv', 'shuffling/Fiona/2023/10/26/2b5fb0.csv', 'shuffling/Fiona/2023/10/27/2b5fb0.csv',
#               'shuffling/Fiona/2023/10/27/c36c55.csv', 'shuffling/Fiona/2023/10/31/2b5fb0.csv', 'shuffling/Fiona/2023/11/3/c36c55.csv',
#               'shuffling/Fiona/2023/11/3/0a50ea.csv',  'shuffling/Fiona/2023/11/4/8b78ca.csv',  'shuffling/Fiona/2023/11/5/c36c55.csv',
#               'shuffling/Fiona/2023/11/5/9de59a.csv',  'shuffling/Fiona/2023/11/18/2b5fb0.csv', 'shuffling/Fiona/2023/11/19/2b5fb0.csv',
#               'shuffling/Fiona/2023/11/20/2b5fb0.csv', 'shuffling/Fiona/2023/11/21/2b5fb0.csv', 'shuffling/Fiona/2023/11/22/2b5fb0.csv',
#               'shuffling/Fiona/2023/11/27/2b5fb0.csv', 'shuffling/Fiona/2023/11/28/2b5fb0.csv')

results <- lapply(file_paths, process_file)
combined_results <- do.call(rbind, results)
print(combined_results)
saveRDS(combined_results, file = "cut_from_shuffling.RDS")

# analysis
library(ggplot2)
ggplot(combined_results, aes(x=top_half_number, y=after_stat(density))) +
  geom_histogram(binwidth=1, color="white") +
  geom_point(data = data.frame(num_on_top = 0:52) %>% mutate(pmf = dbinom(num_on_top, 52, 0.5)),
             aes(x = num_on_top, y = pmf), color = "red")

min(combined_results$top_half_number)
number <- c(rep(0,18), table(combined_results$top_half_number), rep(0,52-33))
chisq.test(number, p=dbinom(0:52, 52, 0.5))
