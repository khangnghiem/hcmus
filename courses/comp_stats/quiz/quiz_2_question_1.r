# Bước 1: Hàm mật độ của phân phối t-Student với location-scale
dt_ls <- function(y, mu, sigma, nu) {
  gamma((nu + 1) / 2) / (sqrt(pi * nu) * gamma(nu / 2) * sigma) *
    (1 + ((y - mu)^2) / (sigma^2 * nu))^(-(nu + 1) / 2)
}

# Bước 2: Thuật toán EM để ước lượng mu, sigma, và nu
EM_t_student <- function(y, max_iter = 100, tol = 1e-6) {
  n <- length(y)
  mu <- mean(y)
  sigma <- sd(y)
  nu <- 5

  for (iter in 1:max_iter) {
    w <- (nu + 1) / (nu + (y - mu)^2 / sigma^2)

    mu_new <- sum(w * y) / sum(w)
    sigma_new <- sqrt(sum(w * (y - mu_new)^2) / n)
    nu_new <- optimize(function(nu) -sum(log(dt_ls(y, mu_new, sigma_new, nu))), c(1, 50))$minimum

    # Test hội tụ
    if (abs(mu - mu_new) < tol && abs(sigma - sigma_new) < tol && abs(nu - nu_new) < tol) {
      break
    }

    mu <- mu_new
    sigma <- sigma_new
    nu <- nu_new
  }

  return(list(mu = mu, sigma = sigma, nu = nu))
}

# Monte Carlo simulation (unchanged)
set.seed(123)
n_sim <- 25
mu_true <- 0
sigma_true <- 1
nu_true <- 5
n_mc <- 1000

results <- matrix(NA, nrow = n_mc, ncol = 3, dimnames = list(NULL, c("mu", "sigma", "nu")))
error_count <- 0

for (i in 1:n_mc) {
  y_sim <- mu_true + sigma_true * rt(n_sim, df = nu_true)
  fit <- try(em_t_location_scale(y_sim), silent = TRUE)

  if (inherits(fit, "try-error") || any(is.na(fit))) {
    error_count <- error_count + 1
    next
  }
  results[i, ] <- c(fit$mu, fit$sigma, fit$nu)
}

# Calculate results
valid_runs <- n_mc - error_count
mu_mean <- mean(results[, "mu"], na.rm = TRUE)
sigma_mean <- mean(results[, "sigma"], na.rm = TRUE)
nu_mean <- mean(results[, "nu"], na.rm = TRUE)

mu_sd <- sd(results[, "mu"], na.rm = TRUE)
sigma_sd <- sd(results[, "sigma"], na.rm = TRUE)
nu_sd <- sd(results[, "nu"], na.rm = TRUE)

mu_bias <- mu_mean - mu_true
sigma_bias <- sigma_mean - sigma_true
nu_bias <- nu_mean - nu_true

cat(
  "Monte Carlo Results (n =", valid_runs, "valid runs):\n",
  "Mean (μ):", round(mu_mean, 4), "Bias:", round(mu_bias, 4), "SD:", round(mu_sd, 4), "\n",
  "Mean (σ):", round(sigma_mean, 4), "Bias:", round(sigma_bias, 4), "SD:", round(sigma_sd, 4), "\n",
  "Mean (ν):", round(nu_mean, 4), "Bias:", round(nu_bias, 4), "SD:", round(nu_sd, 4)
)

# (c) Áp dụng thuật toán EM cho dữ liệu bức xạ mặt trời
radiation_data <- c(
  -26.8, -3.6, -3.4, -1.2, 0.4, 1.3, 2.3, 2.7, 3.0, 3.2, 3.2,
  3.6, 3.6, 3.9, 4.2, 4.4, 6.0, 6.6, 6.7, 7.1, 8.1, 10.6,
  10.7, 24.0, 32.8
)

em_result_radiation <- EM_t_student(radiation_data)
print(em_result_radiation)
