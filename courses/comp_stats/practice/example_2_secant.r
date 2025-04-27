cauchy_data <- c(
    1.77, -0.23, 2.76, 3.80, 3.47, 56.75, -1.34, 4.24, -2.44, 3.29, 3.71,
    -2.40, 4.53, -0.07, -1.05, -13.87, -2.53, -1.75, 0.27, 43.21
)

ll_c <- function(theta, obs) {
    # Compute log-lik for obs and a value of thet (location)
    logl <- sum(dcauchy(obs, location = theta, scale = 1, log = T))
    return(logl)
}

# Loop for possible values of theta(obs given)
x <- seq(from = -10, to = 10, by = 0.1)
ll <- NULL
for (i in x)
{
    ll <- c(ll, ll_c(i, obs))
}

# Plot log-lik vs possible value of theta
plot(x, ll)
