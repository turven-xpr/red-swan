# Deutschy — App Development Plan (curriculum-aligned, store-ready)

**Source-of-truth** for what ships next.  Backed by:
- `german_app_curriculum_plan.md` — CEFR A1→B2 curriculum (8 grammar + 8 vocab units per level, 5 core modules per level, 4 skills per level)
- `RESEARCH_A2_B1.md` — current in-app corpus
- Apple's App Store Review Guidelines (5.x), Google's Play Store policy (2026)

---

## 1. Curriculum Gap Analysis (current state vs target)

| Layer | Current in-app | Curriculum target | Gap |
|-------|----------------|-------------------|-----|
| **A1 cards** | 25 (cold-start in-memory) | ~500 (8 thematic units) | **−475** |
| **A1 grammar lessons** | 0 (none labelled A1) | 8 modules | **−8** |
| **A2 cards** | 84 (6 themes) | ~750 (8 themes × ~95) | **−666** |
| **A2 grammar lessons** | 0 | 8 modules | **−8** |
| **B1 cards** | 82 (7 themes) | ~1500 (10 themes × ~150) | **−1418** |
| **B1 grammar lessons** | 0 | 10 modules | **−10** |
| **B2 cards** | 0 | ~2500 (10 themes × ~250) | **−2500** |
| **B2 grammar lessons** | 0 | 8 modules | **−8** |
| **Listening drills** | 0 | per-level audio + transcripts | **−missing** |
| **Exam mock tests** | 0 | Goethe/telc-format exercises | **−missing** |

**Total active cards:** 191 → target 5250+. The DB schema already has nullable French/Arabic/Theme columns, so the schema won't need to migrate when bulk content lands.

---

## 2. Curriculum Delivery Plan (11 phases)

### Phase K1 — A1 mass content (2 weeks)
- 8 thematic units × ~62 cards = **~500 A1 cards**.
- 8 grammar lessons matching A1 modules (Sentence Structure, Articles & Gender, Nominative, Präsens, Accusative, Modals, Negation, Prepositions).
- Quiz/exercise scaffold (fill-in, multiple choice, sentence reorder) can re-use the same `Flashcard` model with a `type` column.

### Phase K2 — Close A2 gaps
- 2 missing themes: **Culture & Free Time**, **Weather & Nature** (~168 new cards).
- Add 8 A2 grammar lessons.

### Phase K3 — Close B1 gaps
- 3 missing themes: **Society & Politics**, **Feelings & Relationships**, **Culture & Events** (~450 new cards).
- 10 B1 grammar lessons.

### Phase K4 — B2 launch
- All 10 B2 thematic units, ~2500 cards.
- 8 B2 grammar lessons (Konjunktiv II advanced, full passive system, Funktionsverbgefüge, Nominalization, participial attributes, full connector range, genitive prepositions, discourse cohesion).

### Phase K5 — Listening (assets-heavy)
- Native-speaker recordings per word + per example sentence.
- Listening dictation drills per level (type what you hear, scored by `speech_to_text`).

### Phase K6 — Reading library
- A1/A2: 30 short texts (announcements, menus, signs).
- B1/B2: 30 newspaper articles / opinion pieces / graded readers.
- Each text with comprehension questions + vocab unlock.

### Phase K7 — Practice gap (writing templates & role-play scripts)
- Writing tasks per level: postcard → 50-word email → 80-word essay → 250-word Erörterung.
- Speaking scenarios per level: 5 beginner, 10 intermediate, 10 upper-intermediate.

### Phase K8 — Adaptive feedback
- Per-skill dashboard cards (speaking/writing/grammar/vocab/listening/reading).
- Auto-pick which session to run on launch (weakest skill weighted).

### Phase K9 — Mock Tests
- Goethe / telc-style mock test per CEFR level.
- Timed modules, per-skill scoring, pass/fail feedback.

### Phase K10 — Community (optional, server-required)
- Pair-matching for oral practice.
- Writing exchange / correction.
- Requires backend (out of scope of $0 architecture — defer).

### Phase K11 — Web/Synonym search
- In-app glossary (DE→EN/FR/AR).
- Search across all corpus.

---

## 3. Store-Readiness Audit (parallel track)

### 3.1 Apple App Store (`ios/`)

| Requirement | Status | Action |
|-------------|--------|--------|
| **Privacy nutrition labels** | Missing | Add `NSPrivacyAccessedAPITypes` to Info.plist for: UserDefaults (CA92.1), File timestamp (C617.1), Disk space (CA92.1) — used by SharedPreferences/file IO. |
| **Privacy manifest** | Missing | Add `PrivacyInfo.xcprivacy` declaring per-API category. |
| **App Tracking Transparency** | N/A (no SDK tracking) | Verify no IDFA usage in any dep. |
| **Sign-in with Apple** (when third-party login offered) | Required since we offer Google sign-in | Done in P0.3 — confirm entitlement + capability. |
| **Push notifications** | Declared but not used (P1.8) | OK; declare only if notification permission is requested at runtime, which we already do via `requestPermissions()`. |
| **App icon (1024×1024)** | Replace `AppIcon.appiconset` with Polish M3-branded variant | Design task. |
| **Launch screen** | Default white | Add branded launch image (logo + tagline). |
| **iOS minimum version** | Check | Should be iOS 13+ (covers 95%+ of devices). |
| **Privacy policy URL** | Missing | Required for any authenticated app. Host on GitHub Pages or own a URL. |
| **Support URL** | Missing | Same as above. |
| **App description / keywords** | Missing | Must declare before submission. |
| **App Store Connect signing** | Pending | Apple Developer Program membership ($99/yr). |
| **Archive build** | Pending | `flutter build ipa --release` and verify archive is sub-100 MB. |
| **TestFlight beta** | Pending | Required 1-2 weeks minimum before release. |
| **Crashlytics / Sentry** | Optional but recommended | Defer to v1.1. |

### 3.2 Google Play Store (`android/`)

| Requirement | Status | Action |
|-------------|--------|--------|
| **Target SDK 34+ (Android 14)** | Verify | `flutter.compileSdkVersion` and `targetSdkVersion` in `build.gradle`. Min 21 (Android 5). |
| **Privacy policy URL** | Missing | Same as iOS — must be hosted. |
| **Data safety form** | Missing | Required: declare that we collect email (auth) + TEXT/IMAGE/VIDEO via user-picked avatar (gallery/camera). No data sold. No data shared. |
| **App icon (512×512)** | Default | Replace with brand icon. |
| **Feature graphic (1024×500)** | Missing | For Play Store listing. |
| **Screenshots (phone, 7-inch, 10-inch)** | Missing | Required for listing. |
| **Short description (≤80 chars)** | Missing | Marketing. |
| **Full description (≤4000 chars)** | Missing | Marketing. |
| **Play Console account** | Pending | $25 one-time fee. |
| **Internal testing track → Closed → Production** | Pending | Gradual rollout. |
| **Content rating (IARC)** | Pending | Self-apply via questionnaire. |
| **Target audience & content (children/adult)** | Pending | Declare adult — no child-directed content. |
| **App bundle (AAB)** | Pending | `flutter build appbundle --release`. |
| **Keystore signing** | Done in P0.4 | Confirm process_doc.md and upload key. |
| **`applicationId` finalised** | `com.deutschy.app` | Looks good — verify not already claimed on Play. |
| **Version code/name policy** | 1.1.0 → 1.0.0 +1 for first release | Bump to 1.0.0. |
| **64-bit requirement (Aug 2019)** | Native libs by default | Verify bundled abiFilters. |
| **Deobfuscation proguard file** | Pending | Optional; useful for crash reports. |
| **Android App Bundle > APK delivery** | Use AAB | Required since Aug 2021. |

### 3.3 Cross-platform hygiene

| Requirement | Status | Action |
|-------------|--------|--------|
| **`flutter analyze` returns 0 issues** | ✅ Green | Keep clean. |
| **Release-mode flutter test** | ✅ 40/40 pass | Keep clean. |
| **`flutter build apk --release --target-platform=android-x64`** | Untested | Must compile in release. Run before submission. |
| **Release-mode runtime smoke test** | Pending | Add an integration_test/<...>_e2e_test.dart that exercises onboarding → SRS review. |
| **Asset shrinking** | Default | Verify with `flutter build apk --analyze-size`. |
| **ProGuard / R8** | Pending for release | `minifyEnabled true` + `shrinkResources true` in release buildType for Android size savings. |
| **Skill-arch consistency** | ✅ | Premium animations, M3 theme, all features localised en/fr/ar/de. |
| **Cold-start TTI < 200ms** | ✅ | In-memory seed gives sub-200ms first paint. |
| **API key never embedded** | ✅ | GEMINI_API_KEY kept in `proxy/.env`. |
| **`$0 running cost`** | ✅ | Native TTS/STT + low-cost Gemini. |

---

## 4. Revenue / Monetisation Readiness

We already have `google_mobile_ads` wired with `MediationExtrasAdManager`. To publish:

- Replace AdMob **test unit IDs** in `app_config.dart` with **real unit IDs** linked to a verified AdMob console.
- Configure consent dialogs per GDPR/CCPA (UK + EU + California users).
- Optionally hook up Play Billing / StoreKit for a subscription tier (Pro).

---

## 5. Proposed Next-Sprint Picks (after this plan review)

Lead with content + store hygiene in parallel:

1. **A1 mass corpus** (~500 cards + 8 grammar lessons) — Phase K1
2. **Privacy policy + terms** — published on GitHub Pages
3. **Privacy nutrition labels / Data safety form** — required for both stores
4. **Branded icon + launch screen**
5. **Real AdMob unit IDs** before first release
6. **`flutter build appbundle --release`** smoke test
7. **Privacy manifest** for iOS

Tell me which slice to execute and I'll whack through to a green build.