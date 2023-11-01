library("testthat")
library("tidyverse")

files <- list.files(path = "../../data/shuffling/", 
                    pattern = "csv",
                    recursive = TRUE,
                    full.names = TRUE)

