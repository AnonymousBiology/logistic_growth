#Script to plot data and model

growth_data <- read.csv("/cloud/project/experiment1.csv")

logistic_fun <- function(t) {
  
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  
  return(N)
  
}

# based on 2 linear models 

N0 <- exp(6.8941709) # not exactly same because of irregularity of data 
  
r <- 0.0100086 #
  
K <- 6.00e+10 #

ggplot(aes(t,N), data = growth_data) +
  
  geom_function(fun=logistic_fun, colour="red") +
  
  xlab("time(min)") +
  
  ylab("log(N)") +
  
  geom_point() + 

  scale_y_continuous(trans='log10') + 
  theme_bw()

ggsave("Logistic_function_plot.png", width = 8, height = 6, dpi = 600)


