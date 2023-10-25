# From https://gist.github.com/jarad/8f3b79b33489828ab8244e82a4a0c5b3

library("dplyr")
library("tidyr")
library("readr")

read_shuffling_csv = function(f, into) {
  readr::read_csv(f) %>%
    dplyr::mutate(file = f) %>%
    tidyr::separate(file, into) 
}

read_shuffling_dir = function(path, pattern, into) {
  files = list.files(path       = path,
                     pattern    = pattern,
                     recursive  = TRUE,
                     full.names = TRUE)
  plyr::ldply(files, read_shuffling_csv, into = into)
}

# Above from https://gist.github.com/jarad/8f3b79b33489828ab8244e82a4a0c5b3
####################################################################################

d <- read_shuffling_dir("data/shuffling/", "csv", 
                 into = c("data", "shuffling", "researcher",
                          "year", "month", "day", "shuffler",
                          "csv")) %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-"))) %>%
  select(-data, -shuffling, -csv, -researcher, 
         -year, -month, -day)
