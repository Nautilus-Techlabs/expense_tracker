import 'package:either_dart/either.dart';
import 'package:expense_tracker/core/cache/cache_manager.dart';
import 'package:expense_tracker/core/error/failure.dart';
import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/data/remote/supabase/supabase_keys.dart';
import 'package:expense_tracker/features/auth/model/user_model.dart';
import 'package:expense_tracker/features/auth/model/user_payload.dart';
import 'package:expense_tracker/features/personal_expenses/models/account_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/budget_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/category_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/reports_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_payload.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  final SupabaseClient supabase = Supabase.instance.client;
  final CacheManager cacheManager = CacheManager();

  Future<Either<Failure, UserModel>> createUser(UserPayload data) async {
    try {
      final signUpResponse = await supabase.auth.signUp(
        password: data.password!,
        email: data.email,
      );

      final user = signUpResponse.user;
      if (user == null) {
        return Left(Failure('Signup failed. Please try again.'));
      }

      final insertResponse = await supabase
          .from(SupabaseKeys.tableUsers)
          .insert({
            'full_name': data.name,
            'email': data.email,
            'auth_id': user.id,
          })
          .select()
          .single();

      return Right(UserModel.fromJson(insertResponse));
    } on AuthException catch (e) {
      // Supabase auth errors — email already registered etc
      AppLogger.e('Auth error: ${e.message}');
      return Left(Failure(e.message));
    } on PostgrestException catch (e) {
      // DB constraint violations — duplicate email/phone
      AppLogger.e('DB error: ${e.message}');
      if (e.code == '23505') {
        return Left(Failure('An account with this email already exists.'));
      }
      return Left(Failure('Failed to create profile. Please try again.'));
    } catch (e) {
      AppLogger.e('Unexpected error: $e');
      return Left(Failure('Something went wrong. Please try again.'));
    }
  }

  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(OAuthProvider.google);
      return const Right(null);
    } on AuthException catch (e) {
      AppLogger.e('Google Auth error: ${e.message}');
      return Left(Failure(e.message));
    } catch (e) {
      AppLogger.e('Unexpected Google error: $e');
      return Left(Failure('Something went wrong with Google sign-in.'));
    }
  }

  Future<Either<Failure, UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return Left(Failure('Sign in failed.'));
      }

      final profileResponse = await supabase
          .from(SupabaseKeys.tableUsers)
          .select()
          .eq('auth_id', user.id)
          .single();

      return Right(UserModel.fromJson(profileResponse));
    } on AuthException catch (e) {
      AppLogger.e('Auth error: ${e.message}');
      return Left(Failure(e.message));
    } catch (e) {
      AppLogger.e('Unexpected error: $e');
      return Left(Failure('Something went wrong. Please try again.'));
    }
  }

  Future<Either<Failure, UserModel>> fetchUserProfile(String authId) async {
    try {
      final profileResponse = await supabase
          .from(SupabaseKeys.tableUsers)
          .select()
          .eq('auth_id', authId)
          .single();

      return Right(UserModel.fromJson(profileResponse));
    } catch (e) {
      AppLogger.e('Error fetching profile: $e');
      return Left(Failure('Failed to load profile.'));
    }
  }

  Future<Either<Failure, List<CategoryModel>>> fetchAllCategories() async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableCategories)
          .select();
      final categories = response
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(Failure('Error fetching categories: $e'));
    }
  }

  Future<Either<Failure, List<TransactionModel>>> fetchAllTransactions(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableTransactions)
          .select()
          .eq('user_id', userId);
      final transactions = response
          .map((json) => TransactionModel.fromJson(json))
          .toList();
      AppLogger.d('Fetched transactions: ${transactions.length}');
      return Right(transactions);
    } catch (e) {
      AppLogger.e('Error fetching transactions: $e');
      return Left(Failure('Error fetching transactions: $e'));
    }
  }

  Future<Either<Failure, TransactionModel>> addTransactions(
    TransactionPayload payload,
  ) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableTransactions)
          .insert(payload.toJson())
          .select()
          .single();
      AppLogger.d('Inserted transactions: $response');
      return Right(TransactionModel.fromJson(response));
    } catch (e) {
      AppLogger.e('Error inserting transactions: $e');
      return Left(Failure('Error inserting transactions: $e'));
    }
  }

  Future<Either<Failure, TransactionModel>> editTransaction(
    TransactionPayload payload,
  ) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableTransactions)
          .update(payload.toJson())
          .select()
          .single();
      AppLogger.d('Edited transactions: $response');
      return Right(TransactionModel.fromJson(response));
    } catch (e) {
      AppLogger.e('Error editing transactions: $e');
      return Left(Failure('Error editing transactions: $e'));
    }
  }

  Future<Either<Failure, List<AccountModel>>> fetchAllAccounts(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableAccounts)
          .select()
          .eq('user_id', userId);
      final accounts = response
          .map((json) => AccountModel.fromJson(json))
          .toList();
      return Right(accounts);
    } catch (e) {
      return Left(Failure('Error fetching accounts: $e'));
    }
  }

  Future<Either<Failure, AccountModel>> createAccount({
    required String userId,
    required String name,
    required AccountType type,
    required double balance,
  }) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableAccounts)
          .insert({
            'user_id': userId,
            'name': name,
            'type': type.name, // Assuming enum to string conversion matches DB
            'balance': balance,
            'opening_balance': balance,
          })
          .select()
          .single();

      return Right(AccountModel.fromJson(response));
    } catch (e) {
      AppLogger.e('Error creating account: $e');
      return Left(Failure('Failed to create account.'));
    }
  }

  Future<Either<Failure, UserMonthlyBudget>> createMonthlyBudget({
    required String userId,
    required double amount,
    required DateTime month,
  }) async {
    try {
      final dateString =
          "${month.year}-${month.month.toString().padLeft(2, '0')}-01";
      final response = await supabase
          .from(SupabaseKeys.tableMonthlyBudgets)
          .insert({'user_id': userId, 'amount': amount, 'month': dateString})
          .select()
          .single();
      final payload = {
        'user_id': userId,
        'amount': amount,
        'month': dateString,
      };
      debugPrint(
        'PAYLOAD TYPES: ${payload.map((k, v) => MapEntry(k, v.runtimeType))}',
      );

      return Right(UserMonthlyBudget.fromJson(response));
    } catch (e) {
      AppLogger.e('Error creating monthly budget: $e');
      return Left(Failure('Failed to create monthly budget.'));
    }
  }

  Future<Either<Failure, UserMonthlyBudget>> fetchMonthlyBudget({
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      final dateString =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-01";

      final response = await supabase
          .from(SupabaseKeys.tableMonthlyBudgets)
          .select()
          .eq('user_id', userId)
          .eq('month', dateString)
          .maybeSingle();

      if (response == null) {
        return Left(Failure('No budget set for this month.'));
      }

      return Right(UserMonthlyBudget.fromJson(response));
    } catch (e) {
      AppLogger.e('Error fetching monthly budget: $e');
      return Left(Failure('Failed to fetch monthly budget.'));
    }
  }

  Future<Either<Failure, UserMonthlyBudget>> updateMonthlyBudget({
    required String userId,
    required double amount,
    required DateTime month,
  }) async {
    try {
      final dateString =
          "${month.year}-${month.month.toString().padLeft(2, '0')}-01";
      final response = await supabase
          .from(SupabaseKeys.tableMonthlyBudgets)
          .update({'amount': amount})
          .eq('user_id', userId)
          .eq('month', dateString)
          .select()
          .single();

      return Right(UserMonthlyBudget.fromJson(response));
    } catch (e) {
      AppLogger.e('Error updating monthly budget: $e');
      return Left(Failure('Error updating monthly budget: $e'));
    }
  }

  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required String type, // 'expense', 'income', 'both'
    required String icon,
    required String color,
  }) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableCategories)
          .insert({'name': name, 'type': type, 'icon': icon, 'color': color})
          .select()
          .single();

      return Right(CategoryModel.fromJson(response));
    } catch (e) {
      AppLogger.e('Error creating category: $e');
      return Left(Failure('Failed to create category.'));
    }
  }

  Future<Either<Failure, TransactionModel>> updateTransaction({
    required String transactionId,
    required TransactionPayload updates,
  }) async {
    try {
      final response = await supabase
          .from(SupabaseKeys.tableTransactions)
          .update({
            'account_id': updates.accountId,
            'category_id': updates.categoryId,
            'circle_id': updates.circleId,
            'type': updates.type,
            'amount': updates.amount,
            'note': updates.note,
          })
          .eq('id', transactionId)
          .select()
          .single();

      return Right(TransactionModel.fromJson(response));
    } catch (e) {
      AppLogger.e('Error updating transaction: $e');
      return Left(Failure('Failed to update transaction.'));
    }
  }

  Future<Either<Failure, void>> deleteTransaction({
    required String transactionId,
  }) async {
    try {
      await supabase
          .from(SupabaseKeys.tableTransactions)
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', transactionId);

      return const Right(null);
    } catch (e) {
      AppLogger.e('Error deleting transaction: $e');
      return Left(Failure('Failed to delete transaction.'));
    }
  }

  Future<Either<Failure, ReportModel>> fetchUserReports({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required String groupBy,
    required bool fillGaps,
    required int topCategories,
    required bool includeZeroAcc,
  }) async {
    try {
      final response = await supabase.rpc(
        SupabaseKeys.rpcGetReports,
        params: {
          "p_user_id": userId,
          "p_start_date": startDate.toIso8601String(),
          "p_end_date": endDate.toIso8601String(),
          "p_group_by": groupBy,
          "p_fill_gaps": fillGaps,
          "p_top_categories": topCategories,
          "p_include_zero_accounts": includeZeroAcc,
        },
      );
      final report = ReportModel.fromJson(response);
      return Right(report);
    } catch (e) {
      AppLogger.e('Error fetching user reports: $e');
      return Left(Failure('Failed to fetch user reports.'));
    }
  }

  Future<Either<Failure, SpendingBreakdown>> getSpendingBreakdown({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int topCategories,
    required bool groupByOthers,
  }) async {
    try {
      final response = await supabase.rpc(
        SupabaseKeys.rpcGetReportSpendingBreakdown,
        params: {
          "p_user_id": userId,
          "p_start_date": startDate.toIso8601String(),
          "p_end_date": endDate.toIso8601String(),
          "p_top_categories": topCategories,
          "p_group_others": groupByOthers,
        },
      );
      final report = SpendingBreakdown.fromJson(response);
      return Right(report);
    } catch (e) {
      AppLogger.e('Error fetching spending breakdown: $e');
      return Left(Failure('Failed to fetch spending breakdown.'));
    }
  }
}
