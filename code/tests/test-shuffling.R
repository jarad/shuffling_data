source("setup-files.R")

for (i in seq_along(files)) {
  file <- files[i]
  
  d <- readr::read_csv(file, 
                       col_types = "i") %>%
    as.data.frame()
  
  test_that(
    "columns start with order_", 
    expect_true(all(grepl("order_",colnames(d))))
  )
  
  for (c in 1:ncol(d)) {
    cat(c)
    test_that(paste0(file, " column ", c," elements are 1:52"),
              expect_equal(1:52, sort(as.integer(d[,c]))))
  }
}
