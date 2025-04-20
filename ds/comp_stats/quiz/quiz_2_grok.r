library(MASS) # Hỗ trợ tính toán phân phối t
library(stats4) # Hỗ trợ tối ưu hóa

# Hàm EM ước lượng mu, sigma, nu với kiểm tra ổn định
em_t_location_scale <- function(y, mu_init = median(y), sigma_init = mad(y), nu_init = 5, max_iter = 1000, tol = 1e-6) {
  n <- length(y)
  mu <- mu_init
  sigma <- ifelse(sigma_init == 0, 1, sigma_init) # Tránh sigma = 0
  nu <- max(nu_init, 2) # Nu >= 2 để tránh phân kỳ

  for (iter in 1:max_iter) {
    # E-step: Tính tau theo công thức chuẩn
    residuals <- (y - mu) / sigma
    tau <- (nu / 2 + 0.5) / (nu / 2 + residuals^2 / 2)

    # Kiểm tra NaN/Inf trong tau
    if (any(is.na(tau)) || any(tau <= 0)) {
      warning("tau không ổn định. Đặt lại tham số.")
      break
    }

    # M-step: Cập nhật mu và sigma
    mu_new <- sum(tau * y) / sum(tau)
    sigma_new <- sqrt(sum(tau * (y - mu_new)^2) / n)

    # Cập nhật nu bằng phương pháp Brent
    objective_nu <- function(nu) {
      term1 <- digamma(nu / 2 + 0.5) - log(nu / 2)
      term2 <- mean(log(tau) - tau)
      term1 - term2
    }

    # Tìm nghiệm nu trong khoảng [2, 100]
    sol <- try(uniroot(objective_nu, interval = c(2, 100), extendInt = "yes"), silent = TRUE)
    if (inherits(sol, "try-error")) {
      warning("Không tìm được nu. Sử dụng giá trị trước đó.")
      nu_new <- nu
    } else {
      nu_new <- sol$root
    }

    # Kiểm tra hội tụ
    if (max(abs(mu_new - mu), abs(sigma_new - sigma), abs(nu_new - nu)) < tol) {
      break
    }
    mu <- mu_new
    sigma <- sigma_new
    nu <- nu_new
  }

  return(list(mu = mu, sigma = sigma, nu = nu, iter = iter))
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


# Áp dụng cho dữ liệu thực tế
data <- c(
  -26.8, -3.6, -3.4, -1.2, 0.4, 1.3, 2.3, 2.7, 3.0, 3.2, 3.2, 3.6, 3.6,
  3.9, 4.2, 4.4, 6.0, 6.6, 6.7, 7.1, 8.1, 10.6, 10.7, 24.0, 32.8
)

fit_real <- em_t_location_scale(data)
cat(
  "Ước lượng ổn định:\n",
  "mu =", round(fit_real$mu, 3),
  "\n sigma =", round(fit_real$sigma, 3),
  "\n nu =", round(fit_real$nu, 3),
  "\n Số lần lặp:", fit_real$iter
)
