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
