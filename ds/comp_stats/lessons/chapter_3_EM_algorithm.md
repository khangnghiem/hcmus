# Probability Density of Weibull Distribution

$$f(y, \theta, \alpha) = \frac{\gamma}{\theta} (\frac{y}{\theta})^{\alpha - 1} exp\{-(\frac{y}{\theta})^\alpha\}$$
$$for\ y > 0;\ \theta, \alpha > 0$$

Log-likelihood function:
$$l(\theta, \alpha; y) = \sum_{i=1}^{10} log(f(y; \theta, \alpha))$$
$$l(\theta, \alpha; y) = \sum_{i=1}^{10} [log(\alpha) - log(\theta) + (\alpha -1) log(y) - (\alpha - 1) log(theta) - (\frac{y}{\theta})^\alpha]$$
