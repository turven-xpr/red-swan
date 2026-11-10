import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration for Supabase Backend.
///
/// In production, pass credentials using `--dart-define`:
///   `flutter run --dart-define=SUPABASE_URL=https://your-id.supabase.co --dart-define=SUPABASE_ANON_KEY=your-key`
///
/// Or set [defaultUrl] and [defaultAnonKey] below with your project credentials.
class SupabaseConfig {
  SupabaseConfig._();

  static const String defaultUrl = 'https://aesrkewhcmvusitdlznr.supabase.co';
  static const String defaultAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlc3JrZXdoY212dXNpdGRsem5yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQzNDE0NDYsImV4cCI6MjEwOTkxNzQ0Nn0.ziZg_U2osR--gFEgqHJqJpwetq7dT-cmdwQoOmcD5D8';

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: defaultUrl,
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: defaultAnonKey,
  );

  /// Modern Supabase SDK alias for anonKey
  static String get publishableKey => anonKey;

  /// Returns true when valid Supabase credentials have been configured.
  static bool get isConfigured {
    return url.trim().isNotEmpty &&
        anonKey.trim().isNotEmpty &&
        !url.contains('placeholder.supabase.co');
  }

  /// Convenience getter for the global Supabase client.
  static SupabaseClient get client => Supabase.instance.client;
}

