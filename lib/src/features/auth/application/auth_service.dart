import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/supabase_config.dart';

/// Identity snapshot for the authenticated user.
class AuthUser {
  AuthUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.provider,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final AuthProvider provider;

  static AuthUser? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AuthUser(
      uid: (json['uid'] as String?) ?? '',
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      provider: AuthProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => AuthProvider.local,
      ),
    );
  }

  // Backward compatibility with previous schema
  static AuthUser? fromMongo(Map<String, dynamic>? json) => fromJson(json);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'provider': provider.name,
      };

  Map<String, dynamic> toMongo() => toJson();
}

enum AuthProvider { google, apple, anonymous, email, local }

class _AuthException implements Exception {
  _AuthException(this.message, [this.cause, this.stackTrace]);
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => message;
}

/// Authentication and Profile synchronization service backed by Supabase.
class AuthService {
  AuthService();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _bootstrapped = false;
  final Set<void Function(AuthUser?)> _listeners = {};
  StreamSubscription<AuthState>? _supabaseAuthSub;
  AuthUser? _cachedUser;

  static const String _prefsKey = 'auth_user_supabase_v1';

  /// Boot Supabase Auth. Safe to call multiple times.
  Future<AuthService> init() async {
    if (_bootstrapped) return this;
    _bootstrapped = true;

    // Hydrate local cache first
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_prefsKey);
      if (cachedJson != null) {
        _cachedUser = AuthUser.fromJson(jsonDecode(cachedJson) as Map<String, dynamic>?);
        _dispatch(_cachedUser);
      }
    } catch (_) {}

    // ── Fallback only when Supabase is not configured ──
    if (!SupabaseConfig.isConfigured) {
      if (_cachedUser == null) {
        _cachedUser = AuthUser(
          uid: 'learner_${DateTime.now().millisecondsSinceEpoch % 10000}',
          displayName: 'Deutschy Learner',
          email: 'learner@deutschy.app',
          photoUrl: null,
          provider: AuthProvider.local,
        );
        await _persist(_cachedUser!);
      }
      _dispatch(_cachedUser);
      return this;
    }

    // ── Supabase Production Path (Web & Native) ──
    try {
      final client = SupabaseConfig.client;
      var currentSupabaseUser = client.auth.currentUser;

      // Auto-bootstrap guest session if none exists so user always has a valid cloud profile
      if (currentSupabaseUser == null) {
        try {
          final res = await client.auth.signInAnonymously();
          currentSupabaseUser = res.user;
        } catch (e) {
          debugPrint('[AuthService] Anonymous bootstrap note: $e');
          // If anonymous auth is disabled, fall back to a local guest user
          // so the app still works without requiring sign-in
          if (_cachedUser == null) {
            _cachedUser = AuthUser(
              uid: 'guest_${DateTime.now().millisecondsSinceEpoch % 100000}',
              displayName: 'Deutschy Learner',
              email: null,
              photoUrl: null,
              provider: AuthProvider.local,
            );
            await _persist(_cachedUser!);
            _dispatch(_cachedUser);
            return this;
          }
        }
      }

      if (currentSupabaseUser != null) {
        _cachedUser = _userFromSupabase(currentSupabaseUser);
        _dispatch(_cachedUser);
      }

      // Initialize Google Sign In client id on mobile
      if (!kIsWeb) {
        try {
          await _googleSignIn.initialize(serverClientId: kGoogleServerClientId);
        } catch (e) {
          debugPrint('[AuthService] GoogleSignIn.initialize: $e');
        }
      }

      // Listen to live Supabase auth transitions
      _supabaseAuthSub = client.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        final user = _userFromSupabase(session?.user);
        _cachedUser = user;
        if (user != null) {
          _persist(user);
        } else {
          _clearPersisted();
        }
        _dispatch(user);
      });
    } catch (e) {
      debugPrint('[AuthService] Supabase init warning: $e');
    }

    return this;
  }

  /// Reactive stream for Riverpod providers
  Stream<AuthUser?> watch() async* {
    await init();
    yield _cachedUser;

    if (SupabaseConfig.isConfigured) {
      await for (final data in SupabaseConfig.client.auth.onAuthStateChange) {
        final user = _userFromSupabase(data.session?.user);
        if (user != null || _cachedUser?.provider != AuthProvider.local) {
          yield user;
        }
      }
    } else {
      // Idle stream to keep provider active
      await Future<void>.delayed(const Duration(days: 365));
    }
  }

  /// Synchronous snapshot
  AuthUser? currentUser() => _cachedUser;

  AuthUser? _userFromSupabase(User? su) {
    if (su == null) return null;
    final meta = su.userMetadata ?? {};
    final name = (meta['full_name'] as String?) ??
        (meta['name'] as String?) ??
        su.email?.split('@').first;
    final photo = meta['avatar_url'] as String?;
    final providerStr = su.appMetadata['provider'] as String? ?? '';

    AuthProvider prov = AuthProvider.local;
    if (su.isAnonymous) {
      prov = AuthProvider.anonymous;
    } else if (providerStr.contains('google')) {
      prov = AuthProvider.google;
    } else if (providerStr.contains('apple')) {
      prov = AuthProvider.apple;
    } else if (su.email != null) {
      prov = AuthProvider.email;
    }

    return AuthUser(
      uid: su.id,
      displayName: name,
      email: su.email,
      photoUrl: photo,
      provider: prov,
    );
  }

  Future<void> _persist(AuthUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  Future<void> _clearPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    } catch (_) {}
  }

  // --------------------------------------------------------------
  // PUBLIC SIGN-IN FLOWS
  // --------------------------------------------------------------

  /// Google Sign-In with Supabase.
  /// On web: uses OAuth redirect flow (no native google_sign_in needed).
  /// On mobile: uses native google_sign_in + signInWithIdToken.
  Future<AuthUser?> signInWithGoogle() async {
    await init();
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[AuthService] Supabase not configured — using guest user.');
      return _cachedUser;
    }

    // ── Web: use Supabase OAuth redirect (no native SDK) ──
    if (kIsWeb) {
      try {
        await SupabaseConfig.client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: Uri.base.origin, // redirect back to current page
        );
        // The browser will redirect; on return, onAuthStateChange fires.
        return _cachedUser;
      } catch (e, s) {
        debugPrint('[AuthService] Google OAuth (web) error: $e');
        throw _AuthException('Google Sign-In failed: $e', e, s);
      }
    }

    // ── Mobile: use native Google Sign-In + ID token ──
    try {
      GoogleSignInAccount? account;
      try {
        account = await _googleSignIn.attemptLightweightAuthentication();
      } catch (_) {}

      account ??= await _googleSignIn.authenticate(scopeHint: const ['email', 'profile']);

      final googleAuth = account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw _AuthException('Missing Google ID Token.');
      }

      final response = await SupabaseConfig.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = _userFromSupabase(response.user);
      if (user != null) {
        _cachedUser = user;
        await _persist(user);
        _dispatch(user);
      }
      return user;
    } catch (e, s) {
      debugPrint('[AuthService] Google Sign In error: $e');
      throw _AuthException('Google Sign-In failed: $e', e, s);
    }
  }

  /// Apple Sign-In with Supabase
  Future<AuthUser?> signInWithApple() async {
    await init();
    if (!SupabaseConfig.isConfigured) {
      return _cachedUser;
    }

    try {
      final appleCred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (appleCred.identityToken == null) return null;

      final response = await SupabaseConfig.client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: appleCred.identityToken!,
      );

      final user = _userFromSupabase(response.user);
      if (user != null) {
        _cachedUser = user;
        await _persist(user);
        _dispatch(user);
      }
      return user;
    } catch (e) {
      debugPrint('[AuthService] Apple Sign In error: $e');
      return null;
    }
  }

  /// Anonymous / Guest Sign-In
  Future<AuthUser?> signInAnonymously() async {
    await init();
    if (!SupabaseConfig.isConfigured) {
      return _cachedUser;
    }

    try {
      final response = await SupabaseConfig.client.auth.signInAnonymously();
      final user = _userFromSupabase(response.user);
      if (user != null) {
        _cachedUser = user;
        await _persist(user);
        _dispatch(user);
      }
      return user;
    } catch (e) {
      debugPrint('[AuthService] Anonymous sign-in error: $e');
      if (_cachedUser == null) {
        final guest = AuthUser(
          uid: 'guest_${DateTime.now().millisecondsSinceEpoch % 100000}',
          displayName: 'Deutschy Learner',
          email: null,
          photoUrl: null,
          provider: AuthProvider.local,
        );
        _cachedUser = guest;
        await _persist(guest);
        _dispatch(guest);
      }
      return _cachedUser;
    }
  }

  /// Email & Password Sign-In
  Future<AuthUser?> signInWithEmail(String email, String password) async {
    await init();
    if (!SupabaseConfig.isConfigured) return _cachedUser;

    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = _userFromSupabase(response.user);
      if (user != null) {
        _cachedUser = user;
        await _persist(user);
        _dispatch(user);
      }
      return user;
    } catch (e) {
      debugPrint('[AuthService] Email sign-in error: $e');
      rethrow;
    }
  }

  /// Email & Password Registration
  Future<AuthUser?> signUpWithEmail(String email, String password) async {
    await init();
    if (!SupabaseConfig.isConfigured) return _cachedUser;

    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      final user = _userFromSupabase(response.user);
      if (user != null) {
        _cachedUser = user;
        await _persist(user);
        _dispatch(user);
      }
      return user;
    } catch (e) {
      debugPrint('[AuthService] Email sign-up error: $e');
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    if (SupabaseConfig.isConfigured) {
      try {
        await SupabaseConfig.client.auth.signOut();
      } catch (_) {}
    }

    _cachedUser = null;
    await _clearPersisted();
    _dispatch(null);
  }

  // --------------------------------------------------------------
  // CLOUD PROFILE SYNC (Syncs onboarding preferences to Supabase)
  // --------------------------------------------------------------
  Future<void> syncProfile({
    String? nativeLanguage,
    String? reason,
    String? targetLevel,
    int? dailyGoalMinutes,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[AuthService] Profile sync: Supabase not configured, saved locally.');
      return;
    }

    final user = _cachedUser;
    if (user == null) return;

    try {
      final updates = <String, dynamic>{
        'id': user.uid,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (nativeLanguage != null) updates['native_language'] = nativeLanguage;
      if (reason != null) updates['reason'] = reason;
      if (targetLevel != null) {
        updates['start_level'] = targetLevel;
        updates['current_level'] = targetLevel;
      }
      if (dailyGoalMinutes != null) updates['daily_goal_minutes'] = dailyGoalMinutes;

      await SupabaseConfig.client.from('profiles').upsert(updates);
      debugPrint('[AuthService] Profile synced to Supabase successfully: $updates');
    } catch (e) {
      debugPrint('[AuthService] Cloud profile sync error: $e');
    }
  }

  void addListener(void Function(AuthUser?) cb) => _listeners.add(cb);
  void removeListener(void Function(AuthUser?) cb) => _listeners.remove(cb);
  void _dispatch(AuthUser? u) {
    for (final l in List<void Function(AuthUser?)>.from(_listeners)) {
      try {
        l(u);
      } catch (_) {}
    }
  }

  Future<void> dispose() async {
    await _supabaseAuthSub?.cancel();
    _listeners.clear();
  }
}
