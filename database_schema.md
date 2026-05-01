# Database Schema Proposal (Drift)

To transition from `SharedPreferences` to `Drift` for local storage in the Expense Tracker project, the following schema is proposed. This design ensures data integrity, allows for complex queries, and provides a scalable foundation for future features.

## 1. `Transactions` Table
This is the core table storing all parsed financial transactions.

| Column Name | Drift Type | Dart/Logic Type | Description |
| :--- | :--- | :--- | :--- |
| `id` | `Int` | `int` | Primary Key, Auto-incrementing. |
| `amount` | `Real` | `double` | The transaction amount. |
| `type` | `Text` | `TransactionType` | Enum value (debit, credit, meta, unknown). |
| `merchant` | `Text?` | `String?` | The identified merchant or recipient. |
| `date` | `DateTime` | `DateTime` | Timestamp of the transaction. |
| `method` | `Text` | `PaymentMethod` | Enum value (upi, card, atm, imps, etc.). |
| `account` | `Text?` | `String?` | The bank account or card identifier (e.g., "XX1234"). |
| `available_balance`| `Real?` | `double?` | Remaining balance after the transaction. |
| `raw_sms` | `Text` | `String` | The original SMS body. **(Unique Index recommended)** |
| `bank_name` | `Text` | `String` | Name of the bank (e.g., SBI, HDFC). |
| `template_name` | `Text?` | `String?` | The name of the regex template used for parsing. |
| `is_verified` | `Bool` | `bool` | Whether the transaction was parsed with high confidence. |
| `is_sample` | `Bool` | `bool` | Flag to distinguish demo/sample data from real data. |

> **Note:** A unique index on `raw_sms` is highly recommended to automatically prevent duplicate transaction entries during sync.

## 2. `SmsLogs` Table
Replaces the `unsupported_sms_logs` list in `SharedPreferences`. Useful for debugging and improving parser accuracy.

| Column Name | Drift Type | Dart/Logic Type | Description |
| :--- | :--- | :--- | :--- |
| `id` | `Int` | `int` | Primary Key, Auto-incrementing. |
| `timestamp` | `DateTime` | `DateTime` | When the SMS was received/logged. |
| `sender` | `Text` | `String` | The SMS sender ID (e.g., "AD-KOTAKB"). |
| `body` | `Text` | `String` | The full content of the unsupported SMS. |

## 3. `AppSettings` Table
A flexible key-value store for global application state, replacing various individual keys in `SharedPreferences`.

| Column Name | Drift Type | Dart/Logic Type | Description |
| :--- | :--- | :--- | :--- |
| `key` | `Text` | `String` | Primary Key (e.g., `last_sync_timestamp`, `bank_configs_json`). |
| `value` | `Text?` | `String?` | The value stored as a string (JSON, numbers, etc.). |

---

## Why Drift?
1. **Type Safety**: Drift generates Dart classes based on your tables, ensuring you don't make typos with key names.
2. **Relational Queries**: You can easily filter transactions by bank, date range, or amount using SQL-like syntax.
3. **Reactive Updates**: Riverpod can listen to database streams, so the UI updates automatically when a new transaction is inserted.
4. **Migration Support**: As you add new features (like Categories or Budgets), Drift handles schema migrations gracefully.
5. **Performance**: Much faster than reading/writing large JSON strings to `SharedPreferences` as the data grows.
