# ARISE Study System - Gamified Solo Leveling RPG Study App

A high-performance gamified Android study app built with **Flutter**, inspired by **Solo Leveling** aesthetics.

## ✨ Features
- **Solo Leveling UI/UX**: Dark fantasy neon theme (Cyan, Gold, Purple, Green).
- **Floating Mana Particles**: Ambient particle system built with Flutter `CustomPainter`.
- **Level & XP Progression**: Interactive daily missions with real XP, level up celebration modals, and currency rewards.
- **Subject Mastery**: Live progress bars for Maths, English, Computer, Reasoning.
- **Deep Work Focus Timer**: 45-minute study countdown with circular progress indicator.
- **Dungeon Gate Portal**: Rank A study dungeon for deep focus sessions.
- **Offline Storage**: Uses `shared_preferences` to persist user level, XP, coins, and streak on the phone.

## 🚀 How to Build APK for Free (Without freezing your 4 GB RAM PC)

### Option 1: 100% Free Cloud Build via GitHub (Recommended for 4 GB RAM)
1. Upload this folder (`arise_study`) to a new **GitHub Repository**.
2. GitHub will automatically detect `.github/workflows/build_apk.yml`.
3. In the **Actions** tab on GitHub, it will build `app-release.apk` using GitHub's 16 GB RAM cloud servers in ~2 minutes!
4. Download the `.apk` directly to your phone and install!

### Option 2: Local Development with Flutter
1. Install Flutter SDK and Git on Windows.
2. Run:
   ```bash
   flutter pub get
   flutter run
   ```
   *(Connect your Android phone with USB Debugging enabled to run directly on hardware).*
