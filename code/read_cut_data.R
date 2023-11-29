
library("dplyr")
library("tidyr")
library("readr")

read_cut_csv = function(f, into) {
  readr::read_csv(f) %>%
    dplyr::mutate(file = f) %>%
    tidyr::separate(file, into) 
}

read_cut_dir = function(path, pattern, into) {
  files = list.files(path       = path,
                     pattern    = pattern,
                     recursive  = TRUE,
                     full.names = TRUE)
  plyr::ldply(files, read_cut_csv, into = into)
}

# Above from https://gist.github.com/jarad/8f3b79b33489828ab8244e82a4a0c5b3
####################################################################################

d <- read_cut_dir("data/cut/", "csv", 
                        into = c("data", "cut", "researcher",
                                 "year", "month", "day", "shuffler",
                                 "csv")) %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-"))) %>%
  select(-data, -cut, -csv, -researcher, 
         -year, -month, -day)

saveRDS(d, file = "data/all_cut.RDS")
