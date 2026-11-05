# Deutschy 🇩🇪 — Premium German Learning Super-App

**Deutschy** is a modern, full-featured German learning application built with **Flutter**, **Riverpod**, **Drift (SQLite)**, and **Google Gemini AI**. Designed for learners at **A1, A2, and B1** CEFR levels, Deutschy combines scientifically-backed spaced repetition (SM-2 SRS), interactive micro-games, AI-powered scenario dialogues, writing correction, and offline audio synthesis into a unified, visually stunning mobile app.

---

## ✨ Key Features

### 🧠 1. Spaced Repetition (SRS) Vocabulary Engine
- **SM-2 Algorithm Implementation**: Optimizes review intervals based on card recall difficulty.
- **SRS Analytics & Mastery Progress**: Real-time progress bar, retention curve, and categorization into *New*, *Learning*, and *Mastered* cards.
- **Instant Search & Filter**: Real-time search across English and German words across all CEFR decks.
- **Audio Speed Controls**: Adjustable TTS playback speed (`0.75x` slow learner mode, `1.0x` normal, `1.25x` fast).

### 🎮 2. Immersive Micro-Games
- **Memory Match**: 3D card flip animations powered by `Matrix4` perspective transforms. Find matching German ↔ English vocabulary pairs.
- **Word Chain Race**: 5-second rapid recall game with animated timer countdown ring and score multiplier bonuses.
- **Celebration Overlays**: Full-screen completion screens with dynamic particle confetti bursts (`ConfettiBurst`) and haptic feedback.

### 💬 3. AI Scenario Chat & Voice Practice
- **Multi-Turn Roleplay**: Practice real-world German scenarios (*At the Café*, *Train Station*, *Doctor's Visit*, *Job Interview*).
- **Zero-Cost Speech Processing**: Device-native STT (Speech-to-Text) + TTS (Text-to-Speech) for $0 API overhead and offline capability.
- **Gemini AI Integration**: Secure node proxy integration for conversational AI responses with graceful offline fallback.
- **Micro-Animations**: Mic pulse glow animations when listening and animated typing indicators (`OrbitRing`).

### ✍️ 4. AI Writing Corrector & Grammar Reference
- **Paragraph Feedback**: Write free-form German paragraphs and receive detailed inline corrections, grammar hints, and scores.
- **CEFR-Tiered Grammar Catalog**: Expandable lesson cards covering A1–B1 grammar rules with worked examples and interactive *"Verständnis-Check"* (understanding checks).

### 🎨 5. Premium UI/UX & Design System
- **Material 3 Tonal Palette**: Deep Cobalt, Warm Coral, and Mint Accent tailored HSL color system.
- **Micro-Animations**: `StaggerCascade` entry transitions, `PressScaleEffect` button tactility, and `GlossySurface` cards.
- **Responsive Layout**: Built-in tablet support with layout constraints (`maxWidth: 420-480dp`).
- **Complete Internationalization (i18n)**: Instant language switcher supporting **Deutsch**, **English**, **Français**, and **العربية (RTL)**.

---

## 🛠️ Architecture & Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3, Material 3) |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) |
| **Database & Persistence** | [Drift](https://drift.simonbinder.eu) (SQLite) + `SharedPreferences` |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) with ShellRoute & Auth Guard |
| **AI Integration** | Google Gemini API (via Node.js Proxy) |
| **Audio Engine** | Device Native STT (`speech_to_text`) & TTS (`flutter_tts`) |
| **Testing** | Flutter Test Framework (114/114 passing unit & E2E tests) |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.22 or newer)
- Android Studio / VS Code with Flutter extension
- An Android device or emulator (API 24+) / iOS Simulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/HamzaSbay/Deutschy.git
   cd Deutschy
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate SQLite Database code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**:
   ```bash
   # Run on connected Android device
   flutter run -d mobile

   # Run on Web (Edge / Chrome)
   flutter run -d edge
   ```

---

## 🧪 Testing

The repository features a test suite covering unit logic, SRS scheduling, games engines, UI heuristics, accessibility, and end-to-end user journeys.

Run the test suite:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

---

## 🌐 AI Proxy Backend (`proxy/`)

Deutschy uses a lightweight Node.js Express proxy located in `proxy/` to securely forward scenario prompts to the Google Gemini API without embedding secret API keys inside the client app.

### Deployment Options:
- **Docker**: `docker build -t deutschy-proxy ./proxy`
- **Render / Fly.io**: Pre-configured `proxy/render.yaml` and `proxy/fly.toml` files included.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
