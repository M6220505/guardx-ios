# GuardX — iOS app (Capacitor)

A complete, ready-to-open Xcode project that wraps **https://7guardx.com**
as a native iOS app, built with [Capacitor](https://capacitorjs.com).

## Why Capacitor instead of a plain WebView wrapper

Apple's App Store Review Guidelines (section 4.2, "Minimum Functionality")
reject apps that are just a website loaded in a WebView with no native
value added. Unlike Google Play — which explicitly supports thin
web-wrapper apps (Trusted Web Activities) — Apple expects real native
functionality. This project is set up with actual native plugins (push
notifications, native share sheet, status bar/splash screen control) on
top of your live site, which gives it a real shot at passing review. It's
still not a guarantee — Apple reviewers make a judgment call — but it's
the standard, defensible approach for shipping an existing web app to iOS.

The app loads your live site directly (`capacitor.config.json` →
`server.url: "https://7guardx.com"`), so like the Android version, it
updates automatically whenever you update the website — no app update
needed for content changes.

## Setup (do this first)

`node_modules` isn't included in this zip to keep it small. From the
project root: `npm install` (requires Node.js — same as installing any
npm project). This works on any OS, before you get to a Mac.

## What's already done (built in a Linux sandbox — see note below)

- Full Xcode project generated (`ios/App/App.xcodeproj`)
- Capacitor configured to load `https://7guardx.com`, themed to match
  your site (`#060A10` background)
- Native plugins installed: Push Notifications, Share, App, Status Bar,
  Splash Screen
- `Info.plist` configured with background push support

**Note on how this was built:** This was generated in a Linux sandbox
with no macOS/Xcode available. It turns out `npx cap add ios` can
generate the full Xcode project structure on any OS (only *compiling* it
requires Xcode on a Mac) — so what you're getting is a real, complete
Xcode project, not a mockup. Nothing here needs to be regenerated; you can
open it directly in Xcode on a Mac.

## What you still need — and you'll need a Mac (or a cloud Mac build
## service, see below) for all of this

### 1. Get access to a Mac
You mentioned you don't currently have a Mac. Options:
- **Borrow/rent physical access** — even a friend's Mac for an afternoon
  is enough to do the one-time signing setup, after which cloud CI can
  handle ongoing builds.
- **Cloud Mac build services** (no physical Mac needed at all):
  [Codemagic](https://codemagic.io) has a free tier and native Capacitor
  support — probably the easiest path. [Bitrise](https://bitrise.io) and
  GitHub Actions' `macos-latest` runners are alternatives.
- If you go the cloud CI route, you'll push this project to a Git repo
  and point the CI service at it; it builds and can submit to App Store
  Connect directly.

### 2. Open in Xcode and set your team
`npx cap open ios` (or open `ios/App/App.xcworkspace` directly). In
Xcode: select the App target → Signing & Capabilities → choose your Apple
Developer team → Xcode auto-generates a provisioning profile.

### 3. Replace the placeholder app icon
`ios/App/App/Assets.xcassets/AppIcon.appiconset` currently has no images.
Drop in your `icon-512.png` (or better, run it through an icon generator
like [appicon.co](https://appicon.co) to get every required size) and
drag them into the asset catalog in Xcode.

### 4. Set up Push Notifications capability (optional, only if you want
### native push — the app works fine without it)
In Xcode: Signing & Capabilities → + Capability → Push Notifications, and
also enable Background Modes → Remote notifications (already declared in
Info.plist). You'll then need an APNs key from your Apple Developer
account and server-side code on your end to actually send pushes — that's
a separate piece of work from this app shell.

### 5. Build and archive
`Product > Archive` in Xcode → once archived, `Distribute App` → App
Store Connect → upload.

### 6. App Store Connect
1. Create the app listing at [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   (uses your existing Apple Developer account, no extra fee beyond the
   $99/year membership).
2. Fill in the store listing: screenshots (required for multiple device
   sizes), description, keywords, support URL.
3. **Privacy Policy URL** — required, and will get extra scrutiny given
   this app handles wallet addresses.
4. **App Privacy details** — Apple's version of a data-safety
   questionnaire: declare what data is collected and how.
5. Submit the build from step 5 for review.
6. Expect Apple's review (typically 1-3 days) to take longer and ask more
   questions than a typical app, given the crypto/financial angle —
   budget extra time versus Google Play's review.

## Files in this project

```
capacitor.config.json    Points the app at https://7guardx.com, theme colors, plugin config
package.json             Capacitor dependencies + helper scripts (ios:sync, ios:open)
www/index.html            Required local fallback shell (not shown in normal use)
ios/App/App.xcodeproj     The actual Xcode project — open this on a Mac
ios/App/App/Info.plist    App metadata, background modes for push
```

## After making any changes to capacitor.config.json or plugins

Run `npx cap sync ios` to push the changes into the Xcode project before
building.
