// Deutschy → Gemini proxy.
//
// Why this exists:
// - The Flutter mobile app must never embed the Gemini API key.
// - This server holds GEMINI_API_KEY in its environment, exposes
//   a single JSON POST /ai endpoint to the app, and forwards the
//   request to Google Gemini 2.5 Flash (free tier).
//
// Free tier limits we respect:
//   * 15 requests / minute
//   * 1500 requests / day
//
// Run:    GEMINI_API_KEY=xxx npm start
// Test:   curl http://localhost:3000/healthz

import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { z } from 'zod';
import process from 'node:process';

// ─────────────────────────────────────────────────────────────────────
// Input validation (zod)
//
// Each `action` below describes one feature in the Deutschy app:
//   - writing_correction : turn-based grammar feedback on a user essay.
//   - speaking_continue  : chat-style reply inside a level-A1/A2 scenario.
//
// Anything else → 400.
// ─────────────────────────────────────────────────────────────────────

const WritingCorrection = z.object({
  action: z.literal('writing_correction'),
  text: z.string().min(1).max(8000),
  level: z.enum(['A1', 'A2', 'B1', 'B2', 'C1', 'C2']).optional(),
});

const HistoryItem = z.string().min(1).max(500);

const SpeakingContinue = z.object({
  action: z.literal('speaking_continue'),
  scenarioId: z.union([z.literal(1), z.literal(2), z.literal(3), z.literal(4)]),
  userMessage: z.string().min(1).max(500),
  history: z.array(HistoryItem).max(40).optional(),
});

const AiBody = z.discriminatedUnion('action', [WritingCorrection, SpeakingContinue]);

// ─────────────────────────────────────────────────────────────────────
// Env / config
// ─────────────────────────────────────────────────────────────────────

const PORT = Number(process.env.PORT) || 3000;
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS ||
  'http://localhost:8080,http://localhost:3000')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  console.error('FATAL: GEMINI_API_KEY env var is required — copy .env.example to .env and fill it in.');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(apiKey);
const model = genAI.getGenerativeModel({
  model: 'gemini-2.5-flash',
  generationConfig: {
    responseMimeType: 'application/json',
    temperature: 0.4,
  },
});

// ─────────────────────────────────────────────────────────────────────
// HTTP server
// ─────────────────────────────────────────────────────────────────────

const app = express();
app.use(cors({ origin: ALLOWED_ORIGINS.length ? ALLOWED_ORIGINS : true }));
app.use(express.json({ limit: '64kb' }));
app.use(morgan('tiny'));

// Health endpoint — used by Fly / Render to know we're alive.
app.get('/healthz', (_req, res) => res.json({ ok: true }));

// Structured log line.  Every request gets one of these.
function logEvent(fields) {
  console.log(JSON.stringify({ at: new Date().toISOString(), ...fields }));
}

// ─────────────────────────────────────────────────────────────────────
// /ai endpoint — single JSON surface for the Flutter app.
// ─────────────────────────────────────────────────────────────────────

app.post('/ai', async (req, res) => {
  const t0 = Date.now();
  const ip = req.headers['x-forwarded-for']?.toString().split(',')[0].trim()
    || req.socket.remoteAddress
    || 'unknown';
  const action = req.body?.action;

  // Validate envelope + per-action payload.
  const parsed = AiBody.safeParse(req.body);
  if (!parsed.success) {
    logEvent({ ip, action, ok: false, status: 400, ms: Date.now() - t0, reason: 'invalid_input' });
    return res.status(400).json({
      error: 'invalid_input',
      message: parsed.error.issues[0]?.message || 'request body did not match schema',
    });
  }
  const body = parsed.data;

  try {
    let out;
    if (body.action === 'writing_correction') {
      const prompt = buildWritingPrompt(body.text, body.level || 'A1');
      out = await callGemini(prompt, true);
    } else {
      // speaking_continue
      out = await callSpeakingContinue({
        scenarioId: body.scenarioId,
        history: body.history || [],
        userMessage: body.userMessage,
      });
    }

    logEvent({ ip, action: body.action, ok: true, status: 200, ms: Date.now() - t0 });
    return res.status(200).json(out);
  } catch (e) {
    const msg = e?.message || String(e);
    console.error('AI upstream error:', msg);
    logEvent({
      ip,
      action: body.action,
      ok: false,
      status: 502,
      ms: Date.now() - t0,
      reason: 'upstream_failed',
      upstream: msg.slice(0, 200),
    });
    return res.status(502).json({ error: 'AI upstream failed' });
  }
});

// 404 for everything else
app.use((req, res) => {
  res.status(404).json({ error: 'not_found', message: `${req.method} ${req.path}` });
});

// Last-resort safety net so the server never crashes the deployment.
app.use((err, req, res, _next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'server_error', message: 'unexpected server error' });
});

// ─────────────────────────────────────────────────────────────────────
// Prompt builders
// ─────────────────────────────────────────────────────────────────────

const writingSchema = `{
  "score_out_of_10": <integer 0..10>,
  "overall_feedback": <single short sentence>,
  "corrections": [
    {
      "original": <exact user sentence>,
      "corrected": <corrected version>,
      "explanation": <1-2 sentences rule explanation in English>,
      "error_type": "Spelling" | "Grammar" | "Word Order" | "Vocabulary" | "Punctuation"
    }
  ]
}`;

function buildWritingPrompt(userText, level) {
  return `You are an expert German language tutor. The student is at CEFR level ${level}.
Strictly grade the following writing for spelling, verb conjugation, articles, word order (V2, TeKaMoLo), and case agreement.

Return ONLY a JSON object matching this schema:
${writingSchema}

Rules:
- "score_out_of_10" reflects grammatical correctness at level ${level}, NOT creativity.
- "overall_feedback" is one short encouraging English sentence.
- "corrections" may be empty if the text is flawless.
- "explanation" must be in English and only one or two short sentences.
- Do not suggest stylistic rewrites of correct sentences.

<student_text>
${userText}
</student_text>`;
}

const SCENARIOS = {
  1: {
    title: 'Im Café',
    level: 'A1',
    systemPrompt:
      'You are a friendly Berlin barista. Keep replies in German at level A1. ' +
      'Very short sentences (max 8 words). Ask one follow-up question. Never correct grammar.',
    opening: 'Hallo! Was darf es sein?',
  },
  2: {
    title: 'Im Hotel',
    level: 'A2',
    systemPrompt:
      'You are a Munich hotel receptionist. Reply in German at level A2 (max 12 words). ' +
      'Polite, professional. Ask one follow-up.',
    opening: 'Guten Abend! Herzlich willkommen. Haben Sie eine Reservierung?',
  },
  3: {
    title: 'Beim Arzt',
    level: 'A2',
    systemPrompt:
      'You are a calm German general practitioner. Reply in German at level A2 (max 10 words). ' +
      'Ask simple yes/no questions. Be sympathetic.',
    opening: 'Guten Tag. Was fehlt Ihnen heute?',
  },
  4: {
    title: 'Auf dem Markt',
    level: 'A1',
    systemPrompt:
      'You are a friendly German market vendor. Reply in German at level A1 (max 6 words). ' +
      'Recommend fresh items.',
    opening: 'Hallo! Suchen Sie etwas Bestimmtes?',
  },
};

async function callSpeakingContinue({ scenarioId, history, userMessage }) {
  const scenario = SCENARIOS[scenarioId];
  if (!scenario) {
    const err = new Error(`Unknown scenarioId ${scenarioId}`);
    err.statusCode = 400;
    throw err;
  }

  const chatPrompt = `${scenario.systemPrompt}

Conversation so far:
${history.map((m) => '- ' + m).join('\n')}
- User: ${userMessage}

Reply now (German only, JSON: {"reply": "<your short German reply>"}).`;

  return await callGemini(chatPrompt, false);
}

async function callGemini(prompt, expectBigSchema) {
  let r;
  try {
    r = await model.generateContent(prompt);
  } catch (e) {
    // Wrap network / quota / 5xx errors with statusCode so the route handler
    // can log context.
    const wrapped = new Error(`Gemini request failed: ${e?.message || e}`);
    wrapped.cause = e;
    throw wrapped;
  }

  const raw = r.response.text();
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (e) {
    console.error(`Could not parse Gemini JSON (expectSchema=${expectBigSchema}):`, raw.slice(0, 200));
    throw new Error('AI returned non-JSON response');
  }
  return parsed;
}

// ─────────────────────────────────────────────────────────────────────
// Boot
// ─────────────────────────────────────────────────────────────────────

app.listen(PORT, '0.0.0.0', () => {
  console.log(`deutschy-proxy listening on :${PORT} — ${ALLOWED_ORIGINS.length} allowed origins`);
});
