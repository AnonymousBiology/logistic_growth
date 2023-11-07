#Script to estimate the model parameters using a linear approximation

install.packages("dplyr")
library(dplyr)

growth_data <- read.csv("/cloud/project/experiment1.csv")

#Case 1. K >> N0, t is small

data_subset1 <- growth_data %>% filter(t<1500) %>% mutate(N_log = log(N))
# is t being small estimated visually based on the graph?

model1 <- lm(N_log ~ t, data_subset1)
summary(model1)
plot(model1)
# N0 = exp(6.8941709)
# r = 0.0100086

#Case 2. N(t) = K

data_subset2 <- growth_data %>% filter(t>2500)

model2 <- lm(N ~ 1, data_subset2)
summary(model2)
# K = 6.00e+10 