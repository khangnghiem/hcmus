# Define inputs
lambda <- 5
k <- 3

# Calculate probability
prob <- dpois(k, lambda) # Using R's built-in Poisson function
cat("Probability of exactly 3 cars:", round(prob * 100, 2), "%\n")

# Plot the distribution
k_values <- 0:15 # Possible number of cars (0 to 15)
probabilities <- dpois(k_values, lambda)

barplot(
    probabilities,
    names.arg = k_values,
    col = ifelse(k_values == 3, "red", "lightblue"),
    main = "Poisson Distribution (λ = 5)",
    xlab = "Number of Cars",
    ylab = "Probability"
)
