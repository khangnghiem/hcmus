# 2.1
## a)
# Sample data
data <- c(
  1.77, -0.23, 2.76, 3.80, 3.47, 56.75, -1.34, 4.24, -2.44,
  3.29, 3.71, -2.40, 4.53, -0.07, -1.05, -13.87, -2.53,
  -1.75, 0.27, 43.21
)

# Log-Likelihood Function
log_likelihood <- function(theta) {
  -length(data) * log(1) - sum(log(abs(data - theta)))
}

# Find MLE and graph the log-likelihood function
theta_values <- seq(-15, 15, by = 0.1)
log_likelihood_values <- sapply(theta_values, log_likelihood)

plot(theta_values, log_likelihood_values,
  type = "l",
  main = "Log-Likelihood Function", ylab = "Log-Likelihood", xlab = "θ"
)

# Newton-Raphson Method
newton_raphson <- function(initial_theta, tol = 1e-6, max_iter = 100) {
  theta <- initial_theta
  for (i in 1:max_iter) {
    num <- sum(1 / (data - theta))
    denom <- -sum(1 / abs(data - theta))
    theta_new <- theta - num / denom
    if (abs(theta_new - theta) < tol) {
      return(theta_new)
    }
    theta <- theta_new
  }
  return(theta)
}

# Try starting points
starting_points <- c(-11, -1, 0, 1.5, 4, 4.7, 7, 8, 38)
mle_estimates <- sapply(starting_points, newton_raphson)
mle_estimates

## b)

bisection_method <- function(lower, upper, tol = 1e-6, max_iter = 100) {
  for (i in 1:max_iter) {
    midpoint <- (lower + upper) / 2
    if (log_likelihood(midpoint) > log_likelihood(lower)) {
      upper <- midpoint
    } else {
      lower <- midpoint
    }

    if (abs(upper - lower) < tol) {
      return(midpoint)
    }
  }
  return((lower + upper) / 2)
}

# Bisection method with starting points -1 and 1
theta_bisection <- bisection_method(-1, 1)
theta_bisection

## c) Fixed Point

fixed_point_iteration <- function(initial_theta, alpha, tol = 1e-6, max_iter = 100) {
  theta <- initial_theta
  for (i in 1:max_iter) {
    theta_new <- theta + alpha * (sum(1 / (data - theta)) / -sum(1 / abs(data - theta)))
    if (abs(theta_new - theta) < tol) {
      return(theta_new)
    }
    theta <- theta_new
  }
  return(theta)
}

# Testing different scaling choices
scaling_factors <- c(1, 0.64, 0.25)
results_fixed_point <- sapply(scaling_factors, function(alpha) fixed_point_iteration(-1, alpha))
results_fixed_point

## d) Secant Method

secant_method <- function(theta0, theta1, tol = 1e-6, max_iter = 100) {
  for (i in 1:max_iter) {
    f0 <- log_likelihood(theta0)
    f1 <- log_likelihood(theta1)
    theta2 <- theta1 - f1 * (theta1 - theta0) / (f1 - f0)

    if (abs(theta2 - theta1) < tol) {
      return(theta2)
    }
    theta0 <- theta1
    theta1 <- theta2
  }
  return(theta1)
}

# Run using different starting locations
secant_estimate <- secant_method(-2, -1)
secant_estimate_fail <- secant_method(-3, 3)
secant_estimate
secant_estimate_fail

## e) Comparison

# Compare speed and stability
compare_methods <- function() {
  methods <- list(
    newton = function() sapply(starting_points, newton_raphson),
    bisection = function() bisection_method(-1, 1),
    fixed_point = function() sapply(scaling_factors, function(alpha) fixed_point_iteration(-1, alpha)),
    secant = function() secant_method(-2, -1)
  )

  results <- lapply(methods, function(fn) system.time(fn()))
  return(results)
}

compare_results <- compare_methods()
compare_results
