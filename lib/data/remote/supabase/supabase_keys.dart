class SupabaseKeys {
  // Tables
  static const String tableTransactions = 'transactions';
  static const String tableCircles = 'circles';
  static const String tableMembers = 'members';
  static const String tableAccounts = 'accounts';
  static const String tableCategories = 'categories';
  static const String tableUsers = 'users';
  static const String tableMonthlyBudgets = 'user_monthly_budget';

  // RPC functions
  static const String rpcGetTransactions = 'get_transactions';

  // Common Columns
  static const String colId = 'id';
  static const String colCreatedAt = 'created_at';
  static const String colUserId = 'user_id';

  // Transactions Columns
  static const String colAmount = 'amount';
  static const String colType = 'type';
  static const String colTitle = 'title';
  static const String colDate = 'date';
  static const String colCategoryId = 'category_id';
  static const String colAccountId = 'account_id';
}
