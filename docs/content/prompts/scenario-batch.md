# Prompt: a batch of practice scenarios for one subject

This is the prompt used to pre-generate the scenario files in
`app/assets/content/`. Run it once per subject. Fill the placeholders from
`app/assets/content/library.json` (the subject's `id`, `title` and `brief`)
and from the subject notes below. The same prompt is the starting point for a
future AI backend (see `docs/content/README.md`).

Placeholders: `{{subjectId}}`, `{{subjectTitle}}`, `{{subjectBrief}}`,
`{{subjectNotes}}`, `{{count}}`, `{{idPrefix}}`, `{{avoid}}` (titles of
existing scenarios, so a new batch does not repeat them; "none" for a first
batch).

---

## The prompt

You are writing practice material for **ArgueLess**, a mobile app where people
spend 5 to 15 minutes a day practising thought and language patterns that
invite curiosity and cooperation instead of defensiveness. The app's north
star: *through daily use, the user learns to see tricky situations as
cooperative rather than threatening.* The tone is warm, light and playful,
never preachy, clinical or therapeutic. The user is an ordinary adult: at work,
at home, with friends, family, neighbours, strangers and online.

Each scenario is played like this:

1. The user reads a short **situation** and the **first thought** a defensive
   mind might have.
2. They brainstorm **reframes**: new ways to *think* about the moment that
   invite better communication. Then they compare with your suggested
   reframes.
3. They brainstorm practical **phrases**: words they could actually *say*
   that embody the new thinking. Then they compare with your suggested
   phrases.
4. They pick their favourite phrase and **role-play**: the other person says
   an opening line, the user replies, and the other person responds the way
   a cooperative reply tends to invite.

Write {{count}} scenarios for the subject **{{subjectTitle}}**.

Subject brief: {{subjectBrief}}

{{subjectNotes}}

Requirements for every scenario:

- **Variety.** Spread the scenarios across work, family, partner, friends,
  neighbours, service encounters and online. Vary the other person's age,
  role and power relative to the user (a boss, a teenager, a stranger, a
  peer). Vary stakes from trivial to genuinely tense. Mix difficulty:
  roughly a third each of 1 (easy), 2 and 3 (hard).
- **The situation** is 2 to 4 sentences, second person, present tense, with
  one concrete detail that makes it vivid. No villains: the other person has
  an understandable point of view even if it is not obvious. Never involve
  abuse, violence, self-harm, or any situation where cooperating would be
  unsafe; those are not what this app practises. Never write an other
  person with a pattern of belittling, controlling or threatening the user:
  one awkward moment from a decent person, not mistreatment to absorb.
- **The first thought** is the defensive, automatic thought in the user's
  own voice, first person, under 20 words. Make it relatable, not cartoonish.
- **Reframes**: exactly 6, each a first-person thought under 20 words. Cover
  different angles: questioning my assumption, a charitable motive for them,
  what we both want, what I might be missing, what this feeling is telling
  me, how this looks from their side. They are thoughts, not things to say.
  Where the user has clear evidence or a safety concern, do not invent
  self-doubt: the "missing" angle is then about what *they* know, or what
  the other person might not have seen.
- **Phrases**: exactly 6, each something a real person would say out loud,
  under 25 words. Favour open questions, "I" statements and reflecting back
  what you heard. No jargon ("I feel that you..."), no therapy-speak, no
  scripts that sound sarcastic when read flat.
- **Role-play**: `partner` names the other person and their relation in a
  few words ("Dana, your manager"). `opening` is the line they say that the
  user replies to, in their voice, under 30 words. `partnerReply` is how
  they might respond to a curious, cooperative reply: under 40 words, human
  and believable (it may still be a bit guarded), showing the door opening.
- **Takeaway**: one short sentence the user can carry into the day, under 15
  words, without exclamation marks.
- **Title**: 2 to 5 words, playful, no punctuation at the end.
- **Setting**: a few words naming the domain and the place, as
  "Work · stand-up meeting".

Do not repeat these existing scenarios: {{avoid}}

Return only JSON, matching this shape exactly (no comments, no trailing
commas):

```json
{
  "schemaVersion": 1,
  "subjectId": "{{subjectId}}",
  "scenarios": [
    {
      "id": "{{idPrefix}}-01",
      "title": "…",
      "setting": "…",
      "difficulty": 1,
      "situation": "…",
      "firstThought": "…",
      "reframes": ["…", "…", "…", "…", "…", "…"],
      "phrases": ["…", "…", "…", "…", "…", "…"],
      "roleplay": {
        "partner": "…",
        "opening": "…",
        "partnerReply": "…"
      },
      "takeaway": "…"
    }
  ]
}
```

Ids run `{{idPrefix}}-01`, `{{idPrefix}}-02`, … with two digits. When adding
to an existing file, continue the numbering.

---

## Subject notes

Paste the matching block into `{{subjectNotes}}`.

### letting-go: Letting go of being right

Scenarios where the user feels the urge to correct someone, win the point,
or take over the conversation: a wrong fact at dinner, a colleague
explaining something the user knows better, a partner telling a shared story
"wrong", a friend's plan the user would do differently, a stranger online who
is mistaken. Generous thinking questions the user's own assumptions, asks
for clarity, is curious about why the other person sees it that way, notices
when being right doesn't matter, and allows an alternative opinion to stand.
Include some where the user may actually be the one who is wrong or only
partly right.

### confusion: Confusion is a signal

Scenarios where the user doesn't understand: jargon in a meeting, a
teenager's slang or world, a decision that seems to make no sense, an
instruction that is ambiguous, a political or cultural view the user finds
baffling, someone upset for reasons the user can't see. The defensive pull is
to dismiss ("that's nonsense"), bluff, tune out, or assume bad intent.
Generous thinking treats the confused feeling as a cue to get curious,
listen, ask, and learn. Phrases should include honest admissions of not
understanding that sound confident rather than weak.

### emotion: Noticing the feeling

Scenarios built around a trigger: a clipped reply, being interrupted, a
sigh, sarcasm, being left out, criticism, someone else visibly irritated or
hurt. Some focus on the user's own emotion rising (heat, tight chest, the
urge to snap), some on noticing it in the other person. Generous thinking
names the feeling without blaming, gets curious about what is underneath,
and surfaces it gently ("I notice I'm getting a bit tense"), or checks in
("You seem frustrated, did I miss something?"). Reframes should include at
least one that names the user's own feeling and one that guesses at the
other person's.

### rebuttal: When to push back

Scenarios where the user disagrees and must decide whether and how to say
so. Include a mix: some where pushing back clearly helps (a safety issue, a
decision about to be made on a wrong premise, a teammate being steamrolled),
some where it is better to ask first or wait for a better moment, and some
where letting it go is wiser (a trivial point, a grieving person, a
celebration). The reframes should help the user weigh the call: does it
matter, is now the time, have I understood them, what do we both want. The
phrases should, where speaking up is right, offer the alternative view
constructively: acknowledge their view first, offer mine as mine, invite
them to poke holes. The takeaway should state the call ("Speak up: the
deadline is built on a wrong number." / "Let this one go.").
