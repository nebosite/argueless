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
   that embody the new thinking: what they would say to the other person,
   or to themselves. Then they compare with your suggested phrases, tapping
   the heart on any that ring true and bring up a softer feeling.
4. They **role-play**: the other person says an opening line, the user
   picks the phrase they want to try and replies, and the other person
   responds the way a cooperative reply tends to invite.

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

Paste the matching block into `{{subjectNotes}}`. For the three inner
subjects (`both-parts`, `kinder-mirror`, `turning-toward`), paste the
**Inner subjects** block first, then the subject's own block.

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

### hear-it: Hear it, don't fix it

Scenarios where someone close to the user (a partner, friend, sibling,
colleague, grown child, parent) brings them a hurt or a frustration about
something or someone else: a friend who let them down, a boss who took
credit, a neighbour they can't trust any more. The defensive pull is to fix:
give advice, solve the problem, defend the other party, or (most of all)
turn it into a review of how the speaker handled it ("well, you could have
said..."). What the speaker usually wants is to be heard: for the user to
notice the feeling (hurt, betrayal, disappointment, worry) and stay with it.
Generous thinking notices the feeling under the story, lets go of judging
how they handled it, and trusts that being heard is often the help. Phrases
reflect the feeling back, ask what they need ("Do you want ideas, or do you
just need me to hear this?"), and leave advice for later, if it is wanted at
all. The first thought is a fixing or judging thought, not a cruel one.

### let-them-finish: Let their idea land

Scenarios where someone shares an idea, plan, draft or dream (a friend's
business idea, a colleague's proposal, a partner's plan for the garden, a
teenager's scheme) and, while listening, the user feels confused, then
critical, then starts injecting their own ideas and takes over. The person
deflates or goes quiet. Generous thinking notices the confusion and the
critical itch as signals, gets curious about what the idea means to them,
lets them finish, and asks questions that help *their* idea grow before
offering any of the user's own. Include some where the user's concern is
real and worth raising later, once the idea has been fully heard. Phrases
are open questions about the idea, playing back what they heard, and asking
permission before adding ("Can I add a thought, or do you want to keep
going?").

### different-views: Different views, same table

Scenarios where the user and someone they like, love or work with hold
opposing political or social views: a relative at a holiday meal, a
neighbour with a yard sign, a colleague's comment at lunch, an old friend's
post. The defensive pull is to quietly write the person off once their
politics show, or to answer a view with the user's own position until it
becomes an argument or a cold silence. Generous thinking keeps the whole
person in view (the good the user already knows about them), gets curious
about the experiences and values under their view, notices shared values
underneath (safety, fairness, family, freedom), and lets the user hold their
own beliefs firmly without needing to win this conversation. Phrases ask how
they came to see it that way, name what the user values about them, find
the shared value, and state the user's own view as theirs without a debate.
Some takeaways can be about simply staying warm without discussing it.

**Even-handed:** never name a real party, politician, election or news
event; describe views generically ("strict on immigration", "wants stronger
gun laws", "thinks taxes are far too high"). Never use political labels
(progressive, conservative, liberal, left, right, or any party name), in the
scenarios or anywhere else. Put the user's own view on each side in half the
scenarios, give every view a sincere reason, and never write either side as
foolish, hateful or uninformed. The other person may stay unconvinced: the
goal is coexistence, not persuasion. Count the sides by topic and make the
split exact. State each view as a policy or a value, never as a claim that a
group of people is harmful, backward or dangerous, and never as a slogan
("rigged", "torn up"). Give each side a concrete personal reason in the
other person's reply. The other person never concedes a point of substance,
and never disclaims hostility the user had no reason to expect.

### Inner subjects (paste before the subject's own block)

This is an **inner** subject: the tricky moment happens inside the user, not
between them and another person. These rules replace the general
requirements where they differ.

- **The situation** is the user alone or nearly alone (other people may be
  in the background), 2 to 4 sentences, second person, present tense, with
  one concrete sensory detail. Everyday life only: a quiet evening, a work
  afternoon, a bathroom mirror, a phone in bed.
- **The first thought** is the harsh, impatient or numbing inner voice in
  the user's own words: relatable, not cruel, under 20 words.
- **Reframes** are thoughts the user could have about themselves and the
  part of them that is struggling. Cover: naming the feeling without
  judging it, being curious about what a part needs, the kindness a good
  friend would offer, room for two parts that want different things, what
  the feeling might be protecting, and seeing the moment from a wider view
  of their life. Avoid loaded words that rank one need above another (do
  not call work "productive" or "positive" while rest or feeling is
  "wasted").
- **Phrases** are things the user could say to themselves or to a part of
  themselves, out loud or silently: gentle, honest, specific. Not pep
  talks, affirmations or cheering up ("You're amazing!"); honest curiosity
  and warmth ("Something hurts here. I can stay with it a minute.").
- **Role-play**: the `partner` is a part of the user, named by what it
  feels or wants, followed by ", a part of you" ("The tired part, a part of
  you"). `opening` is what that part says, in its own voice. `partnerReply`
  is how it responds to being met with curiosity and kindness: it softens a
  little, or says what it needs; it is not magically fixed.
- **Safety:** no self-harm, eating, dieting, weight, alcohol or drugs, and
  no clinical language (no "trauma", "depression", "disorder"). This is
  everyday self-talk, not therapy.

### both-parts: Both parts are welcome

Scenarios where two parts of the user want different things and the result
is a stuck, wobbly middle: a part that wants to get on with work and a part
still processing a feeling, which shows up as procrastination; a part that
wants to say yes to an invitation and a part that needs a quiet night; a
part that wants to call a friend back and a part that is still hurt.
Generous thinking comes in as a calm, curious self that holds both parts
without forcing the work and without collapsing into the feeling, and that
treats caring for a feeling as just as worthwhile as getting things done.
Phrases speak to each part in turn ("I hear you want this finished. And I
hear you're still upset about this morning. Let's give that five
minutes.").

### kinder-mirror: A kinder mirror

Scenarios where the user sees themselves and an unkind thought arrives: a
mirror in the morning, a photo a friend posts, their face on a video call,
their reflection in a shop window, hearing their own voice in a recording,
a moment of feeling old, clumsy or out of place. Cheering up is not the
goal; the aim is to look at themselves with honest curiosity and
compassion, as a partner with their own body, mind and life. Generous
thinking notices the critic and its tone, wonders what it is trying to
protect, recalls what this body and face have carried them through, and
chooses to see rather than judge. Never mention weight, food, dieting or
changing their appearance; keep it to looking, ageing, tiredness, features,
voice and presence.

### turning-toward: Turning toward the feeling

Scenarios where the user notices themselves reaching for numbness to avoid
a feeling: scrolling a social feed, autoplaying the next episode, refreshing
the news, a phone game, busywork, tidying a drawer at midnight. Usually a
feeling they don't want to have is underneath (loneliness, dread, a sting
from earlier, boredom, grief). There is a part that needs to be seen, but it
is heading for oblivion. Generous thinking notices the pull without shaming
it (the numbing part is trying to help), gets curious about what feeling is
underneath, and sits with it kindly for a minute without spiralling. It is
fine not to put the phone down perfectly; the practice is noticing and
turning toward. Phrases are gentle invitations to the part and to the
feeling ("Hey. What are we running from right now?").
