import 'package:flutter/material.dart';

/// Brand palette extension. Bold & modern aesthetic: Pure White,
/// Deep Black, and Vibrant Orange (#FF9100).
class AppColors {
  AppColors._();
  static const Color primary = Color(0xFFFF9100); // vibrant orange #FF9100
  static const Color primaryDark = Color(0xFFE08100); // deeper orange tone
  static const Color primaryLight = Color(0xFFFFA726); // light amber orange
  static const Color secondary = Color(0xFF121214); // rich deep black
  static const Color tertiary = Color(0xFF2C2C32); // graphite charcoal
  static const Color surfaceLight = Color(0xFFFFFFFF); // crisp white
  static const Color surfaceLightAlt = Color(0xFFF6F6F9); // light neutral surface
  static const Color surfaceDark = Color(0xFF0C0C0E); // pure obsidian black
  static const Color surfaceDarkAlt = Color(0xFF16161A); // dark elevated surface
  static const Color bodyLight = Color(0xFF101012); // black text
  static const Color bodyDark = Color(0xFFF7F7FA); // white text
}

/// Decoupled `AppTheme` — Material 3 enabled, brand-tonal palette via
/// `ColorScheme.fromSeed`, generous rounded radii on every interactive
/// surface to ship a "premium" feel.
class AppTheme {
  AppTheme._();

  static ThemeData? _lightTheme;
  static ThemeData? _darkTheme;

  static ThemeData light() {
    return _lightTheme ??= _buildLight();
  }

  static ThemeData dark() {
    return _darkTheme ??= _buildDark();
  }

  static ThemeData _buildLight() {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surfaceLight,
      surfaceContainerLowest: AppColors.surfaceLight,
      surfaceContainerLow: AppColors.surfaceLight,
      surfaceContainer: AppColors.surfaceLightAlt,
      surfaceContainerHigh: AppColors.surfaceLightAlt,
      surfaceContainerHighest: AppColors.surfaceLightAlt,
      onSurface: AppColors.bodyLight,
    );
    return _build(cs, Brightness.light);
  }

  static ThemeData _buildDark() {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: const Color(0xFFD4D4D8),
      tertiary: AppColors.primaryLight,
      surface: AppColors.surfaceDark,
      surfaceContainerLowest: AppColors.surfaceDark,
      surfaceContainerLow: AppColors.surfaceDark,
      surfaceContainer: AppColors.surfaceDarkAlt,
      surfaceContainerHigh: AppColors.surfaceDarkAlt,
      surfaceContainerHighest: const Color(0xFF24242A),
      onSurface: AppColors.bodyDark,
    );
    return _build(cs, Brightness.dark);
  }

  static ThemeData _build(ColorScheme cs, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
          elevation: 0,
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: cs.outlineVariant, width: 1.2),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
          foregroundColor: cs.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        color: cs.surfaceContainerHigh,
        surfaceTintColor: cs.surfaceTint,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        elevation: 0,
        height: 76,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? cs.primary : cs.onSurfaceVariant,
            size: 26,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? cs.primary : cs.onSurfaceVariant,
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.2,
          );
        }),
        indicatorColor: cs.secondaryContainer,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.secondary,
        foregroundColor: cs.onSecondary,
        elevation: 4,
        extendedTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 0.6,
        space: 24,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        iconColor: cs.primary,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 13.5,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isLight ? const Color(0xFF1A1A22) : cs.surface,
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : cs.onSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ModernPageTransitionsBuilder(),
          TargetPlatform.iOS: ModernPageTransitionsBuilder(),
          TargetPlatform.macOS: ModernPageTransitionsBuilder(),
          TargetPlatform.windows: ModernPageTransitionsBuilder(),
          TargetPlatform.linux: ModernPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ModernPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class ModernPageTransitionsBuilder extends PageTransitionsBuilder {
  const ModernPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slide = Tween<Offset>(
      begin: const Offset(0.08, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    final fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}
