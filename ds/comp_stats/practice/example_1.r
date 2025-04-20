f <- function(x) {
    log(x) / (1 + x)
}
f_prime <- function(x) {
    (1 + (1 / x) - log(x)) / ((1 + x)^2)
}

# Plot f_prime
curve(f_prime, from = 0.1, to = 10, col = "blue", lwd = 2, ylab = "f_prime(x)", xlab = "x")
abline(h = 0, col = "red", lty = 2)
print(f_prime(5))

## khoi tao khoang bat dau va diem bat dau
a <- 1
b <- 5
x <- a + (b - a) / 2


## xac dinh so vong lap
itr <- 40
res_a <- a
res_b <- b
res_x <- x

## MAIN
for (i in 1:itr) {
    if (f_prime(a) * f_prime(x) <= 0) {
        res_a[i + 1] <- a
        res_b[i + 1] <- b <- x
    } else {
        res_a[i + 1] <- a <- x
        res_b[i + 1] <- b
    }
    x <- a + (b - a) / 2
    res_x[i + 1] <- x
}
head(cbind(res_a, res_b, res_x), 20)

# bisection
a <- 2
x <- 3
res_a <- a
res_x <- x

for (i in 1:itr) {
    old_x <- x
    res_a[i + 1] <- a
    res_x[i + 1] <- x <- a - f_prime(a) * (a - x) / (f_prime(a) - f_prime(x))
    a <- old_x
}
head(cbind(res_a, res_x), 20)
