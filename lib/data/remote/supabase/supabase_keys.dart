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
  static const String rpcGetReports = 'get_reports';
  static const String rpcGetReportSpendingBreakdown =
      'get_report_spending_breakdown';

  // Circle RPC functions
  static const String rpcCreateCircle = 'create_circle';
  static const String rpcAddCircleMember = 'add_circle_member';
  static const String rpcChangeMemberRole = 'change_member_role';
  static const String rpcTransferCircleOwnership = 'transfer_circle_ownership';
  static const String rpcRemoveCircleMember = 'remove_circle_member';
  static const String rpcLeaveCircle = 'leave_circle';
  static const String rpcDeleteCircle = 'delete_circle';
  static const String rpcGetCirclesScreenData = 'get_circles_screen_data';
  static const String rpcGetCircleDetailsScreenData =
      'get_circle_detail_screen';
  static const String rpcCreateCircleTransaction = 'create_circle_transaction';

  // Balances & Settlement RPC functions
  static const String rpcGetPairwiseBalance = 'get_pairwise_balance';
  static const String rpcGetUserBalances = 'get_user_balances';
  static const String rpcRecordSettlement = 'record_settlement';

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
