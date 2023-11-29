library(ggplot2)

#all cut data
cut <- readRDS('data/all_cut.RDS')
mean(cut$num_on_top) #25.91134
var(cut$num_on_top) # 5.085286
cut_hist <- ggplot(cut, aes(x=num_on_top, y=after_stat(density)))+geom_histogram(binwidth=1, color="white")

#binomial (mean=26,var=23)
set.seed(52)
n <- 52
p <- 0.5
bin <- data.frame(num=rbinom(688, n, p)) 
mean(bin$num) #26.0218
var(bin$num) # 12.45222
bin_hist <- ggplot(bin,aes(x=num, y=after_stat(density)))+geom_histogram(binwidth=1,color='white')

ggplot() +
  geom_histogram(data = cut, aes(x = num_on_top), binwidth = 1, color = "white", fill='red') +
  geom_histogram(data = bin, aes(x = num), binwidth = 1, color = "white", fill='blue')
