import 'dart:convert';

import 'package:dio/dio.dart';

/// Reference to a generic JSON-like dictionary returned by the LLM
/// proxy (kept as plain `Map<String, dynamic>` so consumers can render
/// results without depending on a generated serializer).
typedef JsonMap = Map<String, dynamic>;

/// Model representing a target AI endpoint configured for fallback rotation.
class AiEndpoint {
  const AiEndpoint({
    required this.url,
    this.apiKey,
    this.modelName,
  });

  final String url;
  final String? apiKey;
  final String? modelName;
}

/// Side-effected handler that talks to whatever proxy or direct API is
/// configured at runtime, rotating through fallbacks on failure.
class GeminiClient {
  GeminiClient({
    required Dio dio,
    required this.endpoints,
  }) : _dio = dio;

  final Dio _dio;
  final List<AiEndpoint> endpoints;

  /// Last user-facing error message captured by [write], populated by
  /// [_post] so the UI can surface a friendly message without
  /// duplicating catch-handling at every call site.
  String? lastErrorMessage;

  Future<WritingFeedback> correctWriting({
    required String userText,
    required String level, // A1, A2, B1…
  }) async {
    final body = <String, Object?>{
      'action': 'writing_correction',
      'level': level,
      'text': userText,
    };
    final res = await _post(body);
    return WritingFeedback.fromJson(res);
  }

  /// Continue a multi-turn dialogue as part of a speaking scenario.  The
  /// proxy holds the system prompt for the scenario — we only forward
  /// the user's message and history.
  Future<String> continueSpeakingScenario({
    required int scenarioId,
    required List<String> history,
    required String userMessage,
    String? systemPrompt,
  }) async {
    final res = await _post(
      {
        'action': 'speaking_continue',
        'scenarioId': scenarioId,
        'history': history,
        'userMessage': userMessage,
      },
      systemPrompt: systemPrompt,
    );
    return (res['reply'] as String?) ?? '';
  }

  Future<JsonMap> _post(JsonMap proxyBody, {String? systemPrompt}) async {
    lastErrorMessage = null;
    Object? lastErr;

    for (var i = 0; i < endpoints.length; i++) {
      final ep = endpoints[i];
      final isDirectNvidia = ep.url.contains('nvidia.com');

      // Skip direct NVIDIA endpoints if no API key is supplied
      if (isDirectNvidia && (ep.apiKey == null || ep.apiKey!.isEmpty)) {
        continue;
      }

      try {
        final dynamic requestData;
        final Options options;

        if (isDirectNvidia) {
          // Translate standard proxy payload into OpenAI Chat format expected by NVIDIA
          requestData = _convertToOpenAiFormat(
            proxyBody,
            ep.modelName ?? 'meta/llama-3.1-70b-instruct',
            systemPrompt,
          );
          options = Options(
            headers: {
              'Authorization': 'Bearer ${ep.apiKey}',
            },
            contentType: 'application/json',
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          );
        } else {
          // Send standard proxy format
          requestData = jsonEncode(proxyBody);
          options = Options(
            contentType: 'application/json',
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 3),
          );
        }

        final res = await _dio.post(
          ep.url,
          data: requestData,
          options: options,
        );

        final data = res.data;
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          if (isDirectNvidia) {
            // Translate the OpenAI response format back into the proxy model layout
            return _parseOpenAiResponse(map, proxyBody['action'] as String);
          }
          return map;
        }
        throw const FormatException('AI proxy returned non-object response.');
      } catch (e) {
        lastErr = e;
        // ignore: avoid_print
        print('DEUTSCHY DEBUG: Endpoint failed: ${ep.url} (isNvidia: $isDirectNvidia), error: $e');
        if (e is DioException) {
          // ignore: avoid_print
          print('DEUTSCHY DEBUG: DioException details: ${e.response?.statusCode} - ${e.response?.data}');
        }
      }
    }

    // All endpoints failed
    lastErrorMessage = 'AI is offline. All endpoints failed. Last error: $lastErr';
    if (lastErr is DioException) {
      throw lastErr;
    }
    throw Exception(lastErrorMessage);
  }

  /// Formats the request body for standard OpenAI / NVIDIA API format
  JsonMap _convertToOpenAiFormat(JsonMap proxyBody, String model, String? systemPrompt) {
    final action = proxyBody['action'] as String;
    if (action == 'writing_correction') {
      final level = proxyBody['level'] as String;
      final text = proxyBody['text'] as String;
      return {
        "model": model,
        "messages": [
          {
            "role": "system",
            "content": "You are a professional German language coach. Correct the user's text for CEFR level $level. "
                "Provide overall feedback, a score out of 10, and a list of corrections for any incorrect sentences. "
                "Respond ONLY in a JSON object matching this schema exactly:\n"
                "{\n"
                "  \"overall_feedback\": \"Your general feedback summary\",\n"
                "  \"score_out_of_10\": 8,\n"
                "  \"corrections\": [\n"
                "    {\n"
                "      \"original\": \"The original wrong sentence\",\n"
                "      \"corrected\": \"The corrected sentence\",\n"
                "      \"explanation\": \"Short explanation of why it was wrong\",\n"
                "      \"error_type\": \"Grammar / Vocab / Spelling / Word Order\"\n"
                "    }\n"
                "  ]\n"
                "}"
          },
          {
            "role": "user",
            "content": text
          }
        ],
        "temperature": 0.2,
        "response_format": { "type": "json_object" }
      };
    } else if (action == 'speaking_continue') {
      final history = List<String>.from(proxyBody['history'] as List);
      final userMessage = proxyBody['userMessage'] as String;
      final sysPrompt = systemPrompt ?? "You are a German speaking assistant. Keep replies short (max 10 words).";

      return {
        "model": model,
        "messages": [
          {
            "role": "system",
            "content": sysPrompt
          },
          for (final msg in history)
            {
              "role": msg.startsWith('User:') ? 'user' : 'assistant',
              "content": msg.replaceFirst(RegExp(r'^(User|Barista|Receptionist|Doctor|Assistant): '), '')
            },
          {
            "role": "user",
            "content": userMessage
          }
        ],
        "temperature": 0.5
      };
    }
    return {};
  }

  /// Parses standard OpenAI chat completion JSON back to Deutschy's expected proxy map layout.
  JsonMap _parseOpenAiResponse(JsonMap response, String action) {
    try {
      final choices = response['choices'] as List;
      final first = choices.first as Map;
      final message = first['message'] as Map;
      final content = (message['content'] as String?) ?? '';

      if (action == 'writing_correction') {
        return Map<String, dynamic>.from(jsonDecode(content));
      } else if (action == 'speaking_continue') {
        return {'reply': content.trim()};
      }
    } catch (_) {
      // Return empty / default structure on parsing failure
    }
    return {};
  }
}

/// Strongly-typed wrapper around the writing-correction response.  Built
/// by parsing the LLM's structured JSON.
class WritingFeedback {
  WritingFeedback({
    required this.overallFeedback,
    required this.scoreOutOf10,
    required this.corrections,
  });

  factory WritingFeedback.fromJson(JsonMap json) {
    final raw = (json['corrections'] as List?) ?? const [];
    return WritingFeedback(
      overallFeedback: (json['overall_feedback'] as String?) ??
          (json['overallFeedback'] as String? ??
              'No overall feedback provided.'),
      corrections: raw
          .whereType<Map>()
          .map((c) => SentenceCorrection.fromJson(Map<String, dynamic>.from(c)))
          .toList(),
      scoreOutOf10: (json['score_out_of_10'] is num)
          ? (json['score_out_of_10'] as num).toInt()
          : ((json['scoreOutOf10'] is num)
              ? (json['scoreOutOf10'] as num).toInt()
              : 0),
    );
  }

  final String overallFeedback;
  final int scoreOutOf10;
  final List<SentenceCorrection> corrections;
}

class SentenceCorrection {
  SentenceCorrection({
    required this.original,
    required this.corrected,
    required this.explanation,
    required this.errorType,
  });

  factory SentenceCorrection.fromJson(JsonMap json) {
    return SentenceCorrection(
      original: (json['original'] as String?) ?? '',
      corrected: (json['corrected'] as String?) ?? '',
      explanation: (json['explanation'] as String?) ?? '',
      errorType: (json['error_type'] as String?) ??
          (json['errorType'] as String? ?? 'Other'),
    );
  }

  final String original;
  final String corrected;
  final String explanation;
  final String errorType;
}
