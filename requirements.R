# Required R packages for the fraud detection project
# Run this once before running src/fraud_detection_analysis.R

packages <- c(
  "ggplot2",
  "dplyr",
  "corrplot",
  "caret",
  "pROC",
  "klaR",
  "rpart",
  "rpart.plot",
  "randomForest"
)

installed <- rownames(installed.packages())
for (p in packages) {
  if (!(p %in% installed)) {
    install.packages(p)
  }
}
