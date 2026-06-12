# Dataset

This folder contains the raw transaction dataset used by the R analysis script.

## File

- `Financial_Transactions.csv` — raw financial transaction records.

## Main columns

| Column | Description |
|---|---|
| `step` | Time step of the transaction |
| `type` | Transaction type, such as TRANSFER, CASH_OUT, PAYMENT, or DEBIT |
| `amount` | Transaction amount |
| `Amount Category` | Categorical amount band |
| `nameOrig` | Origin account/customer identifier |
| `oldbalanceOrg` | Origin account balance before transaction |
| `newbalanceOrig` | Origin account balance after transaction |
| `nameDest` | Destination account/customer identifier |
| `oldbalanceDest` | Destination account balance before transaction |
| `newbalanceDest` | Destination account balance after transaction |
| `isFraud` | Target label: fraud or non-fraud |

Do not upload private or real customer financial data to a public repository.
