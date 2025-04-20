x <- c(
    3.91, 4.85, 2.28, 4.06, 3.70, 4.04, 5.46, 3.53, 2.28, 1.96, 2.53, 3.88, 2.22,
    3.47, 4.82, 2.46, 2.99, 2.54, 0.52, 2.50
)


f <- function(x, theta) {
    return((1 - cos(x - theta)) / (2 * pi))
}

log_likelihood <- function(x, theta) {
    return(sum(log(f(x, theta))))
}

theta_values <- seq(-pi, pi, length.out = 1000)
log_likelihood_values <- sapply(theta_values, function(theta) log_likelihood(x, theta))

plot(theta_values, log_likelihood_values,
    type = "l", col = "blue", lwd = 5,
    main = "Log-Likelihood Function"
)

E_x <- function(x, theta) {
    return(sin(theta) + pi)
}

theta_hat <- asin(mean(x) - pi)

print(max(log_likelihood_values))
print(theta_hat)


f_prime <- function(x, theta) {
    return(sin(x - theta) / (2 * pi))
}
f_prime_2 <- function(x, theta) {
    return(cos(x - theta) / (2 * pi))
}

theta <- 2.7
for (i in 1:10000) {
    theta <- theta - f_prime(mean(x), theta) / f_prime_2(mean(x), theta)
}
print(theta)
