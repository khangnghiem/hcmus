lasso_david_gay <- function(X, y, lambda = 0.1, max_iter = 1000, lr = 0.01, tol = 1e-6) {
    n <- nrow(X)
    p <- ncol(X)

    # Standardize X and center y
    X <- scale(X)
    y <- y - mean(y)

    beta_plus <- rep(0, p)
    beta_minus <- rep(0, p)

    for (iter in 1:max_iter) {
        beta <- beta_plus - beta_minus
        y_hat <- X %*% beta
        residual <- y_hat - y

        # Gradient of loss (least squares)
        grad <- t(X) %*% residual / n

        # Gradient steps with L1 penalty (linear term added)
        beta_plus_new <- beta_plus - lr * (grad + lambda)
        beta_minus_new <- beta_minus + lr * (grad - lambda)

        # Project onto non-negative orthant
        beta_plus <- pmax(0, beta_plus_new)
        beta_minus <- pmax(0, beta_minus_new)

        # Convergence check
        if (max(abs(beta - (beta_plus - beta_minus))) < tol) break
    }

    return(beta_plus - beta_minus)
}


run_lasso_analysis <- function(file_path, lambda = 0.1, label_column, exclude_columns) {
    # Read the CSV file
    prostate_data <- read.csv(file_path)

    # Separate predictors and response
    y <- prostate_data[[label_column]] # Use double brackets to correctly extract the column
    excluded_cols <- c(exclude_columns, label_column) # Combine excluded columns
    X <- as.matrix(prostate_data[, !names(prostate_data) %in% excluded_cols]) # Drop specified columns

    # Perform LASSO regression
    beta_hat <- lasso_david_gay(X, y, lambda)

    # Convert to dataframe
    beta_hat_df <- data.frame(Feature = colnames(X), Coefficient = beta_hat)

    # Return the result
    return(beta_hat_df)
}

print(run_lasso_analysis("prostate.csv", lambda = 0.1, label_column = "lpsa", exclude_columns = "train"))
print(run_lasso_analysis("car_price.csv", lambda = 0.1, label_column = "price_thousands_USD", exclude_columns = ""))
