# 1.2 Integration methods
Riemann <- function(f, a, b, n) {
    h <- (b - a) / n
    x <- seq(a, b - h, length.out = n)
    sum(f(x) * h)
}

Trapezoidal <- function(f, a, b, n) {
    h <- (b - a) / n
    x <- seq(a, b, length.out = n + 1)
    sum_result <- 0
    for (i in 1:n) {
        sum_result <- sum_result + (f(x[i]) + f(x[i + 1])) * h / 2
    }
    sum_result
}

Simpson <- function(f, a, b, n) {
    h <- (b - a) / n
    x <- seq(a, b, length.out = n + 1)
    sum_result <- 0
    for (i in 1:n) {
        mid <- (x[i] + x[i + 1]) / 2
        sum_result <- sum_result + (f(x[i]) + 4 * f(mid) + f(x[i + 1])) * h / 6
    }
    sum_result
}

# Function to compute Cauchy CDF using numerical integration
cauchy_cdf <- function(t, alpha, theta, method = "simpson", n = 1000) {
    a <- (t - alpha) / theta
    integrand <- function(y) 1 / (1 + y^2)

    if (a == 0) {
        integral <- 0
    } else if (a > 0) {
        integral <- switch(method,
            "riemann" = Riemann(integrand, 0, a, n),
            "trapezoidal" = Trapezoidal(integrand, 0, a, n),
            "simpson" = Simpson(integrand, 0, a, n)
        )
    } else {
        integral <- -switch(method,
            "riemann" = Riemann(integrand, a, 0, n),
            "trapezoidal" = Trapezoidal(integrand, a, 0, n),
            "simpson" = Simpson(integrand, a, 0, n)
        )
    }

    cdf <- 0.5 + integral / pi
    return(cdf)
}

# Example usage and comparison with pcauchy
test_cauchy_cdf <- function(t_values, alpha, theta, n = 1000) {
    for (t in t_values) {
        approx_riemann <- cauchy_cdf(t, alpha, theta, "riemann", n)
        approx_trapezoidal <- cauchy_cdf(t, alpha, theta, "trapezoidal", n)
        approx_simpson <- cauchy_cdf(t, alpha, theta, "simpson", n)
        exact <- pcauchy(t, location = alpha, scale = theta)

        cat(sprintf("\nFor t = %.1f, alpha = %.1f, theta = %.1f:\n", t, alpha, theta))
        cat(sprintf("Riemann:    %.6f\n", approx_riemann))
        cat(sprintf("Trapezoidal:%.6f\n", approx_trapezoidal))
        cat(sprintf("Simpson:    %.6f\n", approx_simpson))
        cat(sprintf("Exact:      %.6f\n", exact))
    }
}

# Test cases
test_cauchy_cdf(t_values = c(-1, 0, 1, 2), alpha = 0, theta = 1)
