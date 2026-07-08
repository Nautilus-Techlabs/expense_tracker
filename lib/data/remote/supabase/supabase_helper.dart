import 'package:either_dart/either.dart';
import 'package:expense_tracker/core/error/failure.dart';
import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/data/remote/supabase/supabase_keys.dart';
import 'package:expense_tracker/features/auth/model/user_model.dart';
import 'package:expense_tracker/features/auth/model/user_payload.dart';
import 'package:expense_tracker/features/personal_expenses/models/account_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/category_model.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetch all records from a specific table
  Future<Either<String, List<Map<String, dynamic>>>> fetchFromTable(
    String table,
  ) async {
    try {
      final response = await supabase.from(table).select();
      return Right(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Left('Failed to fetch from $table: $e');
    }
  }

  /// Insert a record into a specific table
  Future<Either<String, void>> insertIntoTable(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      await supabase.from(table).insert(data);
      return const Right(null);
    } catch (e) {
      return Left('Failed to insert into $table: $e');
    }
  }

  /// Update a record in a specific table
  Future<Either<String, void>> updateInTable(
    String table,
    Map<String, dynamic> data,
    String matchColumn,
    dynamic matchValue,
  ) async {
    try {
      await supabase.from(table).update(data).eq(matchColumn, matchValue);
      return const Right(null);
    } catch (e) {
      return Left('Failed to update $table: $e');
    }
  }

  /// Delete a record from a specific table
  Future<Either<String, void>> deleteFromTable(
    String table,
    String matchColumn,
    dynamic matchValue,
  ) async {
    try {
      await supabase.from(table).delete().eq(matchColumn, matchValue);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete from $table: $e');
    }
  }

  /// Execute an RPC function
  Future<Either<String, dynamic>> callRpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await supabase.rpc(functionName, params: params);
      return Right(response);
    } catch (e) {
      return Left('Failed to execute RPC $functionName: $e');
    }
  }

  Future<Either<Failure, UserModel>> createUser(UserPayload data) async {
    try {
      final existingUser = await supabase
          .from(SupabaseKeys.tableUsers)
          .select('email')
          .eq('email', data.email)
          .maybeSingle();

      if (existingUser != null) {
        return Left(Failure('A user with this email already exists.'));
      }

      final signUpResponse = await supabase.auth.signUp(
        password: data.password!,
        email: data.email,
      );
      final user = signUpResponse.user;

      if (user == null) {
        return Left(Failure('Failed to sign up user via Supabase Auth.'));
      }
      final userId = user.id;

      final insertResponse = await supabase
          .from(SupabaseKeys.tableUsers)
          .insert({
            'full_name': data.name,
            'phone': data.phone,
            'email': data.email,
            'auth_id': userId,
          })
          .select()
          .single();

      final userModel = UserModel.fromJson(insertResponse);
      AppLogger.i('User created successfully: $userModel');
      return Right(userModel);
    } catch (e) {
      AppLogger.e('Error creating user: $e');
      return Left(Failure('Error Creating User: $e'));
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
      return Right(transactions);
    } catch (e) {
      return Left(Failure('Error fetching transactions: $e'));
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
}
