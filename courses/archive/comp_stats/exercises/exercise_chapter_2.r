# 2. Optimization
# 2.1 Dữ liệu sau đây là mẫu i.i.d. (independent, identical distributed – độc lập cùng phân phối) từ phân phối Cauchy(θ,1): 1.77, -0.23, 2.76, 3.80, 3.47, 56.75, -1.34, 4.24, -2.44, 3.29, 3.71, -2.40, 4.53, -0.07, -1.05, -13.87, -2.53, -1.75, 0.27, 43.21. # nolint
itr <- 100
tol <- 1e-7
cauchy_data <- c(
  1.77, -0.23, 2.76, 3.80, 3.47, 56.75, -1.34, 4.24, -2.44, 3.29, 3.71,
  -2.40, 4.53, -0.07, -1.05, -13.87, -2.53, -1.75, 0.27, 43.21
)
ll_prime <- \(cauchy_data, theta) {
  sum(2 * (cauchy_data - theta) / (1 + (cauchy_data - theta)^2))
}
ll_prime_2 <- \(cauchy_data, theta) {
  2 * sum(((cauchy_data - theta)^2 - 1) / (1 + (cauchy_data - theta)^2)^2)
}
ll_cauchy <- function(data, theta) {
  sum(dcauchy(data, theta, 1, log = TRUE))
}
## a. Draw log-likelihood function
a <- \() {
  theta_x <- seq(-10, 10, 0.1)
  ll_cauchy_data <- sapply(theta_x, ll_cauchy, data = cauchy_data)
  plot(theta_x, ll_cauchy_data, type = "l", xlab = "theta_x", ylab = "log likelihood Cauchy") # nolint
}
a()

## b. Áp dụng thuật toán Newton-Raphson để tìm ước lượng hợp lý cực đại cho θ, với mỗi điểm bắt đầu sau: -11, -1, 0, 1.5, 4, 4.7, 7, 8, và 38. Hãy nhận xét kết quả nghiệm thu được (hội tụ, ổn định). Giá trị trung bình của dữ liệu có phải là điểm khởi đầu tốt không? # nolint
b <- \(start) {
  theta <- start
  for (i in 1:5000000) {
    temp <- theta - ll_prime(cauchy_data, theta) / ll_prime_2(cauchy_data, theta) # nolint
    if (is.na(temp) || is.infinite(temp)) {
      print(stringr::str_interp("break after ${i} iterations"))
      break
    } else if (abs(temp - theta) < tol) {
      print(stringr::str_interp("converge after ${i} iterations"))
      break
    }
    theta <- temp
  }
  return(theta)
}
for (start in c(-11, -1, 0, 1.5, 4, 4.7, 7, 8, 38)) {
  print(b(start))
}


## c. Áp dụng phương pháp bisection với điểm bắt đầu là [−1,1]. Sử dụng các lần chạy bổ sung để minh họa cách thức mà phương pháp bisection có thể không tìm được giá trị cực đại toàn cục. # nolint
## xac dinh so vong lap
c <- \(start, end) {
  a <- start
  b <- end
  x <- a + (b - a) / 2

  res_a <- a
  res_b <- b
  res_x <- x

  for (i in 1:itr) {
    if (ll_prime(a) * ll_prime(x) <= 0) {
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
}
c(-1, 1)

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

## d. Từ các giá trị khởi đầu của (θ(0),θ(1)) = (−2,−1), áp dụng phương pháp secant để tìm ước lượng hợp lý cực đại cho θ. Điều gì xảy ra khi (θ(0),θ(1)) = (−3,3), và đối với các lựa chọn khởi đầu khác? # nolint

## e. Sử dụng ví dụ này để so sánh tốc độ và tính ổn định của phương pháp Newton–Raphson, bisection, fixed-point và phương pháp secant. Kết luận của bạn có thay đổi khi bạn áp dụng các phương pháp này cho một mẫu ngẫu nhiên có kích thước 20 từ phân phối chuẩn (θ,1) không?  # nolint

# 2.2
x <- c(
  3.91, 4.85, 2.28, 4.06, 3.70, 4.04, 5.46, 3.53, 2.28, 1.96, 2.53, 3.88, 2.22,
  3.47, 4.82, 2.46, 2.99, 2.54, 0.52, 2.50
)


f <- function(x, theta) {
  return((1 - cos(x - theta)) / (2 * pi))
}

ll <- function(x, theta) {
  sum(log(f(x, theta)))
}

theta_values <- seq(-pi, pi, length.out = 1000)
ll_values <- sapply(theta_values, ll, x = x)

plot(theta_values, ll_values,
  type = "l", col = "blue", lwd = 5,
  main = "Log-Likelihood Function"
)

e_x <- function(x, theta) {
  return(sin(theta) + pi)
}

theta_hat <- asin(mean(x) - pi)

print(max(ll_values))
print(theta_hat)


f_prime <- function(x, theta) {
  return(sin(x - theta) / (2 * pi))
}
f_prime_2 <- function(x, theta) {
  return(cos(x - theta) / (2 * pi))
}

theta <- 2.7
for (i in 1:10000) {
  theta <- theta - f_prime(x, theta) / f_prime_2(x, theta)
}
print(theta)
