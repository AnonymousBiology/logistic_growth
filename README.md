1) (10 points) Annotate the README.md file in your logistic growth repo with more detailed information about the analysis. Add a section on the results and include the estimates for N0, r and K (mention which *.csv file you used).

This analysis aimed to study the dynamics of population growth of E.coli bacteria based on experimental data recording bacterial cell count over time in a test tube with the starting conditions of 100µl of an isolate of the bacterium and 900µl growth medium. 

  N0 <- exp(6.8941709) 
  
  r <- 0.0100086 #
  
  K <- 6.00e+10

2) (10 points) Use your estimates of N0 and r to calculate the population
size at t = 4980 min, assuming that the population grows exponentially.
How does it compare to the population size predicted under logistic
growth?

Since this is during the exponential phase, use the equation: 

# Given values
N0 <- exp(6.8941709)
r <- 0.0100086
t <- 4980

# Calculate N(t)
Nt <- N0 * exp(r * t)

N(t) = 4.370846e+24

Under the logistic model, N(t) is calculated using the following equation: N(t) = K. 
This produces a value of 6.00e+10, signiifcantly lower than the population size predicted under the exponential growth model as this model assumes that the resources (growth medium) in the culture eventually limit the population growth such that it remains at a fixed carrying capacity. 

3) (20 points) Add an R script to your repository that makes a graph
comparing the exponential and logistic growth curves (using the same
parameter estimates you found). Upload this graph to your repo and
include it in the README.md file so it can be viewed in the repo
homepage.

(https://github.com/poppyjdw/logistic_growth/assets/150140489/966c096f-db77-4ed8-8910-215c630736


