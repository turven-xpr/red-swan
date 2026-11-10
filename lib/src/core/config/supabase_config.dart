import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration for Supabase Backend.
///
/// In production, pass credentials using `--dart-define`:
///   `flutter run --dart-define=SUPABASE_URL=https://your-id.supabase.co --dart-define=SUPABASE_ANON_KEY=your-key`
///
/// Or set [defaultUrl] and [defaultAnonKey] below with your project credentials.
class SupabaseConfig {
  SupabaseConfig._();

  // You can replace these default placeholders with your actual Supabase project keys
  static const String defaultUrl = 'https://placeholder.supabase.co';
  static const String defaultAnonKey = 'placeholder-anon-key';

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
    return url != defaultUrl &&
        anonKey != defaultAnonKey &&
        url.trim().isNotEmpty &&
        anonKey.trim().isNotEmpty;
  }

  /// Convenience getter for the global Supabase client.
  static SupabaseClient get client => Supabase.instance.client;
}

