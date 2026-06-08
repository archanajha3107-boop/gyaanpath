# GyaanPath — Architecture

## Core Principle
**Offline First.** Every feature works with zero internet.
The app never makes a network call for content.

---

## Layer Architecture
┌─────────────────────────────────────┐
│           UI Layer (Screens)         │
│  HomeScreen, SolutionScreen, etc.    │
└──────────────┬──────────────────────┘
│ reads/writes via
┌──────────────▼──────────────────────┐
│         State Layer (Providers)      │
│  AppProvider, ContentProvider        │
└──────────────┬──────────────────────┘
│ queries
┌──────────────▼──────────────────────┐
│         Data Layer (Database)        │
│  DatabaseHelper → SQLite on device   │
└──────────────┬──────────────────────┘
│ stores
┌──────────────▼──────────────────────┐
│         Storage (Device Only)        │
│  gyaanpath.db + Hive boxes + Assets  │
└─────────────────────────────────────┘
ZERO NETWORK CALLS


---

## Data Flow Example
### Student opens Maths solutions:
HomeScreen
→ taps "Solutions"
→ ContentProvider.loadSubjects(board, class)
→ DatabaseHelper.query('subjects', ...)
→ SQLite returns rows
→ ContentProvider notifies listeners
→ SubjectsScreen rebuilds with data
→ student taps "Maths"
→ ContentProvider.loadChapters(subjectId)
→ ChaptersScreen shows chapters
→ student taps "Chapter 1"
→ SolutionScreen loads questions
→ student taps Q1
→ ContentProvider.getSolution(questionId)
→ SQLite returns solution text
→ Rendered with flutter_markdown


---

## Database Design
boards ──────< classes ──────< subjects
│
chapters
│
questions ────< solutions
│
quiz_questions
papers ──< boards
papers ──< classes
progress ──< chapters

---

## Key Packages & Why

| Package | Purpose |
|---|---|
| `sqflite` | All content stored locally in SQLite |
| `hive` | User settings, progress (faster than SQLite for KV) |
| `pdfx` | Render PDF textbooks without internet |
| `provider` | Efficient state — only rebuilds what changed |
| `go_router` | Clean navigation with deep links |
| `flutter_markdown` | Render solution steps with formatting |
| `connectivity_plus` | Show offline/online status badge |

---

## Video Sharing Architecture (Phase 2)
Teacher Phone (has videos)
│
│ Nearby Connections API
│ (Bluetooth / WiFi Direct)
▼
Student Phone
│
▼
VidyaApp/Videos/ folder
│
▼
better_player plays locally

No internet. No server. Peer to peer.

---

## Why NOT React Native or Kotlin?

| | Flutter | React Native | Native Kotlin |
|---|---|---|---|
| Android 5+ support | ✅ | ⚠️ | ✅ |
| Offline SQLite | ✅ Easy | ✅ OK | ✅ |
| PDF viewing | ✅ pdfx | ⚠️ Limited | ✅ |
| Single codebase | ✅ | ✅ | ❌ |
| Performance | ✅ Fast | ⚠️ Bridge | ✅ Native |
| Learning curve | Medium | Medium | Hard |
| **Winner** | **✅** | | |
