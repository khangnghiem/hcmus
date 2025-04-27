library(testthat)

y <- c(225, 171, 198, 189, 189, 135, 162, 135, 117, 162)

f <- \(y, theta, alpha) {
  (alpha / theta) * (y / theta)^(alpha - 1) * exp(-(y / theta)^alpha)
}

ll <- \(y, theta, alpha) {
  sum(log(alpha) - log(theta) + (alpha - 1) * log(y) - (alpha - 1) * log(theta) - (y / theta)^alpha)
}

theta_values <- seq(0.1, 400, by = 20)
alpha_values <- seq(0.1, 10, by = 1)

matrix_alpha_theta <- matrix(0, nrow = length(theta_values), ncol = length(alpha_values))

for (i in 1:length(theta_values)) {
  for (j in 1:length(alpha_values)) {
    matrix_alpha_theta[i, j] <- ll(y, theta_values[i], alpha_values[j])
  }
}

print(matrix_alpha_theta)
print(max(matrix_alpha_theta))
print(min(matrix_alpha_theta))

contour(theta_values, alpha_values, matrix_alpha_theta,
  levels = seq(-550, -40, by = 20),
  xlab = "theta_values", ylab = "alpha_values"
)

ll_prime <- \(par, data) {
  n <- length(data)
  res <- numeric(2)
  res[1] <- -n * par[2] / par[1] + sum(data) / par[2]
  res[2] <- n / par[2] - n * log(par[1]) + sum(log(data)) - sum((data / par[1])^par[2] * log(data / par[1]))
}

ll_2_prime <- \(par, data) {
  n <- length(data)
  res <- matrix(0, nrow = 2, ncol = 2)
  res[1, 1] <- n * par[2] / par[1]^2 - par[2] * (par[2] + 1) * sum(data^par[2] / par[1]^(par[2] + 2))
  res[1, 2] <- res[2, 1] <- -n / par[1] + (1 / par[1]^(par[2] + 1)) * sum(data^par[2]) + par[2] * sum(data^par[2] * log(data / par[1]))
  res[2, 2] <- n / par[2]^2 - sum((data / par[1])^par[2] * (log(data / par[1]))^2)
  return(res)
}

# Tests
test_that("ll function returns correct log-likelihood values", {
  expect_equal(ll(y, 200, 2), -55.366, tolerance = 1e-3)
  expect_equal(ll(y, 150, 1.5), -52.123, tolerance = 1e-3)
})

ll_prime(par = c(160, 1), data = y)
solve(ll_2_prime(par = c(160, 1), data = y)) %*%

  par0 <- c(160, 1)
iter <- 10
par_est <- matrix(0, nrow = iter, ncol = 2)

for (i in 1:iter) {
  par_est[i] <- par0 - solve(ll_2_prime(par = par0, data = y)) %*% ll_prime(par = par0, data = y)
  par0 <- par_est[i]
}
