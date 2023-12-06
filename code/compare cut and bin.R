library(tidyverse)
library(nortest)


#all cut data
cut <- readRDS('data/all_cut.RDS')
mean(cut$num_on_top) #25.91134
var(cut$num_on_top) # 5.085286
cut_hist <- ggplot(cut, aes(x=num_on_top, y=after_stat(density))) +
  geom_histogram(binwidth=1, color="white") +
  geom_point(data = data.frame(num_on_top = 0:52) %>% mutate(pmf = dbinom(num_on_top, 52, 0.5)),
             aes(x = num_on_top, y = pmf), color = "red")

number <- c(rep(0,20), table(cut$num_on_top), rep(0,52-33))
chisq.test(number, p=dbinom(0:52, 52, 0.5))

#binomial (mean=26,var=23)
set.seed(52)
n <- 52
p <- 0.5
bin <- data.frame(num=rbinom(688, n, p)) 
mean(bin$num) #26.0218
var(bin$num) # 12.45222
bin_hist <- ggplot(bin,aes(x=num, y=after_stat(density)))+geom_histogram(binwidth=1,color='white')

ggplot() +
  geom_histogram(data = cut, aes(x = num_on_top), binwidth = 1, color = "white", fill='red', alpha = 0.5) +
  geom_histogram(data = bin, aes(x = num), binwidth = 1, color = "white", fill='blue', alpha = 0.5)
