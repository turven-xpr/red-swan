#!/usr/bin/env bash
# scripts/generate-release-key.sh
#
# Generate a 25-year RSA 2048-bit keystore for Google Play uploads.
# Run on a *trusted developer machine*, never in CI, never in source control
# (the resulting `.jks` file is private).  We use the recipe exactly once;
# losing the keystore means you can never update your Play Store listing.
#
# After running this script:
#   1.  `flutter build apk --release` builds a release-type APK signed
#       with this keystore.
#   2.  Upload the resulting APK / AAB to Google Play Console for the
#       *first* release only — Play locks the listing to this signature.

set -euo pipefail

NAME="${1:-deutschy}"
ALIAS="${2:-deutschy-release}"
VALIDITY_DAYS="${3:-9125}" # 25 years

OUT_KEYS=android/keys
mkdir -p "$OUT_KEYS"

KEYSTORE="$OUT_KEYS/upload-keystore.jks"

if [[ -f "$KEYSTORE" ]]; then
  echo "[!] $KEYSTORE already exists. Refusing to overwrite so your Play"
  echo "    Store signature stays unchanged.  Delete the keystore by hand"
  echo "    ONLY if you understand the consequence (Play will refuse all"
  echo "    future uploads)."
  exit 1
fi

echo "Generating RSA-2048 $VALIDITY_DAYS-day keystore at $KEYSTORE."
echo "You will be prompted for two passwords — store them in your password"
echo "manager alongside the keystore file."
echo

keytool -genkey \
    -v \
    -keystore "$KEYSTORE" \
    -alias "$ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity $VALIDITY_DAYS \
    -storepass "${KEYSTORE_STORE_PASS:?set KEYSTORE_STORE_PASS env}" \
    -keypass "${KEYSTORE_KEY_PASS:?set KEYSTORE_KEY_PASS env}" \
    -dname "CN=Deutschy Release, OU=Engineering, O=Deutschy, L=Berlin, ST=Berlin, C=DE"

echo
echo "Keystore generated. Now write android/key.properties (chmod 600) with:"
cat <<PROPS
storeFile=$KEYSTORE
storePassword=\${KEYSTORE_STORE_PASS}
keyAlias=$ALIAS
keyPassword=\${KEYSTORE_KEY_PASS}
PROPS

echo
echo "Done. Next step: flutter build appbundle --release"
