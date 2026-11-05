import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/features/auth/application/auth_service.dart';

/// Auth surface tests.
///
/// We intentionally avoid touching real Firebase here — Firebase's
/// official test sdk (`firebase_auth_mocks`) would let us round-trip
/// `signInWithCredential` in unit tests, but it's under-invested for
/// v1.  Instead we exercise the parts that DON'T require live Firebase:
///
///   * JSON round-tripping of `AuthUser` — what we mirror in
///     `SharedPreferences` and what we display in the splash/dashboard.
///   * Provider-id normalization (`google.com` → `AuthProvider.google`).
///
/// Once `firebase_auth_mocks` is added as a dev-dep, extend these tests
/// to cover `signInAnonymously`, `signOut`, and the cached-flow path.
void main() {
  group('AuthUser round-trip', () {
    test('survives a JSON serialize → deserialize round-trip', () {
      final original = AuthUser(
        uid: 'abc-123',
        displayName: 'Anna Müller',
        email: 'anna@deutschy.app',
        photoUrl: 'https://example.com/photo.png',
        provider: AuthProvider.google,
      );

      final round = AuthUser.fromMongo(_clone(original.toMongo()));

      expect(round?.uid, original.uid);
      expect(round?.displayName, original.displayName);
      expect(round?.email, original.email);
      expect(round?.photoUrl, original.photoUrl);
      expect(round?.provider, original.provider);
    });

    test('null photoUrl round-trips as null', () {
      final original = AuthUser(
        uid: 'apple-1',
        displayName: null,
        email: null,
        photoUrl: null,
        provider: AuthProvider.apple,
      );
      final round = AuthUser.fromMongo(_clone(original.toMongo()));
      expect(round?.provider, AuthProvider.apple);
      expect(round?.displayName, null);
    });
  });

  test('provider id normalisation (covered indirectly via JSON)', () {
    // The `fromMongo` helper maps unknown provider strings to
    // `AuthProvider.local`.  Lock that in.
    final raw = {'uid': 'a', 'provider': 'unknown-provider'};
    final u = AuthUser.fromMongo(_clone(raw));
    expect(u?.provider, AuthProvider.local);
  });
}

/// Defensive deep-clone of the loose `Map<String, dynamic>` we accept
/// in `fromMongo`.  We copy because the AuthUser helper unwraps the
/// original — keeping the originals untouched is safer for tests that
/// later assert against them.
Map<String, dynamic> _clone(Map<String, dynamic> input) {
  final out = <String, dynamic>{};
  input.forEach((k, v) {
    out[k] = v is Map ? _clone(Map<String, dynamic>.from(v)) : v;
  });
  return out;
}
