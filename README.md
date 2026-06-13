# Machine Learning Fraud Detection

This repository contains a machine learning coursework project focused on detecting fraudulent financial transactions. The project uses R to prepare the data, perform exploratory data analysis, train classification models, compare model performance, and export figures and result tables for the final report.

## Project objective

The aim of this project is to evaluate whether machine learning models can distinguish fraudulent transactions from non-fraudulent transactions using transaction features such as transaction type, amount, account balances, and engineered balance-difference variables.

## Dataset summary

The dataset contains **24,192 transactions** with **11 original variables**. The target variable is `isFraud`, where transactions are labelled as fraudulent or non-fraudulent.

Class distribution:

| Class | Count | Percentage |
|---|---:|---:|
| NonFraud | 15,979 | 66.05% |
| Fraud | 8,213 | 33.95% |

Missing values were found in several variables, including `amount`, `Amount Category`, `oldbalanceOrg`, `newbalanceOrig`, `oldbalanceDest`, and `newbalanceDest`. The R script performs preprocessing and imputation before model training.

## Models compared

The following classification models were trained and evaluated:

- Logistic Regression
- k-Nearest Neighbours
- Naive Bayes
- Decision Tree
- Random Forest

The data was split into a **70% training set** and **30% testing set** using stratified sampling. The training set contained 16,936 rows and the testing set contained 7,256 rows.

## Main results

| Model | Accuracy | Sensitivity/Recall | Specificity | Balanced Accuracy | AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.8643 | 0.7600 | 0.9178 | 0.8389 | 0.9255 |
| KNN | 0.9362 | 0.8733 | 0.9685 | 0.9209 | 0.9832 |
| Naive Bayes | 0.7375 | 0.2400 | 0.9931 | 0.6165 | 0.9182 |
| Decision Tree | 0.9625 | 0.9521 | 0.9679 | 0.9600 | 0.9861 |
| Random Forest | **0.9850** | **0.9769** | **0.9892** | **0.9830** | **0.9984** |

The **Random Forest** model achieved the strongest overall performance, with the highest accuracy, recall, balanced accuracy, and AUC. This is important for fraud detection because recall measures how well the model identifies actual fraud cases.

## Repository structure

```text
machine-learning-fraud-detection/
├── data/
│   ├── Financial_Transactions.csv
│   └── README.md
├── docs/
│   └── GITHUB_UPLOAD_STEPS.md
├── outputs/
│   ├── model_comparison_results.csv
│   ├── random_forest_results.txt
│   └── other exported result tables
├── plots/
│   ├── fig_1_class_distribution.png
│   ├── fig_8_random_forest_importance.png
│   └── fig_9_roc_comparison.png
├── report/
│   └── README.md
├── src/
│   └── fraud_detection_analysis.R
├── .gitignore
├── README.md
└── requirements.R
```

## How to run the project

1. Open the project folder in RStudio.
2. Run the package installation file once:

```r
source("requirements.R")
```

3. Run the main analysis script from the project root:

```r
source("src/fraud_detection_analysis.R")
```

The script will generate updated output tables in `outputs/` and updated charts in `plots/`.

## Key output files

- `outputs/model_comparison_results.csv` — model performance comparison
- `outputs/random_forest_results.txt` — Random Forest model details and confusion matrix
- `outputs/random_forest_variable_importance.csv` — important predictor variables
- `plots/fig_8_random_forest_importance.png` — Random Forest variable importance plot
- `plots/fig_9_roc_comparison.png` — ROC curve comparison for all models



## Author

Devonte Williams  
BSc Cyber Security  
Leeds Beckett University
