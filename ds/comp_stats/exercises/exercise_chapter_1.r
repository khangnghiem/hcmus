# 1. R basics

g <- function(x) {
  log(x) / (1 + x)
}
x <- seq(from = 1, to = 7, by = 0.1)

g_y <- g(x)

plot(x = x, y = g_y, type = "l", lty = 1, xlab = "x", ylab = "g(x)")
