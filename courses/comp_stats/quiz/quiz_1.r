# Problem 3: Oil Spills Analysis

## Setup Code
```{r}
year <- c(
  1974, 1975, 1976, 1977, 1978, 1979, 1980,
  1981, 1982, 1983, 1984, 1985, 1986, 1987,
  1988, 1989, 1990, 1991, 1992, 1993, 1994,
  1995, 1996, 1997, 1998, 1999
)
N <- spills <- c(
  2, 5, 3, 3, 1, 5, 2, 2, 1, 1, 1, 2, 3,
  4, 2, 2, 3, 2, 1, 0, 0, 1, 0, 0, 0, 0
)
b1 <- importexport <- c(
  0.720, 0.850, 1.120, 1.345, 1.290, 1.260, 1.015, 0.870, 0.750, 0.605, 0.570,
  0.540, 0.720, 0.790, 0.840, 0.995, 1.030, 0.975, 1.070, 1.190, 1.290, 1.235,
  1.340, 1.440, 1.450, 1.510
)
b2 <- domestic <- c(
  0.22, 0.17, 0.15, 0.20, 0.59, 0.64, 0.84, 0.87, 0.94, 0.99, 0.92,
  1.00, 0.99, 1.06, 1.00, 0.88, 0.82, 0.82, 0.76, 0.66, 0.65, 0.59,
  0.56, 0.51, 0.42, 0.44
)
```
## (a) Log-Likelihood Function Derivation

### Given Model Specification
- $N_i \sim \text{Poisson}(\lambda_i)$
- $\lambda_i = \alpha_1 b_{i1} + \alpha_2 b_{i2}$

### Likelihood Function
The likelihood function for observations ${N_i}$ is:
$$
L(\alpha_1, \alpha_2) = \prod_{i=1}^{n} \frac{e^{-\lambda_i} \lambda_i^{N_i}}{N_i!}
$$

### Log-Likelihood Function
$$\begin{aligned}
\ell(\alpha_1, \alpha_2) &= \log(\prod_{i=1}^{n} \frac{e^{-\lambda_i} \lambda_i^{N_i}}{N_i!}) \\
\ell(\alpha_1, \alpha_2) &= \sum_{i=1}^{n}(\log \frac{e^{-\lambda_i} \lambda_i^{N_i}}{N_i!}) \\
\ell(\alpha_1, \alpha_2) &= \sum_{i=1}^n \left[ N_i \log(\lambda_i) - \lambda_i - \log(N_i!) \right] \\
\ell(\alpha_1, \alpha_2) &= \sum_{i=1}^n \left[ N_i \log(\alpha_1 b_{i1} + \alpha_2 b_{i2}) - (\alpha_1 b_{i1} + \alpha_2 b_{i2}) - \log(N_i!) \right] \\
\end{aligned}$$

---

## (b) Newton-Raphson Algorithm

### First Derivatives (Gradient)
$$
\begin{aligned}
\frac{\partial \ell}{\partial \alpha_1} &= \frac{\partial \sum_{i=1}^n \left[ N_i \log(\alpha_1 b_{i1} + \alpha_2 b_{i2}) - (\alpha_1 b_{i1} + \alpha_2 b_{i2}) - \log(N_i!) \right] }{\partial \alpha_1}\\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \frac{\partial}{\partial \alpha_1}N_i \log(\alpha_1 b_{i1} + \alpha_2 b_{i2}) - \sum_{i=1}^n \frac{\partial}{\partial \alpha_1}(\alpha_1 b_{i1} + \alpha_2 b_{i2}) - \sum_{i=1}^n \frac{\partial \log(N_i!) }{\partial \alpha_1}\\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \frac{N_i}{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} \frac{\partial}{\partial \alpha_1}(\alpha_1 b_{i1} + \alpha_2 b_{i2}) - \sum_{i=1}^n \frac{\partial}{\partial \alpha_1}(\alpha_1 b_{i1} + \alpha_2 b_{i2})\\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \frac{N_i}{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} b_{i1} - \sum_{i=1}^n b_{i1}\\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \left[ \frac{N_i}{(\alpha_1 b_{i1} + \alpha_2 b_{i2})}b_{i1} - b_{i1} \right] \\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \left[ \frac{N_i b_{i1} }{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} - b_{i1} \right] \\
\frac{\partial \ell}{\partial \alpha_1} &= \sum_{i=1}^n \left[ \frac{N_i b_{i1} }{\lambda_i} - b_{i1} \right] \\
Likewise: \\
\frac{\partial \ell}{\partial \alpha_2} &= \sum_{i=1}^n \left[ \frac{N_i b_{i2}}{\lambda_i} - b_{i2} \right] \\
\end{aligned}
$$

### Second Derivatives (Hessian)
$$
\begin{aligned}
\frac{\partial^2 \ell}{\partial \alpha_1^2} &= \frac{\partial}{\partial \alpha_1} \sum_{i=1}^n \left[ \frac{N_i b_{i1} }{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} - b_{i1} \right] \\
\frac{\partial^2 \ell}{\partial \alpha_1^2} &= \sum_{i=1}^n \frac{\partial}{\partial \alpha_1} \left[ \frac{N_i b_{i1} }{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} \right] \\
\frac{\partial^2 \ell}{\partial \alpha_1^2} &= -\sum_{i=1}^n \frac{N_i b_{i1}}{(\alpha_1 b_{i1} + \alpha_2 b_{i2})^2} \frac{\partial}{\partial \alpha_1} \left[ (\alpha_1 b_{i1} + \alpha_2 b_{i2}) \right] \\
\frac{\partial^2 \ell}{\partial \alpha_1^2} &= -\sum_{i=1}^n \frac{N_i (b_{i1})^2}{\lambda_i^2} \\
Likewise: \\
\frac{\partial^2 \ell}{\partial \alpha_1 \partial \alpha_2} &= \sum_{i=1}^n \frac{\partial}{\partial \alpha_2} \left[ \frac{N_i b_{i1} }{(\alpha_1 b_{i1} + \alpha_2 b_{i2})} \right] \\
\frac{\partial^2 \ell}{\partial \alpha_1 \partial \alpha_2} &= -\sum_{i=1}^n \frac{N_i b_{i1}}{(\alpha_1 b_{i1} + \alpha_2 b_{i2})^2} \frac{\partial}{\partial \alpha_2} \left[ (\alpha_1 b_{i1} + \alpha_2 b_{i2}) \right] \\
\frac{\partial^2 \ell}{\partial \alpha_1 \partial \alpha_2} &= -\sum_{i=1}^n \frac{N_i b_{i1}b_{i2}}{\lambda_i^2} \\
And: \\
\frac{\partial^2 \ell}{\partial \alpha_2 \partial \alpha_1} &= -\sum_{i=1}^n \frac{N_i b_{i1}b_{i2}}{\lambda_i^2} \\
\frac{\partial^2 \ell}{\partial \alpha_2^2} &= -\sum_{i=1}^n \frac{N_i (b_{i2})^2}{\lambda_i^2}
\end{aligned}
$$

### Newton-Raphson Formula

The Newton-Raphson update formula for parameter estimation is given by:

$$\begin{aligned}
\alpha^{(k+1)} &= \alpha^{(k)} - [H^{(k)}]^{-1} g^{(k)} \\
&= \alpha^{(k)} - \begin{bmatrix}
\frac{\partial^2 \ell}{\partial \alpha_1^2} & \frac{\partial^2 \ell}{\partial \alpha_1 \partial \alpha_2} \\
\frac{\partial^2 \ell}{\partial \alpha_2 \partial \alpha_1} & \frac{\partial^2 \ell}{\partial \alpha_2^2}
\end{bmatrix} \begin{bmatrix}
\frac{\partial \ell}{\partial \alpha_1} \\
\frac{\partial \ell}{\partial \alpha_2}
\end{bmatrix} \\
&= \alpha^{(k)} - \begin{bmatrix}
-\sum_{i=1}^n \frac{N_i (b_{i1})^2}{\lambda_i^2} & -\sum_{i=1}^n \frac{N_i b_{i1}b_{i2}}{\lambda_i^2} \\
-\sum_{i=1}^n \frac{N_i b_{i1}b_{i2}}{\lambda_i^2} & -\sum_{i=1}^n \frac{N_i (b_{i2})^2}{\lambda_i^2}
\end{bmatrix}^{-1}_{(k)} \begin{bmatrix}
\sum_{i=1}^n \left[ \frac{N_i b_{i1}}{\lambda_i} - b_{i1} \right] \\
\sum_{i=1}^n \left[ \frac{N_i b_{i2}}{\lambda_i} - b_{i2} \right] \\
\end{bmatrix}^{(k)} \\
\end{aligned}$$



### Algorithm Steps
1. Initialize $\alpha^{(0)} = [0.1, 0.1]^T$
2. For iteration $k=1,2,...$:
   - Compute $\lambda_i^{(k)} = \alpha_1^{(k)}b_{i1} + \alpha_2^{(k)}b_{i2}$
   - Calculate gradient vector $g^{(k)}$
   - Calculate Hessian matrix $H^{(k)}$
   - Update: $\alpha^{(k+1)} = \alpha^{(k)} - [H^{(k)}]^{-1}g^{(k)}$
3. Stop when $||\alpha^{(k+1)} - \alpha^{(k)}|| < \epsilon$

### Implementation Code
```{r}
newton_mle <- \(N, b1, b2, alpha_init = c(0.1, 0.1), tol = 1e-8, max_iter = 1000) {
  alpha <- alpha_init
  results <- data.frame(alpha1 = alpha[1], alpha2 = alpha[2])

  for (iter in 1:max_iter) {
    lambda <- alpha[1] * b1 + alpha[2] * b2

    # Gradient
    grad <- c(
      sum((N / lambda - 1) * b1),
      sum((N / lambda - 1) * b2)
    )

    # Hessian
    h11 <- -sum(N * b1^2 / lambda^2)
    h21 <- h12 <- -sum(N * b1 * b2 / lambda^2)
    h22 <- -sum(N * b2^2 / lambda^2)
    hess <- matrix(c(h11, h12, h21, h22), nrow = 2)

    # Approximate
    delta <- solve(hess, -grad)
    alpha_new <- alpha + delta

    # Store results for each iteration
    results <- rbind(results, data.frame(alpha1 = alpha_new[1], alpha2 = alpha_new[2]))

    if (max(abs(alpha_new - alpha)) < tol) break
    alpha <- alpha_new
  }
  return(results)
}

# Run algorithm
print(newton_mle(N, b1, b2))
```

## (c) Fisher Scoring Algorithm

### Fisher Information Matrix

$$
\begin{aligned}
I(\alpha_1, \alpha_2) &= -E \left[ \frac{\partial^2 \ell}{\partial \alpha_i \partial \alpha_j} \right] \\
\end{aligned}
$$

For the elements of the Fisher Information Matrix, we have:

$$
\begin{aligned}
I_{11} &= E \left[ \sum_{i=1}^n \frac{N_i (b_{i1})^2}{\lambda_i^2} \right] \\
I_{11} &= \sum_{i=1}^n \frac{(b_{i1})^2}{\lambda_i} (\text{assuming } N_i = \lambda_i)\\
Likewise: \\
I_{12} &= E \left[ \sum_{i=1}^n \frac{N_i b_{i1} b_{i2}}{\lambda_i^2} \right] \\
I_{12} &= \sum_{i=1}^n \frac{b_{i1} b_{i2}}{\lambda_i} \\
I_{21} &= I_{12} \\
I_{22} &= E \left[ \sum_{i=1}^n \frac{N_i (b_{i2})^2}{\lambda_i^2} \right] \\
I_{22} &= \sum_{i=1}^n \frac{(b_{i2})^2}{\lambda_i} \\
\end{aligned} \\
Finally:
I(\alpha_1, \alpha_2) = \begin{bmatrix}
\sum_{i=1}^n \frac{(b_{i1})^2}{\lambda_i} & \sum_{i=1}^n \frac{b_{i1} b_{i2}}{\lambda_i} \\
\sum_{i=1}^n \frac{b_{i1} b_{i2}}{\lambda_i} & \sum_{i=1}^n \frac{(b_{i2})^2}{\lambda_i}
\end{bmatrix}
$$

### Fisher Scoring

The Fisher Scoring update formula for parameter estimation is given by:
$$
\begin{aligned}
\alpha^{(k+1)} &= \alpha^{(k)} + [I(\alpha^{(k)})]^{-1} g^{(k)} \\
&= \alpha^{(k)} + \begin{bmatrix}
\sum_{i=1}^n \frac{(b_{i1})^2}{\lambda_i} & \sum_{i=1}^n \frac{b_{i1} b_{i2}}{\lambda_i} \\
\sum_{i=1}^n \frac{b_{i1} b_{i2}}{\lambda_i} & \sum_{i=1}^n \frac{(b_{i2})^2}{\lambda_i}
\end{bmatrix}^{-1} \begin{bmatrix}
\sum_{i=1}^n \left[ \frac{N_i b_{i1}}{\lambda_i} - b_{i1} \right] \\
\sum_{i=1}^n \left[ \frac{N_i b_{i2}}{\lambda_i} - b_{i2} \right] \\
\end{bmatrix} \\
\end{aligned}
$$


### Implementation Code
```{r}
fisher_mle <- \(N, b1, b2, alpha_init = c(0.1, 0.1), tol = 1e-8, max_iter = 1000) {
  alpha <- alpha_init
  results <- data.frame(alpha1 = alpha[1], alpha2 = alpha[2])

  for (iter in 1:max_iter) {
    lambda <- alpha[1] * b1 + alpha[2] * b2

    # Gradient (same as Newton)
    grad <- c(
      sum((N / lambda - 1) * b1),
      sum((N / lambda - 1) * b2)
    )

    # Fisher Information
    I11 <- sum(b1^2 / lambda)
    I21 <- I12 <- sum(b1 * b2 / lambda)
    I22 <- sum(b2^2 / lambda)
    fisher_info <- matrix(c(I11, I12, I21, I22), nrow = 2)

    # Approximate
    delta <- solve(fisher_info, grad)
    alpha_new <- alpha + delta

    # Store results for each iteration
    results <- rbind(results, data.frame(alpha1 = alpha_new[1], alpha2 = alpha_new[2]))

    if (max(abs(alpha_new - alpha)) < tol) break
    alpha <- alpha_new
  }
  return(results)
}

# Run algorithm
print(fisher_mle(N, b1, b2))
```


### Comparing Results of Newton-Raphson and Fisher Scoring

- Newton-Raphson results converge to the MLE estimates of $\alpha_1$ and $\alpha_2$ after 10 iterations, while Fisher Scoring converges after 17 iterations. 
- Both algorithms provide similar estimates for the parameters.

## (d) Standard Errors of MLE Estimates

$$\begin{aligned}
\hat{\lambda}_i = \hat{\alpha}_1 b_{i1} + \hat{\alpha}_2 b_{i2} \\
\text{SE}(\hat{\alpha}_j) = \sqrt{\text{diag} (I^{-1}(\hat{\alpha}))_{j}} \\
\text{SE}(\hat{\alpha}_1) = \sqrt{\text{diag} (I^{-1}(\hat{\alpha}))_{1}} \\
\text{SE}(\hat{\alpha}_1) = \sqrt{\left[ I(\hat{\alpha})^{-1} \right]_{11}} \\
\text{SE}(\hat{\alpha}_2) = \sqrt{\left[ I(\hat{\alpha})^{-1} \right]_{22}} \\
\end{aligned}$$

### Implementation Code

```{r}
alpha_newton <- as.vector(tail(newton_mle(N, b1, b2), 1))
lambda_newton_mle <- alpha_newton$alpha1 * b1 + alpha_newton$alpha2 * b2

h11 <- -sum(N * b1^2 / lambda_newton_mle^2)
h21 <- h12 <- -sum(N * b1 * b2 / lambda_newton_mle^2)
h22 <- -sum(N * b2^2 / lambda_newton_mle^2)
hessian_matrix <- matrix(c(h11, h12, h21, h22), nrow = 2)

# Standard errors for Newton-Raphson method
se_newton <- sqrt(diag(solve(-hessian_matrix)))

cat("MLE Estimates (Newton):", round(as.numeric(alpha_newton), 5), "\n")
cat("Standard Errors (Newton):", round(se_newton, 5), "\n")
```

```{r}
# Compute Fisher information at MLE for Fisher method
alpha_fisher <- as.vector(tail(fisher_mle(N, b1, b2), 1))
lambda_fisher_mle <- alpha_fisher$alpha1 * b1 + alpha_fisher$alpha2 * b2

i11 <- sum(b1^2 / lambda_fisher_mle)
i21 <- i12 <- sum(b1 * b2 / lambda_fisher_mle)
i22 <- sum(b2^2 / lambda_fisher_mle)
fisher_matrix <- matrix(c(i11, i12, i21, i22), nrow = 2)

# Standard errors for Fisher method
se_fisher <- sqrt(diag(solve(fisher_matrix)))

cat("MLE Estimates (Fisher):", round(as.numeric(alpha_fisher), 5), "\n")
cat("Standard Errors (Fisher):", round(se_fisher, 5), "\n")
```

## (e) Quasi-Newton Method with Two Initial Matrix Choices

### Algorithm Steps

1. Approximates the inverse Hessian using gradient updates.
2. Update rule: $\alpha^{(k+1)} = \alpha^{(k)} - p_k M^{(k)} g^{(k)}$ where p_k is the step size.
3. BFGS update for $M^{(k)}$:
4. $M^{(k+1)} = M^{(k)} + \frac{y^{(k)}(y^{(k)})^T}{(y^{(k)})^T s^{(k)}} - \frac{M^{(k)} s^{(k)}(M^{(k)} s^{(k)})^T}{s^{(k)T} M^{(k)} s^{(k)}}$
5. Initialize $\alpha^{(0)} = [0.1, 0.1]^T$
6. Choose an initial approximation of the Hessian matrix $B^{(0)}$
7. For iteration $k=1,2,...$:
  - Compute $\lambda_i^{(k)} = \alpha_1^{(k)}b_{i1} + \alpha_2^{(k)}b_{i2}$
  - Calculate gradient vector $g^{(k)}$
  - Update: $\alpha^{(k+1)} = \alpha^{(k)} - [B^{(k)}]^{-1} g^{(k)}$
  - Update $B^{(k+1)}$ using the BFGS update formula
  - Stop when $||\alpha^{(k+1)} - \alpha^{(k)}|| < \epsilon$
8. Choose another initial approximation of the Hessian matrix $B^{(0)}$ and repeat the process


### Implementation Code


```{r}
# Define negative log-likelihood and gradient
neg_log_likelihood <- function(alpha) {
  lambda <- alpha[1] * b1 + alpha[2] * b2
  -sum(N * log(lambda) - lambda)
}

grad_neg_log_likelihood <- function(alpha) {
  lambda <- alpha[1] * b1 + alpha[2] * b2
  c(-sum((N / lambda - 1) * b1), -sum((N / lambda - 1) * b2))
}

# Initial parameters
alpha0 <- c(1, 1)

# --- Method 1: BFGS with default initial Hessian (negative identity approximation) ---
opt_bfgs_default <- optim(
  par = alpha0,
  fn = neg_log_likelihood,
  gr = grad_neg_log_likelihood,
  method = "BFGS",
  control = list(trace = 1)
)

# --- Method 2: BFGS with Fisher Information preconditioning ---
# Compute Fisher Information at initial alpha0
lambda0 <- alpha0[1] * b1 + alpha0[2] * b2
fisher_info <- matrix(
  c(
    sum(b1^2 / lambda0),
    sum(b1 * b2 / lambda0),
    sum(b1 * b2 / lambda0),
    sum(b2^2 / lambda0)
  ),
  nrow = 2
)

# Use diagonal of Fisher Info for parameter scaling
opt_bfgs_fisher <- optim(
  par = alpha0,
  fn = neg_log_likelihood,
  gr = grad_neg_log_likelihood,
  method = "BFGS",
  control = list(parscale = diag(fisher_info), trace = 1)
)

# Results
cat("Method 1 (Default BFGS):", round(opt_bfgs_default$par, 6), "in", opt_bfgs_default$counts[1], "iterations\n")
cat("Method 2 (Fisher-scaled BFGS):", round(opt_bfgs_fisher$par, 6), "in", opt_bfgs_fisher$counts[1], "iterations\n")
```

Comparison

Method 1 (Default BFGS): Starts with identity matrix. Converges reliably but may require more iterations.
Method 2 (Fisher-scaled BFGS): Uses diagonal Fisher Information for parameter scaling. Converges faster due to better initial step sizing. Final estimates are identical, but Method 2 typically uses fewer iterations.

### (f): Plot Optimization Paths

```{r}
# Generate log-likelihood grid
alpha1_grid <- seq(0.5, 1.5, length.out = 50)
alpha2_grid <- seq(0.5, 1.5, length.out = 50)
loglik <- matrix(NA, nrow = 50, ncol = 50)
for (i in 1:50) {
  for (j in 1:50) {
    lambda <- alpha1_grid[i] * b1 + alpha2_grid[j] * b2
    loglik[i, j] <- sum(N * log(lambda) - lambda)
  }
}

# Track optimization paths
track_optim_path <- function(alpha0, method, parscale = NULL) {
  path <- matrix(ncol = 2, nrow = 0)
  optim(
    par = alpha0,
    fn = function(par) {
      path <<- rbind(path, par)
      neg_log_lik(par)
    },
    gr = grad_neg_log_lik,
    method = method,
    control = list(parscale = parscale)
  )
  return(path)
}

# Get paths for both methods
path_default <- track_optim_path(alpha0, "BFGS")
path_fisher <- track_optim_path(alpha0, "BFGS", parscale = diag(fisher_info))

# Plot
contour(alpha1_grid, alpha2_grid, loglik,
  xlab = "alpha1", ylab = "alpha2",
  main = "Log-Likelihood Contour with Optimization Paths"
)
points(path_default, type = "b", col = "red", pch = 19, cex = 0.6, lwd = 1)
points(path_fisher, type = "b", col = "blue", pch = 17, cex = 0.6, lwd = 1)
points(opt_bfgs_default$par[1], opt_bfgs_default$par[2], col = "red", pch = 4, lwd = 2)
points(opt_bfgs_fisher$par[1], opt_bfgs_fisher$par[2], col = "blue", pch = 4, lwd = 2)
legend("topright",
  legend = c("Default BFGS", "Fisher-scaled BFGS"),
  col = c("red", "blue"), pch = c(19, 17)
)
```