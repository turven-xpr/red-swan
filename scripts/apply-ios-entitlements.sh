#!/usr/bin/env bash
# scripts/apply-ios-entitlements.sh
#
# Idempotently wires CODE_SIGN_ENTITLEMENTS into the Runner target.
#
# Usage:
#   1.  Replace YOUR_TEAM_ID in ios/Runner/Runner.entitlements.
#   2.  bash scripts/apply-ios-entitlements.sh
#   3.  Open ios/Runner.xcodeproj in Xcode.  Signing & Capabilities ->
#       "Sign in with Apple" must now be added (one click).
#
# This script edits the pbxproj with a Python regex, which is fine
# for the standard Flutter Runner project.

set -euo pipefail

PBX="ios/Runner.xcodeproj/project.pbxproj"
ENT="Runner/Runner.entitlements"

if [[ ! -f "$PBX" ]]; then
  echo "Run this from the Flutter project root (no ios/ found)." >&2
  exit 1
fi

if grep -q "$ENT" "$PBX"; then
  echo "Entitlements already linked: $ENT"
  exit 0
fi

python3 - "$PBX" "$ENT" <<'PY'
import re, sys
pbx, ent = sys.argv[1], sys.argv[2]
with open(pbx,"r",encoding="utf-8") as f:
    src = f.read()

inj_line = f"CODE_SIGN_ENTITLEMENTS = {ent};"
def fix(match):
    body = match.group(2)
    if "CODE_SIGN_ENTITLEMENTS" in body:
        return match.group(0)
    return (
        match.group(1)
        + body.rstrip()
        + f"\n\t\t\t\t{inj_line}"
        + match.group(3)
    )

new_src = re.sub(
    r"(name\s*=\s*(?:Debug|Release|Profile);[\s\S]*?buildSettings\s*=\s*\{)([^}]*?)(\}\);)",
    fix,
    src,
    flags=re.MULTILINE,
)
if new_src == src:
    print(f"[warn] No XCBuildConfiguration blocks matched in {pbx}. Open Xcode manually: Build Settings -> Runner target -> add CODE_SIGN_ENTITLEMENTS = {ent}.")
else:
    with open(pbx,"w",encoding="utf-8") as f:
        f.write(new_src)
    print(f"Patched {pbx}: added CODE_SIGN_ENTITLEMENTS = {ent}")
PY

echo "Done.  Open Runner.xcodeproj in Xcode to verify Signing & Capabilities: Sign In with Apple is enabled."
