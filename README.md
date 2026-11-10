# ArgueLess

A Flutter app for Android and iOS for practising the thought and language
patterns that invite curiosity and cooperation, a few playful minutes a day.

**Daily practice.** Each scenario is a small tricky moment. You brainstorm as
many reframes as you can (new ways to think about it), compare with
suggestions and rate yourself; brainstorm phrases you could actually say,
compare and rate again; then pick your favourite phrase and role-play it.

**Daily reflection.** Look back over the last 24 hours and count the moments
where generous thinking was automatic, where you started defensive but turned
it around, and where it became conflict. The progress screen charts it over
two or twelve weeks.

Four subjects ship with eight scenarios each: letting go of being right,
confusion as a signal, noticing the feeling, and when to push back.

## Layout

| Path | What lives there |
| --- | --- |
| `app/` | The Flutter app. Content JSON is in `assets/content/`. |
| `packages/argueless_core/` | Pure Dart: content model and loader, practice session, logs, stats, chart series. |
| `docs/content/` | The content format and the prompts used to generate it. |
| `.claude/agents/` | The review crew. |

## Commands

```sh
cd packages/argueless_core && dart test
cd app && flutter analyze && flutter test
cd app && flutter run -d <device>
cd app && flutter build apk
```

On Eric's machine Flutter is at `C:\src\flutter\bin`.
