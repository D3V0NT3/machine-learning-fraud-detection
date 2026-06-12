# Machine Learning Fraud Detection Analysis
# Run this script from the project root folder.
# Example in RStudio: Session -> Set Working Directory -> To Source File Location,
# or manually use setwd("path/to/machine-learning-fraud-detection").

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)
dir.create("plots", showWarnings = FALSE, recursive = TRUE)

data <- read.csv(
  file.path("data", "Financial_Transactions.csv"),
  stringsAsFactors = FALSE,
  na.strings = c("", "NA", "N/A")
)

dim(data)
names(data)
head(data)
# Save dataset structure output
sink("outputs/dataset_structure.txt")

cat("Dataset dimensions:\n")
print(dim(data))

cat("\nColumn names:\n")
print(names(data))

cat("\nStructure:\n")
str(data)

cat("\nFirst six rows:\n")
print(head(data))

cat("\nSummary statistics:\n")
print(summary(data))

sink()
#  Exploratory Data Analysis
packages <- c("ggplot2", "dplyr")

installed <- rownames(installed.packages())

for (p in packages) {
  if (!(p %in% installed)) {
    install.packages(p)
  }
}

library(ggplot2)
library(dplyr)

# Convert target variable into a labelled factor
data$isFraud <- factor(
  data$isFraud,
  levels = c(0, 1),
  labels = c("NonFraud", "Fraud")
)

# Count fraud and non-fraud transactions
fraud_table <- table(data$isFraud)
fraud_percent <- prop.table(fraud_table) * 100

class_distribution <- data.frame(
  Class = names(fraud_table),
  Count = as.vector(fraud_table),
  Percentage = round(as.vector(fraud_percent), 2)
)

# Print result in console
print(class_distribution)

# Save result as CSV
write.csv(
  class_distribution,
  "outputs/class_distribution.csv",
  row.names = FALSE
)

# Create bar chart
fig_1 <- ggplot(data, aes(x = isFraud)) +
  geom_bar() +
  labs(
    title = "Distribution of Fraud and Non-Fraud Transactions",
    x = "Transaction Class",
    y = "Count"
  )

# Save chart
ggsave(
  "plots/fig_1_class_distribution.png",
  fig_1,
  width = 7,
  height = 5
)

#  Transaction Type Analysis
# Count each transaction type
transaction_type_distribution <- data %>%
  count(type) %>%
  mutate(
    Percentage = round(n / sum(n) * 100, 2)
  ) %>%
  arrange(desc(n))

# Print result in console
print(transaction_type_distribution)

# Save result as CSV
write.csv(
  transaction_type_distribution,
  "outputs/transaction_type_distribution.csv",
  row.names = FALSE
)

# Create bar chart
fig_2 <- ggplot(data, aes(x = type)) +
  geom_bar() +
  labs(
    title = "Distribution of Transaction Types",
    x = "Transaction Type",
    y = "Count"
  )

# Save chart
ggsave(
  "plots/fig_2_transaction_type_distribution.png",
  fig_2,
  width = 7,
  height = 5
)

# Fraud by Transaction Type
# Count fraud/non-fraud transactions within each transaction type
fraud_by_type <- data %>%
  group_by(type, isFraud) %>%
  summarise(
    Count = n(),
    .groups = "drop"
  ) %>%
  group_by(type) %>%
  mutate(
    Percentage = round(Count / sum(Count) * 100, 2)
  ) %>%
  arrange(type, isFraud)

# Print result in console
print(fraud_by_type)

# Save result as CSV
write.csv(
  fraud_by_type,
  "outputs/fraud_by_type.csv",
  row.names = FALSE
)

# Create grouped bar chart
fig_3 <- ggplot(
  fraud_by_type,
  aes(x = type, y = Percentage, fill = isFraud)
) +
  geom_col(position = "dodge") +
  labs(
    title = "Fraud and Non-Fraud Percentage by Transaction Type",
    x = "Transaction Type",
    y = "Percentage",
    fill = "Transaction Class"
  )

# Save chart
ggsave(
  "plots/fig_3_fraud_by_transaction_type.png",
  fig_3,
  width = 8,
  height = 5
)

# Transaction Amount Analysis
# Summary statistics for amount by fraud class
amount_summary <- data %>%
  group_by(isFraud) %>%
  summarise(
    Count = n(),
    Mean_Amount = round(mean(amount, na.rm = TRUE), 2),
    Median_Amount = round(median(amount, na.rm = TRUE), 2),
    Min_Amount = round(min(amount, na.rm = TRUE), 2),
    Max_Amount = round(max(amount, na.rm = TRUE), 2),
    SD_Amount = round(sd(amount, na.rm = TRUE), 2),
    .groups = "drop"
  )

# Print result in console
print(amount_summary)

# Save summary table
write.csv(
  amount_summary,
  "outputs/amount_summary_by_fraud.csv",
  row.names = FALSE
)

# Histogram of transaction amount
fig_4 <- ggplot(data, aes(x = amount)) +
  geom_histogram(bins = 50) +
  labs(
    title = "Distribution of Transaction Amounts",
    x = "Transaction Amount",
    y = "Frequency"
  )

ggsave(
  "plots/fig_4_amount_distribution.png",
  fig_4,
  width = 7,
  height = 5
)

# Boxplot of amount by fraud class
fig_5 <- ggplot(data, aes(x = isFraud, y = amount)) +
  geom_boxplot() +
  labs(
    title = "Transaction Amount by Fraud Class",
    x = "Transaction Class",
    y = "Transaction Amount"
  )

ggsave(
  "plots/fig_5_amount_by_fraud.png",
  fig_5,
  width = 7,
  height = 5
)

# Data Pre-processing
# Missing Values

# Count missing values in each column
missing_counts <- sapply(data, function(x) sum(is.na(x)))

# Calculate missing percentage in each column
missing_percent <- round(missing_counts / nrow(data) * 100, 2)

# Create missing values summary table
missing_summary <- data.frame(
  Variable = names(missing_counts),
  Missing_Count = missing_counts,
  Missing_Percent = missing_percent
)

# Print missing values table
print(missing_summary)

# Save missing values table
write.csv(
  missing_summary,
  "outputs/missing_values.csv",
  row.names = FALSE
)

# Calculate average missing percentage across all variables
average_missing <- round(mean(missing_percent), 2)

cat("\nAverage missing percentage across all variables:", average_missing, "%\n")

# Count complete and incomplete rows
rows_before <- nrow(data)
complete_rows <- sum(complete.cases(data))
incomplete_rows <- rows_before - complete_rows

cat("\nRows before missing value treatment:", rows_before, "\n")
cat("Complete rows:", complete_rows, "\n")
cat("Incomplete rows:", incomplete_rows, "\n")

# Apply missing value decision rule
if (average_missing > 1) {
  cat("\nDecision: Average missingness is greater than 1%, so imputation should be considered.\n")
} else {
  cat("\nDecision: Average missingness is 1% or below, so incomplete rows can be removed.\n")
  
  data_clean <- na.omit(data)
  
  cat("Rows after removing incomplete rows:", nrow(data_clean), "\n")
}

# Missing Value Imputation using MICE

library(dplyr)

# Start again from the original dataset
data_clean <- data


#  Remove identifier columns


data_clean <- data_clean %>%
  select(-nameOrig, -nameDest)


# Impute missing transaction type using mode


mode_type <- names(sort(table(data_clean$type), decreasing = TRUE))[1]

data_clean$type[is.na(data_clean$type)] <- mode_type


#Impute numeric variables using median


numeric_columns <- c(
  "amount",
  "oldbalanceOrg",
  "newbalanceOrig",
  "oldbalanceDest",
  "newbalanceDest"
)

for (col in numeric_columns) {
  median_value <- median(data_clean[[col]], na.rm = TRUE)
  data_clean[[col]][is.na(data_clean[[col]])] <- median_value
}


# Recreate Amount.Category after amount imputation


q5 <- quantile(data_clean$amount, 0.05, na.rm = TRUE)
q95 <- quantile(data_clean$amount, 0.95, na.rm = TRUE)

data_clean$Amount.Category <- ifelse(
  data_clean$amount <= q5,
  "Low",
  ifelse(data_clean$amount > q95, "High", "Medium")
)


# Convert categorical variables to factors


data_clean$type <- as.factor(data_clean$type)
data_clean$Amount.Category <- as.factor(data_clean$Amount.Category)
data_clean$isFraud <- as.factor(data_clean$isFraud)


#  Check missing values after imputation


missing_after_imputation <- data.frame(
  Variable = names(data_clean),
  Missing_Count = sapply(data_clean, function(x) sum(is.na(x)))
)

print(missing_after_imputation)

write.csv(
  missing_after_imputation,
  "outputs/missing_after_imputation.csv",
  row.names = FALSE
)

write.csv(
  data_clean,
  "outputs/data_clean_after_imputation.csv",
  row.names = FALSE
)


dim(data_clean)
summary(data_clean)

# Outlier Detection

# Select numeric variables from cleaned dataset
numeric_vars <- data_clean %>%
  select(where(is.numeric))

# Function to count outliers using IQR method
outlier_count <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  
  sum(x < lower | x > upper, na.rm = TRUE)
}

# Create outlier summary table
outlier_summary <- data.frame(
  Variable = names(numeric_vars),
  Outlier_Count = sapply(numeric_vars, outlier_count)
)

outlier_summary$Outlier_Percent <- round(
  outlier_summary$Outlier_Count / nrow(data_clean) * 100,
  2
)

# Print outlier table
print(outlier_summary)

# Save outlier table
write.csv(
  outlier_summary,
  "outputs/outlier_summary.csv",
  row.names = FALSE
)

# Multicollinearity

# Install and load corrplot if needed
if (!("corrplot" %in% rownames(installed.packages()))) {
  install.packages("corrplot")
}

library(corrplot)
library(dplyr)

# Select numeric variables only
numeric_data <- data_clean %>%
  select(where(is.numeric))

# Create correlation matrix
cor_matrix <- cor(
  numeric_data,
  use = "complete.obs"
)

# Print correlation matrix
print(round(cor_matrix, 3))

# Save correlation matrix
write.csv(
  round(cor_matrix, 3),
  "outputs/correlation_matrix.csv"
)

# Save correlation plot
png(
  "plots/fig_6_correlation_matrix.png",
  width = 900,
  height = 700
)

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.8,
  addCoef.col = "black",
  number.cex = 0.7
)

dev.off()

# Identify highly correlated variable pairs
cor_pairs <- as.data.frame(as.table(cor_matrix))

# Remove self-correlations
cor_pairs <- cor_pairs %>%
  filter(Var1 != Var2)

# Remove duplicate pairs
cor_pairs <- cor_pairs %>%
  rowwise() %>%
  mutate(pair = paste(sort(c(Var1, Var2)), collapse = "_")) %>%
  ungroup() %>%
  distinct(pair, .keep_all = TRUE) %>%
  select(-pair)

# Keep strong correlations only
high_correlation_pairs <- cor_pairs %>%
  filter(abs(Freq) >= 0.70) %>%
  arrange(desc(abs(Freq)))

# Print high correlation pairs
print(high_correlation_pairs)

# Save high correlation pairs
write.csv(
  high_correlation_pairs,
  "outputs/high_correlation_pairs.csv",
  row.names = FALSE
)

# Variable Investigation
# Create engineered balance-difference features
data_model <- data_clean %>%
  mutate(
    balanceOrigDiff = oldbalanceOrg - newbalanceOrig,
    balanceDestDiff = newbalanceDest - oldbalanceDest
  )

# Check final modelling dataset
dim(data_model)
str(data_model)
summary(data_model)

# Save modelling dataset
write.csv(
  data_model,
  "outputs/data_model_feature_engineered.csv",
  row.names = FALSE
)

# Save variable names for reporting
variable_summary <- data.frame(
  Variable = names(data_model),
  Class = sapply(data_model, class)
)

print(variable_summary)

write.csv(
  variable_summary,
  "outputs/variable_summary_after_feature_engineering.csv",
  row.names = FALSE
)

# Scaling and Encoding
# Check final variable classes before modelling
final_variable_classes <- data.frame(
  Variable = names(data_model),
  Class = sapply(data_model, class)
)

print(final_variable_classes)

write.csv(
  final_variable_classes,
  "outputs/final_variable_classes.csv",
  row.names = FALSE
)

# Check target variable levels
levels(data_model$isFraud)

# Make sure NonFraud is first and Fraud is second
data_model$isFraud <- factor(
  data_model$isFraud,
  levels = c("NonFraud", "Fraud")
)

levels(data_model$isFraud)

# Modelling Phase
# Train/Test Split 
# Install and load caret if needed
if (!("caret" %in% rownames(installed.packages()))) {
  install.packages("caret")
}

library(caret)


data_model$isFraud <- factor(
  data_model$isFraud,
  levels = c("Fraud", "NonFraud")
)

levels(data_model$isFraud)


# Create 70/30 train-test split


set.seed(123)

train_index <- createDataPartition(
  data_model$isFraud,
  p = 0.70,
  list = FALSE
)

train_data <- data_model[train_index, ]
test_data <- data_model[-train_index, ]

# Check dimensions
dim(train_data)
dim(test_data)

# Check class distribution in full, training and testing data
full_class_distribution <- prop.table(table(data_model$isFraud)) * 100
train_class_distribution <- prop.table(table(train_data$isFraud)) * 100
test_class_distribution <- prop.table(table(test_data$isFraud)) * 100

print(full_class_distribution)
print(train_class_distribution)
print(test_class_distribution)

# Save split summary
split_summary <- data.frame(
  Dataset = c("Full Dataset", "Training Set", "Testing Set"),
  Rows = c(nrow(data_model), nrow(train_data), nrow(test_data)),
  Fraud_Percent = c(
    round(full_class_distribution["Fraud"], 2),
    round(train_class_distribution["Fraud"], 2),
    round(test_class_distribution["Fraud"], 2)
  ),
  NonFraud_Percent = c(
    round(full_class_distribution["NonFraud"], 2),
    round(train_class_distribution["NonFraud"], 2),
    round(test_class_distribution["NonFraud"], 2)
  )
)

print(split_summary)

write.csv(
  split_summary,
  "outputs/train_test_split_summary.csv",
  row.names = FALSE
)


# Set up 10-fold cross-validation


ctrl <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = "final"
)

# Model 1: Logistic Regression

set.seed(123)

# Train Logistic Regression model
lr_model <- train(
  isFraud ~ .,
  data = train_data,
  method = "glm",
  family = "binomial",
  metric = "ROC",
  trControl = ctrl
)

# Test model on test data
lr_pred <- predict(lr_model, test_data)
lr_prob <- predict(lr_model, test_data, type = "prob")

# Confusion matrix
lr_cm <- confusionMatrix(
  lr_pred,
  test_data$isFraud,
  positive = "Fraud"
)

print(lr_cm)

# ROC and AUC
if (!("pROC" %in% rownames(installed.packages()))) {
  install.packages("pROC")
}

library(pROC)

lr_roc <- roc(
  response = test_data$isFraud,
  predictor = lr_prob$Fraud,
  levels = c("NonFraud", "Fraud")
)

lr_auc <- auc(lr_roc)

print(lr_auc)

# Save Logistic Regression results
sink("outputs/logistic_regression_results.txt")

cat("Logistic Regression Model\n")
cat("=========================\n\n")

cat("Model Summary:\n")
print(lr_model)

cat("\nConfusion Matrix:\n")
print(lr_cm)

cat("\nAUC:\n")
print(lr_auc)

sink()

# Model 2: K-Nearest Neighbours
set.seed(123)

# Tune different K values
knn_grid <- expand.grid(
  k = c(3, 5, 7, 9, 11, 15)
)

# Train KNN model
# Scaling is applied because KNN is distance-based
knn_model <- train(
  isFraud ~ .,
  data = train_data,
  method = "knn",
  metric = "ROC",
  trControl = ctrl,
  tuneGrid = knn_grid,
  preProcess = c("center", "scale")
)

# Test model on test data
knn_pred <- predict(knn_model, test_data)
knn_prob <- predict(knn_model, test_data, type = "prob")

# Confusion matrix
knn_cm <- confusionMatrix(
  knn_pred,
  test_data$isFraud,
  positive = "Fraud"
)

print(knn_model)
print(knn_model$bestTune)
print(knn_cm)

# ROC and AUC
knn_roc <- roc(
  response = test_data$isFraud,
  predictor = knn_prob$Fraud,
  levels = c("NonFraud", "Fraud")
)

knn_auc <- auc(knn_roc)

print(knn_auc)

# Save KNN results
sink("outputs/knn_results.txt")

cat("K-Nearest Neighbours Model\n")
cat("==========================\n\n")

cat("Model Summary:\n")
print(knn_model)

cat("\nBest K:\n")
print(knn_model$bestTune)

cat("\nConfusion Matrix:\n")
print(knn_cm)

cat("\nAUC:\n")
print(knn_auc)

sink()

# Model 3: Naive Bayes
# caret uses klaR for method = "nb"
if (!("klaR" %in% rownames(installed.packages()))) {
  install.packages("klaR")
}

library(klaR)

set.seed(123)

# Train Naive Bayes model
nb_model <- train(
  isFraud ~ .,
  data = train_data,
  method = "nb",
  metric = "ROC",
  trControl = ctrl
)

# Test model on test data
nb_pred <- predict(nb_model, test_data)
nb_prob <- predict(nb_model, test_data, type = "prob")

# Confusion matrix
nb_cm <- confusionMatrix(
  nb_pred,
  test_data$isFraud,
  positive = "Fraud"
)

print(nb_model)
print(nb_model$bestTune)
print(nb_cm)

# ROC and AUC
nb_roc <- roc(
  response = test_data$isFraud,
  predictor = nb_prob$Fraud,
  levels = c("NonFraud", "Fraud")
)

nb_auc <- auc(nb_roc)

print(nb_auc)

# Save Naive Bayes results
sink("outputs/naive_bayes_results.txt")

cat("Naive Bayes Model\n")
cat("=================\n\n")

cat("Model Summary:\n")
print(nb_model)

cat("\nBest Tuning Parameters:\n")
print(nb_model$bestTune)

cat("\nConfusion Matrix:\n")
print(nb_cm)

cat("\nAUC:\n")
print(nb_auc)

sink()

#Model 4: Decision Tree
# Install and load packages if needed
if (!("rpart" %in% rownames(installed.packages()))) {
  install.packages("rpart")
}

if (!("rpart.plot" %in% rownames(installed.packages()))) {
  install.packages("rpart.plot")
}

library(rpart)
library(rpart.plot)

set.seed(123)

# Train Decision Tree model
dt_model <- train(
  isFraud ~ .,
  data = train_data,
  method = "rpart",
  metric = "ROC",
  trControl = ctrl,
  tuneLength = 10
)

# Test model on test data
dt_pred <- predict(dt_model, test_data)
dt_prob <- predict(dt_model, test_data, type = "prob")

# Confusion matrix
dt_cm <- confusionMatrix(
  dt_pred,
  test_data$isFraud,
  positive = "Fraud"
)

print(dt_model)
print(dt_model$bestTune)
print(dt_cm)

# ROC and AUC
dt_roc <- roc(
  response = test_data$isFraud,
  predictor = dt_prob$Fraud,
  levels = c("NonFraud", "Fraud")
)

dt_auc <- auc(dt_roc)

print(dt_auc)

# Save Decision Tree plot
png(
  "plots/fig_7_decision_tree.png",
  width = 1000,
  height = 700
)

rpart.plot(dt_model$finalModel)

dev.off()

# Save Decision Tree results
sink("outputs/decision_tree_results.txt")

cat("Decision Tree Model\n")
cat("===================\n\n")

cat("Model Summary:\n")
print(dt_model)

cat("\nBest Tuning Parameters:\n")
print(dt_model$bestTune)

cat("\nConfusion Matrix:\n")
print(dt_cm)

cat("\nAUC:\n")
print(dt_auc)

sink()

# Model 5: Random Forest
# Install and load randomForest if needed
if (!("randomForest" %in% rownames(installed.packages()))) {
  install.packages("randomForest")
}

library(randomForest)

set.seed(123)

# Train Random Forest model
rf_model <- train(
  isFraud ~ .,
  data = train_data,
  method = "rf",
  metric = "ROC",
  trControl = ctrl,
  tuneLength = 5,
  importance = TRUE
)

# Test model on test data
rf_pred <- predict(rf_model, test_data)
rf_prob <- predict(rf_model, test_data, type = "prob")

# Confusion matrix
rf_cm <- confusionMatrix(
  rf_pred,
  test_data$isFraud,
  positive = "Fraud"
)

print(rf_model)
print(rf_model$bestTune)
print(rf_cm)

# ROC and AUC
rf_roc <- roc(
  response = test_data$isFraud,
  predictor = rf_prob$Fraud,
  levels = c("NonFraud", "Fraud")
)

rf_auc <- auc(rf_roc)

print(rf_auc)

# Save Random Forest variable importance plot
png(
  "plots/fig_8_random_forest_importance.png",
  width = 900,
  height = 700
)

varImpPlot(rf_model$finalModel)

dev.off()

# Save Random Forest results
sink("outputs/random_forest_results.txt")

cat("Random Forest Model\n")
cat("===================\n\n")

cat("Model Summary:\n")
print(rf_model)

cat("\nBest Tuning Parameters:\n")
print(rf_model$bestTune)

cat("\nConfusion Matrix:\n")
print(rf_cm)

cat("\nAUC:\n")
print(rf_auc)

sink()

# Best Model Interpretation
# Random Forest Variable Importance


rf_importance <- varImp(rf_model)

print(rf_importance)

# Save importance table
rf_importance_table <- rf_importance$importance
rf_importance_table$Variable <- rownames(rf_importance_table)

rf_importance_table <- rf_importance_table %>%
  arrange(desc(Overall))

write.csv(
  rf_importance_table,
  "outputs/random_forest_variable_importance.csv",
  row.names = FALSE
)

# Comparison
# Function to extract important model metrics
extract_metrics <- function(cm, auc_value, model_name) {
  data.frame(
    Model = model_name,
    Accuracy = round(as.numeric(cm$overall["Accuracy"]), 4),
    Kappa = round(as.numeric(cm$overall["Kappa"]), 4),
    Sensitivity = round(as.numeric(cm$byClass["Sensitivity"]), 4),
    Specificity = round(as.numeric(cm$byClass["Specificity"]), 4),
    Precision = round(as.numeric(cm$byClass["Pos Pred Value"]), 4),
    NPV = round(as.numeric(cm$byClass["Neg Pred Value"]), 4),
    Balanced_Accuracy = round(as.numeric(cm$byClass["Balanced Accuracy"]), 4),
    AUC = round(as.numeric(auc_value), 4)
  )
}

# Combine all model results
model_comparison_results <- rbind(
  extract_metrics(lr_cm, lr_auc, "Logistic Regression"),
  extract_metrics(knn_cm, knn_auc, "KNN"),
  extract_metrics(nb_cm, nb_auc, "Naive Bayes"),
  extract_metrics(dt_cm, dt_auc, "Decision Tree"),
  extract_metrics(rf_cm, rf_auc, "Random Forest")
)

# Print comparison table
print(model_comparison_results)

# Save comparison table
write.csv(
  model_comparison_results,
  "outputs/model_comparison_results.csv",
  row.names = FALSE
)

#ROC Curve Comparison

png(
  "plots/fig_9_roc_comparison.png",
  width = 900,
  height = 700
)

plot(
  lr_roc,
  main = "ROC Curve Comparison for Five Machine Learning Models",
  lwd = 2
)

plot(knn_roc, add = TRUE, lwd = 2)
plot(nb_roc, add = TRUE, lwd = 2)
plot(dt_roc, add = TRUE, lwd = 2)
plot(rf_roc, add = TRUE, lwd = 2)

legend(
  "bottomright",
  legend = c(
    paste("Logistic Regression AUC =", round(lr_auc, 4)),
    paste("KNN AUC =", round(knn_auc, 4)),
    paste("Naive Bayes AUC =", round(nb_auc, 4)),
    paste("Decision Tree AUC =", round(dt_auc, 4)),
    paste("Random Forest AUC =", round(rf_auc, 4))
  ),
  lwd = 2,
  cex = 0.8
)

dev.off()
