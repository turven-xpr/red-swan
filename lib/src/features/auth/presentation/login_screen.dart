import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/providers.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../application/auth_service.dart';
import '../../../core/widgets/animations/premium_animations.dart';

/// The first thing every user sees.  Three affordances:
/// Mit Google anmelden, Mit Apple anmelden — third option "Ohne Konto"
/// is shown once we wire anonymous Firebase sign-in.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _busyGoogle = false;
  bool _busyApple = false;
  bool _busyAnon = false;
  String? _error;

  Future<void> _signIn(Future<AuthUser?> Function() fn, void Function(bool) busy) async {
    setState(() {
      _error = null;
    });
    busy(true);
    try {
      final user = await fn();
      if (!mounted) return;
      if (user == null) {
        setState(() => _error = 'Sign in was canceled.');
      } else {
        ref.invalidate(currentUserProvider);
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      busy(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  StaggerCascade(
                    children: [
                      Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: const Image(
                              image: AssetImage('assets/brand/logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Deutschy',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t(context, Str.loginTagline),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  StaggerCascade(
                    children: [
                      // Primary action — M3 idiom: FilledButton (high emphasis).
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          icon: Image.asset(
                            'assets/brand/google_logo.png',
                            width: 22,
                            height: 22,
                          ),
                          label: Text(_busyGoogle
                              ? t(context, Str.loginOpening)
                              : t(context, Str.loginWithGoogle)),
                          onPressed: _busyGoogle
                              ? null
                              : () => _signIn(
                                    () => ref.read(authServiceProvider).signInWithGoogle(),
                                    (b) => setState(() => _busyGoogle = b),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Second-tier: with the official Apple-supplied button
                      // (`sign_in_with_apple` package) so the visual matches
                      // Apple HIG and the user gets the proper branded glyph.
                      SizedBox(
                        height: 52,
                        child: _busyApple
                            ? const Center(
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2.4)),
                              )
                            : SignInWithAppleButton(
                                onPressed: () => _signIn(
                                  () => ref.read(authServiceProvider).signInWithApple(),
                                  (b) => setState(() => _busyApple = b),
                                ),
                                text: t(context, Str.loginWithApple),
                                style: SignInWithAppleButtonStyle.black,
                              ),
                      ),
                      const SizedBox(height: 14),
                      // Third option: anonymous sign-in (no personal data
                      // collected until the user explicitly creates an account).
                      // Apple App Store review *requires* this fallback when
                      // another social provider is offered.
                      TextButton.icon(
                        onPressed: _busyAnon || _busyGoogle || _busyApple
                            ? null
                            : () => _signIn(
                                  () => ref
                                      .read(authServiceProvider)
                                      .signInAnonymously(),
                                  (b) => setState(() => _busyAnon = b),
                                ),
                        icon: _busyAnon
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.4),
                              )
                            : const Icon(Icons.person_outline),
                        label: Text(t(context, Str.loginGuest)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t(context, Str.loginAccept),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
