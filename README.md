# Reproducible Research Assignment Questions

## Question 1

### _Annotate the README.md file in your logistic growth repo with more detailed information about the analysis. Add a section on the results and include the estimates for N0, r and K (mention which *.csv file you used). (10)_

This analysis aimed to study the dynamics of population growth of E.coli bacteria based on experimental data recording bacterial cell count over time in a test tube with the starting conditions of 100µl of an isolate of the bacterium and 900µl of growth medium. I picked ```experiment1.csv``` for my analysis. 

**plot_data.R file:** Before constructing a model to fit to my data, I observed the trend in population growth seen in the raw data by plotting population size (Number of cells) on the y-axis against time (minutes) on the x-axis. 
I did with both untransformed and log-transformed population size data. 

_Using ggplot2 package to construct a plot of population size (N) against time_

```
ggplot(aes(t,N), data = growth_data) +
  
  geom_point() +
  
  xlab("time(min)") +
  
  ylab("N(#cells)") +
  
  theme_bw()
```
_Plot showing population size (N) against time_

![Population_size_time_untransformed](https://github.com/poppyjdw/logistic_growth/assets/150140489/daba0304-7484-4d61-a587-4a5f4b0514be)

_Using ggplot2 package to construct a plot of log-transformed population size (N) against time_

```
ggplot(aes(t,N), data = growth_data) +
  
  geom_point() +
  
  xlab("time(min)") +
  
  ylab("log10(N)") +
  
  scale_y_continuous(trans='log10') +
  
  theme_bw()
```
_Plot showing log-transformed population size (N) against time_

![Population_size_time_transformed](https://github.com/poppyjdw/logistic_growth/assets/150140489/9af0c498-61ac-47a3-bb5a-6cbb27805319)

The untransformed plot reveals that the population size followed a logistic growth rate, with an initial phase of exponential growth followed by a plateau in the rate of change of growth as the population approaches carrying capacity. The semilog plot shows this logistic growth as two distinct linear phases: initially log(N) increases linearly with time, and then log(N) remains constant over time after carrying capacity is reached. 

**fit_linear_model.R file:** These two distinct phases of growth were used to construct two linear models that fit to the exponential and plateaued growth rates separately. In this way, growth rate ($r$) could be approximated from the first model, as the change in population size approximately fits the equation $`N(t) = N_0e^{rt}`$ and carrying capacity ($K$) could be approximated from the second model, as the change in population size approximately fits the equation $\lim_{t \to \infty} N(t) = K$

I used visual inspection of the semilog plot to subset the data that would be used for each model: I subset the values of N up to 1500 minutes for the first model and the vales of N beyond 2500 minutes for the second model as these subsets seemed to capture the 2 distinct linear trends. 

_Creating a linear model to describe the exponential phase of growth_

```
data_subset1 <- growth_data %>% filter(t<1500) %>% mutate(N_log = log(N))

model1 <- lm(N_log ~ t, data_subset1)
summary(model1)
```
_Output of this model_

```
Call:
lm(formula = N_log ~ t, data = data_subset1)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.115386  0.000493  0.006264  0.008905  0.044815 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 6.8941709  0.0111720   617.1   <2e-16 ***
t           0.0100086  0.0000133   752.5   <2e-16 ***
---
Signif. codes:  
0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.02877 on 23 degrees of freedom
Multiple R-squared:      1,	Adjusted R-squared:      1 
F-statistic: 5.663e+05 on 1 and 23 DF,  p-value: < 2.2e-16
```
From this, $r$ could be approximated as the slope of the model, 0.0100086, and $N_0$ could be approximated as the exponential of the intercept 6.8941709, which is 986.5075.

_Creating a linear model to describe the plateaued phase of growth_

```
data_subset2 <- growth_data %>% filter(t>2500)

model2 <- lm(N ~ 1, data_subset2)
summary(model2)
```
_Output of this model_

```
Call:
lm(formula = N ~ 1, data = data_subset2)

Residuals:
      Min        1Q    Median        3Q       Max 
-38746766   2069037   2158960   2159147   2159371 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 6.00e+10   1.13e+06   53090   <2e-16 ***
---
Signif. codes:  
0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7324000 on 41 degrees of freedom
```
From this, $K$ could be approximated from the intercept, which is 6.00e+10. 

**plot_data_and_model.R file:** These estimated parameters of $K$, $r$ and $N_0$ could then be used to construct a logistic model that accurately fitted the data. 

_Creating a logistic function_

```
logistic_fun <- function(t) {
  
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  
  return(N)
  
}
```
_Plotting a logistic model of growth with the estimated parameters against the log-transformed values of N_

```
N0 <- exp(6.8941709)  
r <- 0.0100086   
K <- 6.00e+10 

ggplot(aes(t,N), data = growth_data) +
  
  geom_function(fun=logistic_fun, colour="red") +

  xlab("time(min)") +
  
  ylab("log(N)") +
  
  geom_point() + 

  scale_y_continuous(trans='log10') +

  theme_bw()
```
_Plot showing model in red and log-transformed population size in black_

![Logistic_function_plot-2](https://github.com/poppyjdw/logistic_growth/assets/150140489/8fd07039-c6eb-4b13-8779-de4c1cdbcda4)

This plot shows that the model appears to fit quite closely to the actual data, suggesting that my estimated parameters are reasonably accurate. This can be further tested by comparing my estimated $N_0$ value, 986.5075, to the actual number of cells at t = 0, 879. My estimate is a bit off, but some discrepancy is expected given that the model represents the line of best fit through all the data point, which might not all follow this trend perfectly. Nevertheless, having an $N_0$ in a similar range shows that the parameters are reasonably representative of the data. 

## Question 2

### _Use your estimates of N0 and r to calculate the population size at t = 4980 min, assuming that the population grows exponentially. How does it compare to the population size predicted under logistic growth? (10)_ 

Assuming that this population is growing exponentially, population size at t = 4980 can be estimated using the differential equation $`N(t) = N_0e^{rt}`$. 

```
N0 <- exp(6.8941709)
r <- 0.0100086
t <- 4980

N <- N0 * exp(r * t)
N
```
_Estimated value of N_ 
```
4.370846e+24
```
Under logistic growth, the population would have reached carrying capacity by t = 4980, and therefore the population would be estimated using the differential equation $\lim_{t \to \infty} N(t) = K$. 

```
K <- 6.00e+10 

N <- K 
N
```
_Estimated value of N_ 
```
6.00e+10
```
The exponential model therefore predicts a significantly higher population size at t = 4980 than the logistic model (4.370846e+24 is much larger than 6.00e+10), as the growth is never limited by resources to remain at a fixed carrying capacity. If there were a greater abundance of resources to support a higher carrying capacity, there would be less discrepancy between the logistic and exponential models.  

## Question 3

### _Add an R script to your repository that makes a graph comparing the exponential and logistic growth curves (using the same parameter estimates you found). Upload this graph to your repo and include it in the README.md file so it can be viewed in the repo homepage. (20)_ 

This is the code I used to create a plot comparing the growth curves under both models. I defined the equations for both functions before defining the estimated parameters for $N_0$, $r$ and $K$. I defined t as a range of values from 0 to 6000 minutes using the ```seq()``` function so that my plot would cover this range. I used ```geom_function()``` in ggplot to plot the growth curves onto this time sequence, adding a colour legend to distinguish the two models. I also adjusted the y-axis to display log-transformed population sizes and added a dashed line at t = 4980 using the ```geom_vline()``` function to highlight the findings from Question 2. 

The full R script for this code is saved as **Question_3.R** and a png of the graph is saved as **Question_3_Graph.png**

```
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
K <- 6.00e+10
t <- seq(0, 6000, by = 10) 

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
```
_Graph showing a comparison of logistic and exponential growth curves using estimated paramters of E.coli growth rate_ 

![Logistic_Exponential_Comparison_Graph](https://github.com/poppyjdw/logistic_growth/assets/150140489/4fe51adb-a33c-4e50-b002-2d97f29e15b9)


