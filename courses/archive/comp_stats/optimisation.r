fx <- function(x) {
    return(log(x) / (1 + x))
}

fx(-1)

x <- seq(1, 5, by = 0.1)
x
fx(x)

plot(x, fx(x))
plot(x, fx(x), type = "l", col = "red", lwd = 2, xlab = "x", ylab = "f(x)", main = "f(x) = log(x) / (1 + x)", sub = "Optimisation")

# bisection method

fx_prime <- function(x) {
    return((1 - log(x)) / (1 + x)^2)
}

fx_prime_2 <- function(x) {
    return((2 * x * log(x) - 2 * x + 1) / (1 + x)^3)
}

plot(x, fx_prime(x), type = "l", col = "blue", lwd = 2, xlab = "x", ylab = "f'(x)", main = "f'(x) = (1 - log(x)) / (1 + x)^2", sub = "Bisection method")
plot(x, fx_prime_2(x), type = "l", col = "blue", lwd = 2, xlab = "x", ylab = "f'(x)", main = "f'(x) = (1 - log(x)) / (1 + x)^2", sub = "Bisection method")

x0 <- (a0 + b0) / 2

# Newton-Raphson method
newton_raphson <- function(f, f_prime, x0, tol = 1e-7, max_iter = 1000) {
    x <- x0
    for (i in 1:max_iter) {
        x_new <- x - f(x) / f_prime(x)
        if (abs(x_new - x) < tol) {
            return(x_new)
        }
        x <- x_new
    }
    stop("Newton-Raphson method did not converge")
}

# Example usage
x0 <- 2 # Initial guess
root <- newton_raphson(fx, fx_prime, x0)
cat("Root found by Newton-Raphson method:", root, "\n")

x1 <- x0 - fx(x0) / fx_prime(x0)
