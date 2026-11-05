import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../../firebase_options.dart';

/// Identity snapshot for the authenticated user.
///
/// Source of truth — `firebase_auth.User`.  We mirror a few fields
/// locally so screens that don't have a Firebase connection (offline
/// or pre-init) still get an immediate snapshot.
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

  /// Avatars / names update sometimes (e.g. user changes Google profile
  /// photo).  To pick those up we mirror what we *store* in prefs but
  /// always show the live `firebase_auth.User` snapshot.
  static AuthUser? fromMongo(Map<String, dynamic>? json) {
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

  Map<String, dynamic> toMongo() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'provider': provider.name,
      };
}

enum AuthProvider { google, apple, anonymous, local }

/// Domain-specific exception so the UI can differentiate configuration
/// errors (missing SHA-1, wrong OAuth client id, etc.) from plain
/// user-cancellation.
class _AuthException implements Exception {
  _AuthException(this.message, [this.cause, this.stackTrace]);
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => message;
}

/// Auth service backed by Firebase Auth.
///
/// Apple Sign-In is the **only** social provider App Store review
/// *requires* on iOS when another social provider is offered, so we
/// ship it; sign-in fires through Firebase to unify identity.
class AuthService {
  AuthService();

  firebase_auth.FirebaseAuth get _auth => firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// True once `Firebase.initializeApp` has been awaited.  Re-call is a
  /// no-op.  Call from `main.dart` before the router mounts.
  bool _bootstrapped = false;

  /// Set of auth-state-changed listeners registered by callers.
  final Set<void Function(AuthUser?)> _listeners = {};

  /// Subscribes the Firebase auth stream once and forwards every state
  /// change to local listeners.  Returns the controller's lifecycle.
  StreamSubscription<firebase_auth.User?>? _firebaseSub;

  static const String _prefsKey = 'auth_user_v1';

  /// Boot Firebase.  Idempotent.
  ///
  /// On web preview builds, skips Firebase entirely and emits a local
  /// guest user so the app is immediately usable in Chrome.
  Future<AuthService> init() async {
    if (_bootstrapped) return this;
    _bootstrapped = true;

    // ── Web Preview: skip Firebase, emit guest user immediately ──
    if (kIsWeb) {
      debugPrint('[AuthService] Web preview mode — using guest user.');
      final guest = AuthUser(
        uid: 'web_preview_user',
        displayName: 'Web Learner',
        email: 'preview@deutschy.app',
        photoUrl: null,
        provider: AuthProvider.local,
      );
      _dispatch(guest);
      return this;
    }
    // ── Native path (Android / iOS) — unchanged ──

    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        // Swallow duplicate-app race on hot restart / isolate reuse.
        if (!e.toString().contains('duplicate-app')) rethrow;
      }
    }
    // Hand the Web OAuth client id to google_sign_in.  Without it
    // `GoogleSignIn.authenticate()` raises
    // `GoogleSignInExceptionCode.clientConfigurationError` on Android.
    try {
      await _googleSignIn.initialize(
        serverClientId: kGoogleServerClientId,
      );
    } catch (e) {
      debugPrint('GoogleSignIn.initialize failed: $e');
    }
    _firebaseSub = _auth
        .authStateChanges()
        .listen((user) => _dispatch(_userFromFirebase(user)));
    return this;
  }

  /// Reactive subscription.  Fires both the current snapshot and every
  /// firebase change thereafter.  Wire to a Riverpod `StreamProvider`.
  Stream<AuthUser?> watch() async* {
    await init();

    // ── Web Preview: emit persistent guest, no Firebase stream ──
    if (kIsWeb) {
      yield AuthUser(
        uid: 'web_preview_user',
        displayName: 'Web Learner',
        email: 'preview@deutschy.app',
        photoUrl: null,
        provider: AuthProvider.local,
      );
      // Keep the stream alive but idle so the provider doesn't close.
      await Future<void>.delayed(const Duration(days: 365));
      return;
    }
    // ── Native path ──

    yield _userFromFirebase(_auth.currentUser);
    await for (final fbUser in _auth.authStateChanges()) {
      yield _userFromFirebase(fbUser);
    }
  }

  /// Synchronous fallback (used during cold start before Firebase boots).
  AuthUser? currentUser() {
    if (kIsWeb) {
      return AuthUser(
        uid: 'web_preview_user',
        displayName: 'Web Learner',
        email: 'preview@deutschy.app',
        photoUrl: null,
        provider: AuthProvider.local,
      );
    }
    if (Firebase.apps.isEmpty) return null;
    return _userFromFirebase(_auth.currentUser);
  }

  /// Friendly accessor.  We rebuild the AuthUser projection on demand.
  AuthUser? _userFromFirebase(firebase_auth.User? fb) {
    if (fb == null) return null;
    final provider = fb.providerData.isNotEmpty
        ? _providerFromString(fb.providerData.first.providerId)
        : AuthProvider.local;
    return AuthUser(
      uid: fb.uid,
      displayName: fb.displayName,
      email: fb.email,
      photoUrl: fb.photoURL,
      provider: provider,
    );
  }

  /// Hydrate the mirror in SharedPreferences so the splash -> dashboard
  /// transition feels instant.
  Future<void> _persist(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(user.toMongo()));
  }

  AuthProvider _providerFromString(String id) {
    if (id == 'google.com') return AuthProvider.google;
    if (id == 'apple.com') return AuthProvider.apple;
    if (id == 'anonymous') return AuthProvider.anonymous;
    return AuthProvider.local;
  }

  // --------------------------------------------------------------
  // PUBLIC: SIGN-IN FLOWS
  // --------------------------------------------------------------

  /// Returns a [firebase_auth.User] on success, or throws an exception on
  /// failure so callers can distinguish user cancellation from config errors.
  ///
  /// On Android we let `firebase_auth` handle the lower-level Google
  /// dialog via native APIs as well as on iOS.  On Windows / Web we
  /// fall back to opening a hosted OAuth tab in the browser.
  Future<AuthUser?> signInWithGoogle() async {
    await init();
    GoogleSignInAccount? account;
    // 1. Try silent restore first.
    try {
      account = await _googleSignIn.attemptLightweightAuthentication();
    } on GoogleSignInException catch (e, s) {
      debugPrint('lightweight auth failed: ${e.code} / ${e.description}');
      // Re-throw non-cancellation errors so the UI can show a real message.
      if (e.code != GoogleSignInExceptionCode.canceled &&
          e.code != GoogleSignInExceptionCode.interrupted &&
          e.code != GoogleSignInExceptionCode.uiUnavailable) {
        throw _AuthException('Google Sign-In error: ${e.description}', e, s);
      }
    }
    // 2. Interactive sign-in if silent restore returned nothing.
    if (account == null) {
      try {
        account = await _googleSignIn.authenticate(
          scopeHint: const ['email', 'profile'],
        );
      } on GoogleSignInException catch (e, s) {
        debugPrint('interactive auth failed: ${e.code} / ${e.description}');
        if (e.code == GoogleSignInExceptionCode.canceled ||
            e.code == GoogleSignInExceptionCode.interrupted ||
            e.code == GoogleSignInExceptionCode.uiUnavailable) {
          return null; // User genuinely cancelled.
        }
        throw _AuthException('Google Sign-In error: ${e.description}', e, s);
      }
    }
    final googleAuth = account.authentication;
    // Guard: if we couldn't grab a valid idToken, surface the real error
    // instead of letting Firebase throw an opaque "cancelled" exception.
    if (googleAuth.idToken == null) {
      throw _AuthException(
        'Missing idToken from Google.  '
        'Check that the SHA-1 fingerprint of your signing keystore is '
        'registered in the Firebase console for this Android app.',
      );
    }
    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final fbUser = userCredential.user;
    final user = _userFromFirebase(fbUser);
    if (user != null) await _persist(user);
    return user;
  }

  /// Apple Sign-In routed through Firebase Auth.  Apple is required by
  /// App Store review alongside any other social provider.
  Future<AuthUser?> signInWithApple() async {
    await init();
    try {
      final appleCred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (appleCred.identityToken == null) return null;
      // Apple -> Firebase: only the identityToken is required for the
      // mobile (iOS) flow.  `rawNonce` is for server-side flows; on
      // device we simply omit it.  Firebase's Apple provider in v5
      // ignores `authorizationCode` here.
      final oauthCredential = firebase_auth.OAuthProvider('apple.com')
          .credential(idToken: appleCred.identityToken!);
      final userCredential =
          await _auth.signInWithCredential(oauthCredential);
      final fbUser = userCredential.user;
      final user = _userFromFirebase(fbUser);
      if (user != null) await _persist(user);
      return user;
    } catch (e) {
      debugPrint('apple sign-in: $e');
      return null;
    }
  }

  /// Anonymous sign-in.  Useful as fallback if a user hits "Continue
  /// without sign-in" — they get a stable UID linked to this device so
  /// their data still has a key.  No password required.
  Future<AuthUser?> signInAnonymously() async {
    await init();
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = _userFromFirebase(userCredential.user);
      if (user != null) await _persist(user);
      return user;
    } catch (e) {
      debugPrint('anonymous sign-in: $e');
      return null;
    }
  }

  /// Hand-off: detach the local mirror and log out of Firebase.
  Future<void> signOut() async {
    if (kIsWeb) {
      debugPrint('[AuthService] Web preview — sign-out is a no-op.');
      return;
    }
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    _dispatch(null);
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
    await _firebaseSub?.cancel();
    _listeners.clear();
  }
}
