# Deutschy — German Learning App: Mobile-Only Free-Tier Implementation Plan

> **Goal:** Build **Deutschy**, a free, ad-supported German language learning mobile application (iOS + Android) using Flutter, configured for **$0 server & AI costs** using a hybrid of free-tier cloud AI and native on-device capabilities.
>
> **Architecture:** A mobile-first, clean-architecture, offline-first application. Uses Riverpod for state management, Isar for local database, Firebase or Supabase Auth for Google & Apple Sign-In, and AdMob for monetization.
>
> **Tech Stack:** Flutter, Riverpod, GoRouter, Isar, Firebase Auth, Google Mobile Ads (AdMob), Gemini API (Free Tier), Native Speech-to-Text (Apple/Google), Native Text-to-Speech (Apple/Google).

---

## 1. Zero-Cost Hybrid AI Engine Blueprint

To run the application with **$0 initial operating costs** while keeping the app size small (under 40MB) and performance high across all low-end and high-end devices, we will implement a **Hybrid AI Strategy**:

```
                       ┌───────────────────────────────┐
                       │    FLUTTER CLIENT APP (0MB)   │
                       └───────────────┬───────────────┘
                                       │
        ┌──────────────────────────────┼──────────────────────────────┐
        ▼                              ▼                              ▼
┌───────────────┐              ┌───────────────┐              ┌───────────────┐
│  LOCAL AUDIO  │              │  LOCAL AUDIO  │              │  CLOUD CORE   │
│ TEXT-TO-SPEECH│              │SPEECH-TO-TEXT │              │  LLM BRAIN    │
│ (flutter_tts) │              │(speech_to_text│              │ (Gemini API)  │
│               │              │   package)    │              │               │
├───────────────┤              ├───────────────┤              ├───────────────┤
│ • Uses phone's│              │ • Uses system │              │ • Prompts for │
│   built-in    │              │   native STT  │              │   writing and │
│   German system   │              │   engine      │              │   speaking    │
│ • 100% Free   │              │ • 100% Free   │              │ • Free Tier   │
│ • Offline     │              │ • Offline     │              │   (15k req/d) │
└───────────────┘              └───────────────┘              └───────────────┘
```

### A. Local AI Capabilities (Why they work on mobile for $0)
1. **Text-to-Speech (TTS):** We use Flutter's `flutter_tts` package. This taps directly into Apple's AVFoundation on iOS and Google's TextToSpeech Engine on Android. It leverages high-quality German system voices pre-installed on the device. **Cost: $0. App Size Overhead: 0MB.**
2. **Speech-to-Text (STT):** We use the `speech_to_text` package. This leverages Apple's `SFSpeechRecognizer` and Android's native Voice Recognizer. This is highly accurate, fast, handles microphone permissions natively, and transcribes voice input in real-time. **Cost: $0. App Size Overhead: 0MB.**

### B. Why On-Device LLMs (Local Offline LLMs) are NOT Recommended
While we *can* technically run a 2B-parameter LLM (like Gemma or Llama-3-2B) locally on-device using frameworks like MediaPipe or llama.cpp, it creates serious issues:
- **Massive App Size:** Installs increase by **1.5GB to 2.5GB** just to download the model file.
- **Battery & Thermal Drain:** Processing text models locally gets the phone hot and drains battery in minutes.
- **RAM Crashes:** Budget Android devices with 3GB–4GB of RAM will frequently crash.
- **Slower/Worse Quality:** Local mini-models struggle with correct German declensions and smart contextual feedback.

### C. The Golden Solution: Google Gemini API Free Tier
Google offers an incredibly generous **Free Tier for Gemini 2.5 Flash**:
- **Usage Limits:** Up to 15 Requests Per Minute (RPM), and **15,000 Requests Per Day (RPD)**.
- **Cost:** **$0** (no billing card required to start).
- **Quality:** High-level AI model capable of complex grammar checking, conversational German scenarios, and level adaptation (A1, A2, B1).
- **Implementation:** To prevent users from sniffing and stealing your API key, we will secure it with a simple Cloud Function (Firebase/Supabase edge function), or a simple backend.

---

## 2. Updated Core Feature Set

1. **Spaced Repetition Flashcards (SRS):** Off-line vocabulary decks stored in Isar DB. Uses the SuperMemo-2 algorithm.
2. **AI Speaking Practice:** Dialogue simulation (e.g., *Im Café*, *Im Hotel*).
   - User speaks into microphone -> Native System STT transcribes to text -> Sent to Gemini -> Gemini replies in German -> Native System TTS speaks reply out loud.
3. **AI Writing Room:** Instant writing corrections.
   - User writes a paragraph -> Sent to Gemini -> Gemini returns exact structured JSON detailing spelling errors, word order fixes, and explains the rule in English.
4. **Ad-Supported Mechanics:**
   - **Banner Ads:** Placed discreetly at the bottom of the Dashboard page.
   - **Interstitial Ads:** Placed after completing a complete review session of 15 flashcards.
   - **Rewarded Video Ads (Optional):** Watch a video to unlock premium AI writing prompt packs or custom scenarios.

---

## 3. Tech Stack Selection for $0 Cost Operations

- **State Management:** `flutter_riverpod` (reactive data bindings).
- **Database (Offline):** `isar` (completely free, high performance embedded DB).
- **Backend BaaS (Backend-as-a-Service):** **Supabase (Free Tier)** or **Firebase (Spark Free Tier)**. Both offer:
  - Free Authentication (Google and Apple social logins).
  - Free database tier (Supabase gives a free Postgres DB; Firebase gives free Firestore database).
  - Free Cloud Functions (Supabase Edge Functions / Firebase Cloud Functions) to securely make Gemini API requests.
- **Ad Network:** `google_mobile_ads` (AdMob) — stable, easy to integrate, high fill rate on iOS and Android.

---

## 4. Phase-by-Phase Mobile Implementation Plan

### Phase 1: Core App Shell & Monetization Setup

#### Task 1: Flutter Project Initializer
- **Objective:** Establish the foundation with clean directory structures and native mobile setups.
- **Files to Modify/Create:**
  - `pubspec.yaml` (dependencies: `flutter_riverpod`, `go_router`, `isar`, `isar_flutter_libs`, `google_mobile_ads`, `google_sign_in`, `sign_in_with_apple`, `flutter_tts`, `speech_to_text`, `dio`, dev_dependencies: `riverpod_generator`, `isar_generator`, `build_runner`)
  - `ios/Runner/Info.plist` (Configure AdMob `GADApplicationIdentifier`, microphone/speech permissions: `NSSpeechRecognitionUsageDescription`, `NSMicrophoneUsageDescription`)
  - `android/app/build.gradle` (Min SDK set to 21, enable multidex if needed)

#### Task 2: Google AdMob Integration
- **Objective:** Initialize AdMob on app launch and create reusable interstitial ad controllers.
- **Files to Create:**
  - `lib/src/features/monetization/ad_service.dart` (Riverpod provider managing interstitial and rewarded ad loading states)

---

### Phase 2: Secure Social Authentication (Google & Apple)

#### Task 3: Firebase/Supabase Auth Guard Setup
- **Objective:** Configure social authentication and route guards.
- **Files to Create:**
  - `lib/src/features/auth/presentation/login_screen.dart` (An elegant card-based screen with native-looking "Sign in with Google" and "Sign in with Apple" buttons)
  - `lib/src/routing/app_router.dart` (Redirects to `/login` if authentication provider is null)

---

### Phase 3: Zero-Cost Speech & Audio Engine (STT & TTS)

#### Task 4: Native Text-to-Speech Engine
- **Objective:** Initialize `flutter_tts` configured for German (`de-DE`).
- **Files to Create:**
  - `lib/src/features/audio/tts_service.dart`:
  ```dart
  import 'package:flutter_tts/flutter_tts.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class TTSService {
    final FlutterTts _tts = FlutterTts();

    Future<void> init() async {
      await _tts.setLanguage("de-DE");
      await _tts.setSpeechRate(0.45); // Slower speech rate for language learners
      await _tts.setVolume(1.0);
    }

    Future<void> speak(String text) async {
      await _tts.speak(text);
    }

    Future<void> stop() async {
      await _tts.stop();
    }
  }

  final ttsServiceProvider = Provider((ref) => TTSService());
  ```

#### Task 5: Native Speech-to-Text Recorder
- **Objective:** Implement real-time voice-to-text recording.
- **Files to Create:**
  - `lib/src/features/audio/stt_service.dart` (Wrapper around `speech_to_text` managing speech-listening permissions, volume thresholds, and returning voice results as text strings)

---

### Phase 4: AI Brain Integrations (Grammar & Scenarios via Gemini Free Tier)

#### Task 6: Secure Edge Function (Firebase Cloud Function / Supabase Edge)
- **Objective:** Bridge Gemini queries securely so users cannot read your Google API key.
- **Files to Create:**
  - `supabase/functions/gemini-proxy/index.ts` (Javascript/TypeScript code that accepts user inputs, attaches your secret `GEMINI_API_KEY`, calls Google's endpoints, and returns clean response payloads)

#### Task 7: AI Writing Correction Engine
- **Objective:** Design the prompt template and the parsing UI for grammar reviews.
- **Prompt Sent to Gemini:**
  ```text
  You are an expert German language tutor. Analyze the following user text (German level A1-B1). 
  Analyze spelling, verb endings, and word order (Verb-second V2, TeKaMoLo, etc.). 
  Return a strict JSON format matching this schema:
  {
    "overall_feedback": "Short encouraging review",
    "corrections": [
       {"original": "incorrect sentence", "corrected": "corrected sentence", "explanation": "Grammar rule explanation in English"}
    ]
  }
  User Text: [USER_INPUT]
  ```
- **Files to Create:**
  - `lib/src/features/writing/presentation/writing_feedback_screen.dart` (Dynamic layout showing corrections with red cross strikes for errors and green check marks for corrections)

---

### Phase 5: Vocabulary (Isar SRS) & Engagement Layout

#### Task 8: Local Isar DB & Offline Spaced Repetition (SM-2)
- **Objective:** Core vocabulary learning loop. No server needed to study.
- **Files to Create:**
  - `lib/src/features/vocabulary/application/srs_service.dart` (Executes math logic to increment flashcard reviews based on difficulty)

#### Task 9: Ad Interstitial Integration on Lesson Completion
- **Objective:** Show a standard interstitial ad to the user once they finish reviewing a card set (to monetize the traffic).
- **Files to Modify:**
  - `lib/src/features/vocabulary/presentation/vocab_review_screen.dart` (Triggers `AdService.showInterstitialAd()` on the last review card)

---

## 5. Verification & Testing

- [ ] **Android Setup:** Open the emulator, configure your AdMob test unit IDs.
- [ ] **iOS Setup:** Run `pod install` in the `ios` directory, verify that audio & microphone permissions appear correctly in Xcode.
- [ ] **Authentication Check:** Complete a mock sign-in with Google/Apple to confirm your Firebase/Supabase credentials.
- [ ] **AI Endpoint Check:** Trigger an inline writing correction, check that the Gemini proxy returns clean JSON, and verify that the Flutter text engine correctly highlights spelling issues.
- [ ] **Audio Test:** Speak German into your phone to check if STT recognizes the words, and click speaker icons to confirm the native German TTS plays cleanly.
