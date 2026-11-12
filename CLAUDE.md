# ArgueLess

## North star

**Through daily use, the user learns to see tricky situations as cooperative
rather than threatening.**

Every change is measured against this. A feature earns its place if it helps
someone, in a few minutes a day, practise the thinking and the words that turn
a defensive moment into a curious, cooperative one, and then notice that
change in their real life.

What follows from it:

- **Practice, not lectures.** The user generates ideas first and sees
  suggestions second. Producing beats reading.
- **Small and daily.** A practice takes about five minutes; a day's goal is
  5 to 15. Nothing should make a session longer without a reason.
- **Fun and kind.** Playful, warm, never preachy. Self-ratings and the
  journal must never feel like a grade or a scolding.
- **Real life is the scoreboard.** The daily journal (what the user
  noticed over the last day) is where the change shows; streaks and idea
  counts only keep the user coming back to it. The journal is free text on
  purpose (counting moments felt too heavy). Trends will come later from an
  AI reading the journal, not from tallies the user keeps.
- **Private by default.** Ideas, replies and reflections are personal. They
  stay on the device, in app-private storage. Nothing is uploaded, shared or
  analysed. The microphone button hands speech to the phone's speech
  service (Google on Android, Apple on iOS), which may process it on its
  servers, as the keyboard mic does; the About page says so. The app has no
  internet permission in release and never sees the audio.
- **Not therapy.** Scenarios never involve abuse, violence or situations
  where cooperating would be unsafe. The app practises everyday friction.

## Quality bar

### Before every check-in (commit)

1. **Automated checks, all green**, even for a docs-only change. Run from the
   repo root (Flutter is at `C:\src\flutter\bin`, not on PATH by default):
   ```sh
   (cd packages/argueless_core && dart analyze && dart test)
   (cd app && flutter analyze && flutter test && flutter build apk --debug)
   ```
   The core tests include `shipped_content_test.dart`, which loads the real
   content in `app/assets/content/`. Regenerated content must pass it.
2. **Run the Gate crew** from
   [.claude/agents/REVIEW_AGENTS.md](.claude/agents/REVIEW_AGENTS.md): `hal`
   and `tess`, plus the specialists the change calls for, in parallel as
   separate subagents, then `vera`. A docs-only change gets `daphne` → `vera`.
   A content-only change gets `cora` and `grace` → `vera`.
3. **Fix or explicitly accept** every Blocker and Should-fix that `vera`
   confirms, then re-run the checks.
4. **Say what ran in the commit message:** the crew, what `vera` confirmed,
   and anything not verified.

### Before every deployment

A deployment is anything that puts a build in someone else's hands.

1. Everything in the check-in list.
2. `fred` walks a full practice, a journal entry and progress on an
   emulator and a real device, and confirms the data survives a restart.
3. **Run the Release readiness crew** → `vera`: ship, ship with stated risks,
   or hold.
4. **Eric deploys.** A recommendation to ship is not permission to ship.

Give each agent a model per the global rules: `haiku` for mechanical checks,
`sonnet` for judgement, `opus` only when a cheaper model has fallen short.

## Versions

- `major.minor.patch`, starting at 0.1.0. **A new feature** bumps minor and
  sets patch to 0 (0.1.3 → 0.2.0). **A bug fix** bumps patch (0.2.0 →
  0.2.1). Major stays 0 until Eric decides otherwise.
- Every change that reaches a commit updates **both** `version:` in
  `app/pubspec.yaml` (bump the `+build` number too) and a new top entry in
  `app/assets/changelog.json`: the version, the date, and one plain
  sentence per change, written for the user. Several changes before a
  commit share one entry. Docs-only or test-only changes need no bump.
- `changelog_test.dart` (core) fails if the two disagree or the entries are
  not newest first. The about page shows the newest entry; tapping it opens
  the full history.

## Stack and layout

- **Flutter** (stable, 3.47+, Dart 3.13+) for Android and iOS.
- `packages/argueless_core/` is pure Dart with no Flutter, so all of it is
  unit-testable:
  - `content/`: `ContentLibrary`, `Subject`, `Scenario`, `Roleplay`,
    `Rubric`, `ScaleLevel`, and `JsonContentSource`, which reads the content
    files through a `read(name)` function.
  - `practice/`: `PracticeSession` (the step machine, with two
    `BrainstormRound`s), `PracticeRecord`, `PracticeLog` and
    `JsonFilePracticeLog`, `ScenarioPicker`, `PracticeStats`.
  - `reflection/`: `Reflection` (one journal entry a day; entries from
    before 0.3.0 also hold three counts, kept on save), `ReflectionLog` and
    `JsonFileReflectionLog`.
  - `storage/AtomicJsonFile`, `time/LocalDay`.
- **The seams for a future AI backend** are `ContentSource` (where the
  library comes from) and `ScenarioProvider` (what to practise next; today
  `LibraryScenarioProvider`). A generator implements these; the screens do
  not change. See `docs/content/README.md`.
- `app/` is the Flutter app. Under `lib/src/`: `app/` holds the shell,
  services, theme and `Clock`; `home/` the home screen; `practice/` the
  practice flow (one widget per step); `reflect/` the journal;
  `progress/` totals, self-ratings and journal entries; `speech/` the
  microphone button behind `SpeechInput` (fake: `FakeSpeechInput`).
- **Code style:** object-oriented, one class per file, YAGNI. Platform and
  time stay behind small interfaces so tests use fakes (`app/test/fakes/`).
  State is plain Flutter (`setState`); there is no state library.

## Practice flow

`PracticeStep`: reframes → reframeReview → phrases → phraseReview →
roleplay → done. Each step must be complete before `advance()`: at least one
idea, every criterion rated, a favourite chosen and a reply sent. A half-typed
idea counts when the user continues. Liked suggestions join the user's own
phrases as role-play choices; with none, every suggestion is offered. The
record is saved once, on reaching `done`. Leaving mid-practice asks first
(once there are ideas) and saves nothing.

## Content

- Shipped as JSON in `app/assets/content/`: `library.json` (scale, default
  rubrics, subjects) and one scenario file per subject. Format and rules:
  `docs/content/README.md`.
- **The generation prompts live in `docs/content/prompts/`.** Regenerate or
  extend content from them, never by hand-editing in a different style.
- A subject may override either rubric (`emotion` and `rebuttal` do).
- Scenario ids are permanent: saved records refer to them. Never reuse or
  renumber an id; retire a scenario by removing it (old records keep their
  text, since liked suggestions are stored as text).
- `schemaVersion` is 1. A change that old apps cannot read bumps it.

## Data the app keeps

- `practice_log.json` and `reflections.json` in
  `getApplicationDocumentsDirectory()`, each `{schemaVersion, records |
  reflections}`. Writes go to a temp file then rename, one at a time
  (`AtomicJsonFile.update`).
- An entry that cannot be parsed is skipped when reading but **kept** in the
  file when writing. A file that is not JSON at all is moved aside to
  `<name>.unreadable`, never deleted.
- One journal entry per local day; saving again replaces it. Times are saved in
  UTC; days are local (`LocalDay`).
- The app itself sends nothing: no network permission in release, no
  analytics. Dictation goes through the phone's speech service (above).
- **Backups are the phone's, declared on the About page.** Android backs up
  exactly the four data files (`practice_log.json`, `reflections.json`,
  `settings.json`, `reminders.json` in `app_flutter/`) to the user's Google
  account and in phone-to-phone transfer: `res/xml/data_extraction_rules.xml`
  (Android 12+) and `res/xml/backup_rules.xml` (older). iOS backs up the
  Documents folder to iCloud or a computer. ArgueLess keeps no copies of its
  own. A new data file must be added to both XML files.

## Platform gotchas

- **Windows Android builds:** `app/android/gradle.properties` sets
  `kotlin.incremental=false` (project on `F:`, pub cache on `C:`).
- **Real file reads hang inside `testWidgets`.** Load the shipped library
  in `setUpAll` (`shippedLibrary()` in `app/test/fakes/test_services.dart`).
- **Screenshots from a device:** `adb exec-out screencap -p > file.png` from
  Bash; PowerShell's `>` corrupts binary output.
- **Emulator:** `Rememberem_Pixel` is a phone AVD on this machine (the
  others are watches).
- The idea field wraps but is single-line input (`TextInputType.text`), so
  Enter adds the idea. A multiline keyboard would insert newlines instead.
- No launcher icon or splash yet: Flutter's defaults.
