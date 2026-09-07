import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../remote/supabase/supabase_helper.dart';

/// Provides a singleton instance of SupabaseHelper for dependency injection.
/// This allows us to mock SupabaseHelper in unit tests by overriding this provider.
final supabaseHelperProvider = Provider<SupabaseHelper>((ref) {
  return SupabaseHelper();
});

/// Provides a singleton FCMService backed by the shared SupabaseHelper.
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(ref.read(supabaseHelperProvider));
});
