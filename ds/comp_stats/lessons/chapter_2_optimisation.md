# Optimisation & Fisher

## Bisection

## Newton

## Secant

## Fixed Point

# Cauchy Distribution

## Log Likelihood

pdf for the Cauchy with $\theta$ is median, not mean since for Cauchy mean is undefined
$$f(x;\theta) = \frac{1}{\pi} \frac{1}{1+ (x - \theta)^2}$$

Log Likelihood
$$\begin{align}
L(\theta; x) &= \frac{1}{\pi} \frac{1}{1+ (x_1 - \theta)^2}\frac{1}{\pi} \frac{1}{1+ (x_2 - \theta)^2}...\frac{1}{\pi} \frac{1}{1+ (x_i - \theta)^2} \\
             &= \frac{1}{\pi^n} \frac{1}{\Pi[1+ (x_i - \theta)^2]} \\
l(\theta; x) &= -nlog\pi - \sum_{i=1}^n log[1 + (x_i - \theta)^2] \\
l'(\theta) &= \sum_{i=1}^n \frac{2(x_i - \theta)}{1 + (x_i - \theta)^2} \\
l''(\theta) &= 2 \sum_{i=1}^n \frac{(x_i - \theta)^2 - 1}{[1 + (x_i - \theta)^2]^2} \\
\end{align}$$
