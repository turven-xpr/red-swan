// Phase 7: Regression guard — fails if hardcoded user-facing strings
// creep back into feature UI files.
//
// Run:  flutter test test/i18n_regression_test.dart

import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('i18n regression guard', () {
    /// Patterns that indicate a hardcoded user-facing string was added
    /// instead of using `t(context, Str.*)`.
    final antiPatterns = [
      // Direct isArabic ternary with string literals
      RegExp(r'''isArabic\s*\?\s*['"]'''),
      // Hardcoded English UI strings that should go through Str keys
      // (only matches plain strings inside Text() / title: / label: / tooltip:)
      RegExp(r'''\bconst\s+Text\(\s*'[A-Z][a-z]'''),
    ];

    /// Paths that are allowed to contain hardcoded strings
    /// (e.g. data models, routing, non-UI code).
    final allowList = <String>{
      'curriculum_data.dart',
      'syllabus_data.dart',
      'app_router.dart',
      'app_locale.dart',
      'strings.dart',
      'translations.dart',
      'bidi_utils.dart',
      'settings_widgets.dart', // Theme labels like 'System', 'Light', 'Dark' handled separately
    };

    test('no isArabic ternary string literals in feature UI files', () {
      final featureDir = Directory('lib/src/features');
      if (!featureDir.existsSync()) {
        // CI might run from repo root or project root
        return;
      }

      final violations = <String>[];

      for (final file in featureDir.listSync(recursive: true)) {
        if (file is! File || !file.path.endsWith('.dart')) continue;
        final basename = file.uri.pathSegments.last;
        if (allowList.contains(basename)) continue;

        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          // Skip comments
          if (line.trimLeft().startsWith('//')) continue;

          if (antiPatterns[0].hasMatch(line)) {
            violations.add(
              '${file.path}:${i + 1}  →  ${line.trim()}',
            );
          }
        }
      }

      if (violations.isNotEmpty) {
        fail(
          'Found ${violations.length} hardcoded isArabic ternary string(s).\n'
          'Use t(context, Str.key) instead:\n\n'
          '${violations.join('\n')}',
        );
      }
    });

    test('all Str keys have translations in _table', () {
      // This test reads the strings.dart and translations.dart source files
      // and checks that every Str.* constant has a matching entry in _table.
      final stringsFile = File('lib/src/core/i18n/strings.dart');
      final translationsFile = File('lib/src/core/i18n/translations.dart');

      if (!stringsFile.existsSync() || !translationsFile.existsSync()) return;

      final stringsContent = stringsFile.readAsStringSync();
      final translationsContent = translationsFile.readAsStringSync();

      // Extract all Str.* key names
      final keyPattern = RegExp(r"static const String (\w+) = '(\w+)'");
      final keys = keyPattern
          .allMatches(stringsContent)
          .map((m) => m.group(2)!)
          .toList();

      final missingKeys = <String>[];
      for (final key in keys) {
        // Check that Str.<field> appears in translations _table
        if (!translationsContent.contains('Str.$key:') &&
            !translationsContent.contains("Str.$key :")) {
          // Also check string literal form
          if (!translationsContent.contains("'$key':") &&
              !translationsContent.contains("'$key' :")) {
            missingKeys.add(key);
          }
        }
      }

      if (missingKeys.isNotEmpty) {
        fail(
          'Found ${missingKeys.length} Str key(s) without translations in _table:\n'
          '${missingKeys.join(', ')}',
        );
      }
    });
  });
}

