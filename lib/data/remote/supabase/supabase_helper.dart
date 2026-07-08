import 'package:either_dart/either.dart';
import 'package:expense_tracker/core/error/failure.dart';
import 'package:expense_tracker/data/remote/supabase/supabase_keys.dart';
import 'package:expense_tracker/features/auth/model/user_model.dart';
import 'package:expense_tracker/features/auth/model/user_payload.dart';
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
      return Right(userModel);
    } catch (e) {
      return Left(Failure('Error Creating User: $e'));
    }
  }
}
