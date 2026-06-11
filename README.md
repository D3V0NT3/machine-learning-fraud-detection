# machine-learning-fraud-detection
# Machine Learning Fraud Detection Report

## Project Overview

This project investigates the use of machine learning techniques for detecting fraudulent financial transactions. Fraud detection is an important real-world problem because fraudulent activity can cause financial loss, damage customer trust, and create operational risks for banks, payment providers, and online businesses.

The project compares different machine learning models and evaluates their performance using appropriate classification metrics. The main focus is on identifying fraudulent transactions accurately while considering the challenge of class imbalance, where fraudulent cases are much rarer than legitimate transactions.

## Objectives

The objectives of this project are to:

* Explore and prepare a fraud detection dataset.
* Identify patterns and relationships within transaction data.
* Train and compare machine learning classification models.
* Evaluate model performance using suitable metrics.
* Discuss the strengths and limitations of the models used.
* Recommend the most suitable approach for fraud detection.

## Dataset

The dataset used for this project contains transaction records labelled as fraudulent or legitimate. Due to the nature of fraud detection, the dataset is highly imbalanced, meaning fraudulent transactions represent a small proportion of the total data.

If the raw dataset is not included in this repository, it can be obtained from the original dataset source used in the coursework.

## Methods Used

The project includes the following stages:

1. Data loading and inspection
2. Exploratory data analysis
3. Data cleaning and preprocessing
4. Handling class imbalance
5. Model training
6. Model evaluation
7. Results comparison
8. Discussion and conclusion

## Machine Learning Models

The models considered in this project include:

* Logistic Regression
* Decision Tree
* Random Forest
* k-Nearest Neighbours
* Support Vector Machine

The final model selection is based on performance measures such as accuracy, precision, recall, F1-score, and the confusion matrix.

## Evaluation Metrics

Because fraud detection datasets are usually imbalanced, accuracy alone is not enough. The project focuses on:

* Precision
* Recall
* F1-score
* Confusion Matrix
* ROC Curve
* AUC Score

Recall is especially important because missing fraudulent transactions can be costly.

## Repository Structure

```text
report/     Final written report
code/       R scripts and R Markdown analysis files
data/       Dataset notes or source information
outputs/    Graphs, tables, and model evaluation outputs
```

## Tools and Technologies

* R
* RStudio
* Machine Learning
* Data Visualisation
* Classification Algorithms
* Fraud Detection Analysis

## Author

Devonte Williams
BSc Cyber Security
Leeds Beckett University

## Academic Note

This repository is intended to demonstrate the machine learning workflow, report structure, and technical approach used for a fraud detection coursework project. The final submitted version should follow university academic integrity rules.
