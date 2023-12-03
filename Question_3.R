logistic_fun <- function(t) {
  
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  
  return(N)
  
}

exponential_fun <- function(t) {
  
  N <- (N0*exp(r*t))
  
  return(N)
}


N0 <- exp(6.8941709)
r <- 0.0100086
t <- seq(0, 6000, by = 10) 
K <- 6.00e+10

library(ggplot2)

ggplot(data.frame(t), aes(x = t)) +
  geom_function(fun = logistic_fun, aes(colour = "Logistic"), size = 0.5) +
  geom_function(fun = exponential_fun, aes(colour = "Exponential"), size = 0.5) +
  geom_vline(xintercept = 4980, linetype = "dashed", color = "black", size = 0.5, alpha = 0.6) +  # Add vertical line
  scale_color_manual(values = c("Logistic" = "red", "Exponential" = "blue"),
                     name = "Growth curve") +
  scale_y_continuous(trans = "log10") +
  labs(x = "t (minutes)", y = "log(N)") +
  theme_bw()

ggsave("Question_3_Graph.png", width = 8, height = 6, dpi = 600)
