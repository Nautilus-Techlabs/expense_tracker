import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../remote/supabase/supabase_helper.dart';

/// Provides a singleton instance of SupabaseHelper for dependency injection.
/// This allows us to mock SupabaseHelper in unit tests by overriding this provider.
final supabaseHelperProvider = Provider<SupabaseHelper>((ref) {
  return SupabaseHelper();
});
