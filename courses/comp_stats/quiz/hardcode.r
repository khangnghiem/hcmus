data <- data.frame(
    id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42),
    group = c("treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "treatment", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control"),
    time = c(6, 6, 6, 6, 7, 9, 10, 10, 11, 13, 16, 17, 19, 20, 22, 23, 25, 32, 32, 34, 35, 1, 1, 2, 2, 3, 4, 4, 5, 5, 8, 8, 8, 8, 11, 11, 12, 12, 15, 17, 22, 23),
    censored = c(1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
)

data
