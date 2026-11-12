# Practice content

All practice material ships as JSON in `app/assets/content/` and is loaded at
start-up by `JsonContentSource` (`packages/argueless_core`). It was generated
with the prompts in [prompts/](prompts/), which are kept so the material can
be regenerated, extended, or used as the starting point for an AI backend.

## Files

### `library.json`

```jsonc
{
  "schemaVersion": 1,
  "scale": [{ "value": 1, "label": "Not yet" }, ...],      // self-rating levels
  "rubrics": {
    "reframe": { "title": "...", "criteria": [{ "id", "label", "prompt" }] },
    "phrases": { ... }
  },
  "subjects": [{
    "id": "letting-go",            // permanent
    "title", "tagline", "brief",
    "color": "0xFF2E7DD7",         // ARGB, as a string
    "icon": "balance",             // balance | help | favorite | forum | hearing | pause | diversity | self | spa | waves
    "scenarioFile": "letting_go.json",
    "rubrics": { "reframe": {...} } // optional: replaces the default for this subject
  }]
}
```

### One scenario file per subject

```jsonc
{
  "schemaVersion": 1,
  "subjectId": "letting-go",       // must match the subject that names the file
  "scenarios": [{
    "id": "lg-01",                 // permanent, unique across all files
    "title", "setting",            // setting: "Work · stand-up meeting"
    "difficulty": 1,               // 1 to 3
    "situation",                   // 2–4 sentences, second person
    "firstThought",                // the defensive automatic thought
    "reframes": ["..."],           // 6 suggested thoughts
    "phrases": ["..."],            // 6 suggested things to say
    "roleplay": { "partner": "Dana, your manager", "opening", "partnerReply" },
    "takeaway"                     // one line to carry into the day
  }]
}
```

Unknown fields are ignored, so adding an optional field needs no version bump.
Removing or renaming a field does: bump `schemaVersion` and teach the loader
both versions.

## Rules

- **Ids are permanent.** Practice records refer to scenario ids. Add new
  scenarios with new ids; never renumber.
- **Validate before committing.** `packages/argueless_core/test/
  shipped_content_test.dart` loads the real files and checks the structure.
  Run `dart test` in the core package.
- **Tone:** warm, playful, never preachy or clinical. No abuse, violence or
  self-harm. The other person always has an understandable point of view.

## Regenerating or extending

1. Open [prompts/scenario-batch.md](prompts/scenario-batch.md).
2. Fill the placeholders for one subject: id, title and brief from
   `library.json`, the subject notes from the bottom of the prompt file, a
   count, the id prefix (`lg`, `cf`, `em`, `rb`, `hf`, `lf`, `dv`, `bp`, `km`, `tt`), and the titles of existing
   scenarios under `avoid`.
3. Run it with a capable model and merge the returned scenarios into the
   subject's file, continuing the id numbering.
4. Run the core tests, then read a few scenarios in the app.

The first batch (eight per subject) was made this way with Claude Sonnet,
one subagent per subject, using the prompt unchanged. The second batch
(0.3.0) added six subjects of eight scenarios and four more scenarios to
each of the first four subjects, the same way. Inner subjects (`both-parts`,
`kinder-mirror`, `turning-toward`) have no other person: the role-play
partner is a part of the user, named "The tired part, a part of you".

## Toward an AI backend

The app depends on two interfaces, not on these files:

- `ContentSource.load()` returns a `ContentLibrary`. A remote or cached
  library implements it.
- `ScenarioProvider.next({subjectId, excluding})` returns the next
  `Scenario`. Today `LibraryScenarioProvider` picks from the library using the
  practice log; a generator could instead fill `scenario-batch.md` with
  `count = 1` and the user's recent history, and parse the result with
  `Scenario.fromJson`.

Practice records keep liked suggestions as text, so generated scenarios that
are never stored again still leave a readable history.
