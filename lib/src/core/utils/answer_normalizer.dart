/// Normalization and sanitization utility for language evaluation, BiDi hygiene,
/// and forgiving keyboard input handling across German, English, and Arabic.
class AnswerNormalizer {
  AnswerNormalizer._();

  static final RegExp _bidiMarks = RegExp(r'[\u2066\u2067\u2068\u2069\u200E\u200F\u061C]');
  static final RegExp _punctuation = RegExp(r"[.,!?:;\u201C\u201D\u2018\u2019`_()/{}<>\[\]\-]");

  /// Strips all Unicode directional formatting marks (essential before DB queries, TTS, or STT).
  static String cleanBiDi(String input) {
    return input.replaceAll(_bidiMarks, '').trim();
  }

  /// Wraps LTR text for display inside RTL contexts.
  static String wrapLtr(String input) {
    return '\u2066$input\u2069';
  }

  /// Normalizes input for answer comparison:
  /// - Strips BiDi isolate formatting
  /// - Lowercases
  /// - Strips trailing/leading punctuation
  /// - Normalizes German keyboard variants (ä->ae, ö->oe, ü->ue, ß->ss)
  /// - Collapses multiple spaces
  static String normalize(String input) {
    var text = cleanBiDi(input);
    text = text.replaceAll(_punctuation, ' ').toLowerCase();

    // Map German umlauts and eszett for forgiving mobile typing
    text = text
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('ß', 'ss');

    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Evaluates learner tiles or typed text against canonical answer.
  static bool isMatch(String learnerInput, String canonicalAnswer) {
    return normalize(learnerInput) == normalize(canonicalAnswer);
  }

  /// Computes Levenshtein similarity between 0.0 (completely different) and 1.0 (identical)
  /// using normalized representations.
  static double similarity(String s1, String s2) {
    final a = normalize(s1);
    final b = normalize(s2);
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final maxLen = a.length > b.length ? a.length : b.length;
    final dist = _levenshteinDistance(a, b);
    return (1.0 - (dist / maxLen)).clamp(0.0, 1.0);
  }

  static int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    var v0 = List<int>.generate(n + 1, (i) => i);
    var v1 = List<int>.filled(n + 1, 0);

    for (var i = 0; i < m; i++) {
      v1[0] = i + 1;
      for (var j = 0; j < n; j++) {
        final cost = s1[i] == s2[j] ? 0 : 1;
        final deletion = v0[j + 1] + 1;
        final insertion = v1[j] + 1;
        final substitution = v0[j] + cost;
        var minVal = deletion < insertion ? deletion : insertion;
        if (substitution < minVal) minVal = substitution;
        v1[j + 1] = minVal;
      }
      for (var j = 0; j <= n; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[n];
  }
}

