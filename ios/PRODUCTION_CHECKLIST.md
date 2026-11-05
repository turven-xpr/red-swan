# Apple Sign-In capability — manual Xcode toggle

The `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements` line is now wired
into all 3 Runner target build configurations.

Apple Sign-In is still **also** a "Capability" in Xcode that has to be
enabled via a one-time UI click (otherwise Xcode strips the entitlement
chain at archive time).

## One-time Xcode flow

1. **Set the Team ID**

   `ios/Runner/Runner.entitlements`:
   ```
   <key>com.apple.developer.teamid</key>
   <string>ABCDE12345</string>
   ```
   Substitute your real Apple Developer Team ID
   (from <https://developer.apple.com/account/#/membership/>).

2. **Open the Xcode project**

   ```bash
   open ios/Runner.xcodeproj
   ```

3. **Enable the "Sign In with Apple" capability**

   *Select the **Runner** target in the project navigator* → **Signing & Capabilities** tab
   → press **+ Capability** → pick **Sign In with Apple**
   → toggle the dropdown to **Enable**.

   You should see two new entitlements appear:
   * `com.apple.developer.applesignin` = `["Default"]`
   * `com.apple.developer.teamid` = your team ID
   (`Runner.entitlements` already declares both; Xcode will normalise the file in-place.)

4. **(If you sign app-store builds)** change the *Bundle Identifier* under *Identity* to
   a unique value you own (e.g., `com.you.deutschy`).

5. **Verify the entitlement survived a build**

   ```bash
   cd ios
   xcodebuild -workspace Runner.xcworkspace -scheme Runner \
       -configuration Release -showBuildSettings \
       | grep CODE_SIGN_ENTITLEMENTS
   ```

   Output:
   ```
   CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements
   ```

That's it.  Re-archive, run on a device, and Apple Sign-In will be live.

## Why this manual step exists

Xcode's capability system stores capability-bound identifiers inside
the `*.entitlements` file *and* the project's `xcschememanagement.plist`.
We can drive 80 % of it from a script (the `Runner.entitlements` file plus
`p$bX` patches), but the final "click" must be in Xcode — otherwise
no Signing certificate binds to the entitlement, and Apple's review
will reject it with a missing-entitlement error.
