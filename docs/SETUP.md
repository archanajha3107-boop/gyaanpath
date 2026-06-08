# GyaanPath — Setup Guide

Complete guide to run GyaanPath on your machine.

---

## Prerequisites

| Tool | Version | Download |
|---|---|---|
| Flutter SDK | 3.0+ | flutter.dev |
| Dart | 3.0+ | included with Flutter |
| Android Studio | Latest | developer.android.com |
| VS Code | Latest | code.visualstudio.com |
| Git | Any | git-scm.com |

---

## Step 1 — Clone the Repo

```bash
git clone https://github.com/archanajha3107-boop/gyaanpath.git
cd gyaanpath
```

## Step 2 — Install Dependencies

```bash
flutter pub get
```

## Step 3 — Add Fonts

Download Mukta font from Google Fonts:
https://fonts.google.com/specimen/Mukta

Place these files in `assets/fonts/`:
- `Mukta-Regular.ttf`
- `Mukta-Medium.ttf`
- `Mukta-Bold.ttf`

## Step 4 — Add Textbook PDFs (Optional for testing)

Download FREE official PDFs:

**SSC Maharashtra (Balbharati):**
https://ebalbharati.in

Place in: `assets/pdfs/ssc/class_10/`

Name them exactly:
- `maths_part1.pdf`
- `maths_part2.pdf`
- `science_part1.pdf`
- `science_part2.pdf`

**CBSE (NCERT):**
https://ncert.nic.in/textbook.php

Place in: `assets/pdfs/cbse/class_10/`

## Step 5 — Run the App

```bash
# Check everything is fine
flutter doctor

# Run on connected device or emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

## Step 6 — Build APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release --split-per-abi

# APK location after build:
# build/app/outputs/flutter-apk/
```

---

## Running in GitHub Codespaces

1. Open repo on GitHub
2. Click Code → Codespaces → New codespace
3. Wait for environment to load (~2 min)
4. In terminal:

```bash
# Install Flutter in Codespace
git clone https://github.com/flutter/flutter.git \
  -b stable $HOME/flutter
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
flutter doctor
flutter pub get
```

5. Use Flutter web for preview:
```bash
flutter run -d web-server --web-port 8080
```

---

## Common Errors & Fixes

**Error:** `Mukta font not found`
**Fix:** Add font files to `assets/fonts/` folder

**Error:** `PDF asset not found`
**Fix:** Add `.gitkeep` file inside pdf folders
or add actual PDFs

**Error:** `sqflite not working`
**Fix:** Run `flutter clean && flutter pub get`

**Error:** `Gradle build failed`
**Fix:** Run `cd android && ./gradlew clean`

---

## Project Structure Quick Reference

```
lib/
├── main.dart          ← App starts here
├── app.dart           ← Theme + Router
├── constants/         ← Colors, strings, routes
├── database/          ← SQLite setup
├── models/            ← Data classes
├── providers/         ← State management
├── screens/           ← All UI pages
└── widgets/           ← Reusable components
```
