# (a) Hàm tính ước lượng Importance Sampling
importance_sampling <- function(n, proposal_sd = 1) {
    x <- rnorm(n, 0, proposal_sd)
    w <- exp(-abs(x)^3 / 3) / dnorm(x, 0, proposal_sd)
    sigma2_est <- sum(x^2 * w) / sum(w)
    return(sigma2_est)
}

print(importance_sampling(1000))

# (b) Hàm tính ước lượng Riemann Sum
riemann_estimator <- function(n_samples_mcmc, step_size = 1, burn_in = 1000) {
    samples <- numeric(n_samples_mcmc + burn_in)
    current <- 0
    for (i in 1:(n_samples_mcmc + burn_in)) {
        y <- rnorm(1, current, step_size)
        log_alpha <- (-abs(y)^3 / 3) - (-abs(current)^3 / 3)
        if (log(runif(1)) < log_alpha) current <- y
        samples[i] <- current
    }
    samples <- samples[(burn_in + 1):(n_samples_mcmc + burn_in)]
    sorted_samples <- sort(samples)
    n <- length(sorted_samples)
    sum_num <- sum_den <- 0
    for (i in 1:(n - 1)) {
        delta <- sorted_samples[i + 1] - sorted_samples[i]
        h_val <- exp(-abs(sorted_samples[i])^3 / 3)
        sum_num <- sum_num + sorted_samples[i]^2 * delta * h_val
        sum_den <- sum_den + delta * h_val
    }
    return(sum_num / sum_den)
}


# (c) Giá trị thực của σ²
sigma2_true <- 3^(2 / 3) / gamma(1 / 3) # ≈ 0.7762

n_sim <- 100
n_a <- 1e4
n_b <- 1e4

results_a <- replicate(n_sim, importance_sampling(n_a))
results_b <- replicate(n_sim, riemann_estimator(n_b))

# Tính các thống kê
bias_a <- mean(results_a) - sigma2_true
var_a <- var(results_a)
mse_a <- mean((results_a - sigma2_true)^2)

bias_b <- mean(results_b) - sigma2_true
var_b <- var(results_b)
mse_b <- mean((results_b - sigma2_true)^2)

cat("Phương pháp (a):\nBias:", bias_a, "\nPhương sai:", var_a, "\nMSE:", mse_a, "\n")
cat("Phương pháp (b):\nBias:", bias_b, "\nPhương sai:", var_b, "\nMSE:", mse_b, "\n")
