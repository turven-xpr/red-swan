# Deutschy → Gemini Proxy

A tiny Node/Express server that fronts Google's Gemini 2.5 Flash API for the
**Deutschy** Flutter learning app. The server holds the Gemini API key
**on the server**; the mobile app never sees it.

---

## Overview

The Deutschy app exposes two AI-driven features to learners:

| Action                | What it does                                            |
|-----------------------|---------------------------------------------------------|
| `writing_correction`  | Grade a student's German essay and return corrections.  |
| `speaking_continue`   | Drive an A1/A2 role-play conversation (Café, Hotel, …).  |

Both are routed through `POST /ai` on this proxy, which:

1. Validates the JSON body with **zod**.
2. Looks up the right scenario / prompt.
3. Calls Gemini 2.5 Flash using `GEMINI_API_KEY` from env.
4. Returns the parsed JSON envelope to the app.

## Why a proxy?

The Gemini API key **must not be in the Flutter binary.** Anyone who
unpacks the APK could extract it and run up the bill. Putting it on a
server we control means:

- The key can be rotated without forcing an app update.
- We can rate-limit and log requests server-side.
- We can change providers (OpenAI, Mistral, …) without touching the app.

## Free-tier notes

This proxy is sized for the **Gemini 2.5 Flash free tier**:

- **15 requests / minute**
- **1,500 requests / day**
- No credit card required

It is fine for personal use and small-scale testing, but if the user base
grows you'll need billing enabled or a paid model.

## How to obtain a free API key

1. Go to <https://aistudio.google.com/app/apikey>.
2. Sign in with a Google account.
3. Click **Create API key** → **Create API key in new project** (or pick an
   existing one). No credit card needed.
4. Copy the key string — you will paste it into `GEMINI_API_KEY` next.

> Treat the key like a password. Rotate or revoke it at any time from the
> same page.

## Local development

```bash
# 1. Clone the repo and enter the proxy directory
cd deutschy/proxy

# 2. Install deps
npm install

# 3. Provide your key
cp .env.example .env
# then edit .env and paste the key from step 4 above
$EDITOR .env

# 4. Run
npm start
# → "deutschy-proxy listening on :3000 — N allowed origins"
```

### Smoke test

```bash
# Health probe
curl http://localhost:3000/healthz
# → {"ok":true}

# Writing correction (action dispatch)
curl -X POST http://localhost:3000/ai \
  -H "Content-Type: application/json" \
  -d '{
    "action": "writing_correction",
    "text": "Ich gehe zum Markt und kaufen ein Brot.",
    "level": "A1"
  }'
# → {"score_out_of_10":8,"overall_feedback":"...","corrections":[...]}

# Speaking practice (scenarioId 1 = Im Café)
curl -X POST http://localhost:3000/ai \
  -H "Content-Type: application/json" \
  -d '{
    "action": "speaking_continue",
    "scenarioId": 1,
    "userMessage": "Ich möchte einen Kaffee, bitte.",
    "history": []
  }'
# → {"reply":"Gerne! Klein oder groß?","schema":"text"}
```

### Development mode (auto-reload)

```bash
npm run dev
```

### Pointing the Flutter app at your local proxy

- Android emulator → `http://10.0.2.2:3000/ai` (loopback to host)
- iOS simulator → `http://127.0.0.1:3000/ai`
- Physical device on same LAN → `http://<your-LAN-IP>:3000/ai`

And add those origins to `ALLOWED_ORIGINS` in `.env` (the default in
`.env.example` covers Android emulator + local dev servers).

## Deployment

This repo ships one-click configs for both **Fly.io** and **Render**.
Pick whichever you prefer — both have a free tier.

### Option A — Fly.io (recommended; truly free tier)

```bash
# One-time
brew install flyctl        # or: scoop install flyctl / curl -L https://fly.io/install.sh | sh
fly auth signup

# In this directory
fly launch --copy-config --name deutschy-proxy
# Fly will detect fly.toml; answer "yes" to deploy.
fly secrets set GEMINI_API_KEY=your_key_here
# Optional: tighten CORS:
# fly secrets set ALLOWED_ORIGINS=https://your-app.example.com

fly open                   # open the deployed URL
```

Fly maps container port `8080` → public `80` + `443` automatically
(see `fly.toml`).

### Option B — Render Blueprint (one-click from a Git repo)

1. Push this folder (or the whole repo) to GitHub/GitLab.
2. Go to <https://dashboard.render.com/blueprints> → **New Blueprint Instance**.
3. Point it at the repo. Render reads `render.yaml` automatically.
4. In the dashboard for the new service, set:
   - `GEMINI_API_KEY` = your key
   - `ALLOWED_ORIGINS` = (optional) `https://your-app.example.com`
5. Click **Apply** → wait for the first build to finish → service is live.

### Verify after deploy

```bash
curl https://deutschy-proxy.fly.dev/healthz    # → {"ok":true}
```

## Health check

The single endpoint every platform should hit is:

```
GET /healthz   →   200 { "ok": true }
```

It does **not** call Gemini, so it's cheap to poll.

## Security

- **Never** commit `.env`. It is ignored by `.dockerignore` and your VCS.
- **Always** set `ALLOWED_ORIGINS` in production to the front-door origin of
  the Deutschy app. The dev default is permissive; the production default is
  *no allowed origins* → CORS will reject all browser calls.
- The key can be rotated at any time in Google AI Studio. After rotating,
  run `fly secrets set GEMINI_API_KEY=new_key` (or update the Render env
  var) — the app keeps working without a redeploy.
- The proxy logs each request as a single JSON line (`{at, ip, action, ok,
  ms, …}`). Pipe the platform's stdout into any log aggregator.

## License

MIT — see top of `package.json`.
