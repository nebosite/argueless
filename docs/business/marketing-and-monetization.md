# ArgueLess: marketing and monetization plan

Status: exploratory draft, revised 2026-11-10 after web research. Nothing
here is decided. The original *(verify)* markers have been checked against
current sources and replaced with findings; source tags like [S1] point to
section 11. Benchmarks are category medians from other people's apps: they
set expectations, they do not predict ArgueLess. Two things are *not*
verified and are marked *(check)*: the trademark position on the name, and
the legal reading of the new age-verification laws.

## Research update: what changed and why

### The five findings that change the plan

1. **Almost nobody will reach the paywall as designed.** The plan shows the
   paywall when a user runs out of free scenarios. With 32 free scenarios
   and one or two a day, that is two to four weeks in. A typical health and
   fitness app has 3 to 5% of installers still active at day 30, and strong
   ones 8 to 12% [S7]. Meanwhile about half of all paid conversions in
   subscription apps happen on the day of install [S6]. A paywall that first
   appears in week three or four is shown to a small minority. **Change:**
   offer Plus early and gently (end of onboarding, and again after the first
   completed practice), while keeping the free tier free. See section 4.
2. **A generous free tier is a real trade, roughly five to one.** Across
   115,000 apps, freemium apps convert a median 2.1% of downloads to paid by
   day 35; hard-paywall apps convert 10.7%, and earn about eight times the
   revenue per install at day 60 ($3.09 against $0.38) [S6]. Keeping the
   reflection and a starter set free is right for the north star, and it is
   also the single largest cost in the model. Decide it knowingly (open
   question 7).
3. **Paid acquisition does not pay back at category-median numbers.** The
   median health and fitness app earns $0.48 per install by day 14 and $0.66
   by day 60 [S1][S3]; one-year value per install is about $1.21 [S5]. A
   median install from Apple Ads search costs about $3.77 in the US, and
   meditation and wellness installs run $4 to $10 on iOS [S8]. ArgueLess
   would need to monetise several times better than the median before paid
   installs break even. The "organic first, paid last" ordering in section 3
   is confirmed, and paid acquisition should be treated as unlikely in the
   first year rather than merely deferred.
4. **The price points were too low on monthly and about right on annual.**
   The health and fitness median is $9.99 a month and about $39.99 a year
   [S1][S35]. Direct competitors (AI role-play practice apps) cluster at
   $29.99 to $49.99 a year [S15]. Couples apps charge $70 to $120 a year for
   both partners [S13]. $39.99 a year holds; $5.99 a month should rise to
   $7.99 to $9.99 so that the annual plan is the obvious choice.
5. **"Private by design" is necessary but no longer distinctive on its
   own.** Mozilla found most mental-health apps fail basic privacy
   standards, and the FTC fined BetterHelp $7.8M for sharing health data
   with advertisers [S22], so the concern is real. But adjacent apps already
   say "private" and "stays on your device" in their listings [S32]. The
   claim only differentiates if it is *checkable*: the store privacy label,
   no account, no network permission. Adding RevenueCat changes that label
   (section 6.2). The stronger differentiator is the method: **think first,
   then words, then real life as the scoreboard, with no AI and no verdict
   on who was right.**

### Assumption check

| Assumption in the first draft | What the research found | Verdict |
|---|---|---|
| Stores take 15% from small developers | Apple: 15% under the Small Business Program, which needs enrolment and is not automatic [S9]. Google: 10% service fee plus 5% billing fee on subscriptions in the US, UK and EEA since 30 June 2026, so still 15% in practice [S10]. | Confirmed. Enrol with Apple before the first sale. |
| RevenueCat is free up to a threshold | Free up to $2,500 of monthly tracked revenue, then 1% of tracked (gross) revenue [S11]. | Confirmed. |
| Big wellness apps charge about $70 a year | Headspace $69.99 a year and $12.99 a month; Calm rose to $79.99 and $16.99 in February 2026; both sell a six-person family plan at $99.99 [S12]. | Confirmed. |
| $5.99 a month, $39.99 a year | Annual matches the category median; monthly is 40% below it [S1][S35]. | Revise monthly up. |
| 7-day trial on annual | Trials of 5 to 9 days convert a median 37.4%; 17 to 32 days convert 42.5% [S1]. Headspace gives 14 days on annual [S12]. | Fine to start; test 14 days. |
| Couples plan about $59.99 for two to six people | Couples apps normally cover both partners with one subscription at $70 to $120 a year [S13]. Apple can share a subscription through Family Sharing; Google Play cannot share subscriptions or in-app purchases at all [S18]. | Price is plausible. Sharing needs our own mechanism on Android. |
| B2B at $3 to $6 per seat per month | Headspace and Calm sell to small teams at about $56 to $70 per person per year; large-company rates fall to $12 to $36 per person per year [S16]. | Top of the range for small teams; expect less at scale. |
| B2B can be invoiced outside the stores | Apple guideline 3.1.3(c) allows it for apps sold directly to organisations; consumer, single-user and family sales must use in-app purchase [S17]. | Confirmed. |
| Age rating 12+ or Teen | Apple replaced 12+ and 17+ with 13+, 16+ and 18+ in 2025; a new questionnaire is mandatory [S19]. | Outdated. Expect 13+ or lower; the questionnaire decides. |
| Self-help apps lose most users in a month | Median day-30 retention 3 to 5%; strong apps 8 to 12% [S7]. | Confirmed, and worse than "most". |
| Holiday and New Year are good timing hooks | Health and fitness installs rose 46% on 1 January 2025 against the December baseline, with the climb starting on 26 December [S27]. | Confirmed. January is the one hook with hard data. |
| Short-form video is a cheap channel | Plausible, but the evidence is vendor case studies. Organic lift typically shows after three to six months of posting three to five times a week [S33]. | Unproven; cheap in money, not in time. |
| Coaches and therapists will recommend it | Between-session homework is common but uneven: 41% of surveyed providers assign it "never" to "sometimes", and clients complete about half [S29]. | Plausible, small. Lead with coaches, not clinicians. |
| Spanish, German, Portuguese first | Paying users are worth about $32 a year in North America, $25 in Western Europe and $23 globally [S34]; the US is roughly half of category spending [S27]. | Deprioritise. English markets first. |
| The method works | Good evidence for the ingredients, none for this app. See section 3, "What we can honestly claim". | Supported in principle. |

### The market in one paragraph

About 14,700 new subscription apps launch every month. The median one earns
under $500 a month, and the top 10% take roughly 95% of the revenue
[S34]. Health and fitness is the best-monetising category per install, and
the only one where annual plans dominate revenue (about 60%) [S5]. It also
has weak renewal: a median 25% of annual subscribers renew at the end of
year one, 37% for the upper quartile [S2], and 35% of annual cancellations
happen in the first month [S4]. Subscribers who are still *active* in the
second half of their year renew at about 86% [S1]. That last number is the
case for the weekly scenario drop: its job is not to sell the subscription
but to keep subscribers using the app until renewal.

## 1. The idea in one paragraph

ArgueLess is a daily practice app: a few minutes a day spent reframing a
tricky moment, finding words for it, and role-playing them, plus a nightly
reflection that counts how real life went. The proposal is a **freemium app
with a subscription that delivers fresh scenarios on a regular schedule**,
with themed packs for the people who need them most. The scenarios are the
product's renewable fuel. Without new ones, a daily habit runs out of
material in a few weeks. That makes a content subscription the natural model,
rather than an arbitrary paywall.

### What we are selling, and what we are not

- **Selling:** a habit that makes hard conversations feel less threatening,
  with visible progress in real life (the reflection chart).
- **Not selling:** therapy, conflict resolution for unsafe relationships, or
  "win every argument" tactics. The positioning must stay on the north star
  (cooperative, not threatening) and must not drift towards persuasion or
  manipulation, which is a crowded and off-brand market.

### Constraints the plan must respect (from CLAUDE.md)

1. **Private by default.** Ideas, replies and reflections never leave the
   device. Monetization cannot depend on user data: no ads, no data sales, no
   behavioural profiling. This is also a marketing asset (see section 3).
2. **Small and daily.** Paid features must not make sessions longer.
3. **Kind.** Paywalls, streaks and upsells must never feel like a scolding.
   No guilt notifications, no "your streak will die" pressure.
4. **Not therapy.** Packs stay on everyday friction. Clinical claims would
   also bring regulatory and app-store scrutiny.

## 2. Market segments

Scored on four things: **pain** (how often they hit friction that matters),
**willingness to pay**, **reachability** (can we find them cheaply), and
**fit** (does a five-minute reframe-and-phrase drill actually help them).

| Segment | Pain | Pay | Reach | Fit | Notes |
|---|---|---|---|---|---|
| Self-improvement habit builders | Med | High | High | High | Already pay for Headspace, Duolingo, Fabulous. Respond to streaks and progress. **Launch beachhead.** |
| Couples and partners | High | High | Med | High | Recurring friction at home; "practise together" is a strong hook. Strong word of mouth. |
| New and mid-level managers | High | Med (High if employer pays) | Med | High | Feedback, disagreements, steamrolled teammates. The *rebuttal* and *confusion* subjects map directly. Path to B2B. |
| Parents of teens | High | Med | Med | High | Confusion-as-signal and noticing emotion fit perfectly. Reached through parenting communities and podcasts. |
| Front-line and customer-facing staff | High | Low (personal), Med (employer) | Low | Med | Retail, hospitality, call centres, healthcare reception. Mostly a B2B sale. |
| Healthcare and education workers | High | Med | Med | Med | Patients, parents, colleagues under stress. Burnout angle. Careful: never position as a clinical tool. |
| Coaches, counsellors, therapists (as a channel) | n/a | Med | Med | High | They assign "homework" between sessions. Not customers so much as recommenders. A coach licence could pay. |
| Conflict-averse or socially anxious adults | High | Med | Med | Med | Real need. Risky edge: must not become a substitute for clinical help. Market as practice, not treatment. |
| Online-argument-prone people | Med | Low | High | Med | Large audience, low spend. Good for top-of-funnel content (short videos), not revenue. |
| Faith and community groups | Med | Low | Med | Med | Group study and small-group use. Later, if at all. |
| Students and young adults | Med | Low | High | Med | Room-mates, group projects. Low spend; student pricing if pursued. |

### What the research adds to the segment table

- **Self-improvement habit builders.** Comparable apps charge $40 to $80 a
  year: Fabulous about $39.99, Finch Plus about $47.99 (with a generous free
  tier and a deliberately low-pressure tone, the closest tonal neighbour),
  Headspace $69.99, Calm $79.99 [S12][S14]. These users arrive in a
  predictable wave from 26 December through January [S27]. They are also
  the users behind the 3 to 5% day-30 retention figure, so the beachhead is
  reachable but leaky.
- **Couples.** Willingness to pay is proven: Paired reports 8 million
  downloads and charges about $79.99 a year for both partners; Lasting lists
  $119.99 a year [S13]. Two cautions. Every incumbent prices per couple, so
  a couples pack must cover both people. And couples apps depend on both
  partners taking part; reviewers name the unengaged partner as the main
  failure. ArgueLess has an advantage here: **one partner practising alone
  still gets the benefit**, because the practice changes how *they* think
  and speak. Market the couples pack as "works even if only you use it",
  and make practise-together an extra rather than the core.
- **New managers.** The need is well documented, though the headline
  statistics vary a lot by survey (40% to 85% of new managers report no
  formal training; the Center for Creative Leadership figure is 60%)
  [S28]. Quote a range, not one number. The space is also where the funded
  competition is: Yoodli, VirtualSpeech and others sell AI role-play for
  feedback and conflict conversations to L&D teams [S15].
- **Coaches and therapists.** Homework between sessions is standard
  practice in cognitive-behavioural work, and "interpersonal skills" and
  "cognitive reappraisal" are among the exercises providers assign [S29].
  But a therapist channel pulls the positioning toward treatment. Lead with
  coaches, couples educators and workplace trainers; accept therapist
  referrals without marketing to them.

### Competitive landscape

Nobody found in this research does exactly what ArgueLess does. The nearest
neighbours fall into four groups:

| Group | Examples | Price | How ArgueLess differs |
|---|---|---|---|
| AI role-play rehearsal (consumer) | Prehearse, Assertr, Hard Talk, Vocal Image | $29.99 to $49.99 a year, often with a weekly plan at $4.99 to $5.99 [S15] | They rehearse one upcoming conversation, by voice, in the cloud. ArgueLess builds a daily habit, starts with the thinking, and is offline. |
| AI role-play (workplace) | Yoodli, VirtualSpeech | $8 to $45 a month per user [S15] | Sold to L&D with scoring and analytics. ArgueLess never grades. |
| Couples connection | Paired, Lasting, Agape | $70 to $120 a year per couple [S13] | Daily questions and courses about the relationship. ArgueLess trains one person's reactions and works across home and work. |
| AI "who is right" and argument analysers | Arguelyzer, ArgueResolver, Argument, Whose Fault? [S32] | Mostly in-app purchases | They judge a past argument from pasted chats. ArgueLess is the opposite promise: no verdicts, no uploaded chats. |

One to watch: *After the Argument* (announced, not yet released) pitches a
private ten-minute ritual after a fight and a chart of recovery time, with
"private by design" in its copy [S32]. It is the closest in spirit.

**What this means for positioning.** The AI apps answer "help me with this
one hard conversation". ArgueLess answers "help me become someone who has
fewer of them". That is a habit product, which is why it belongs next to
Headspace and Finch in pricing and tone rather than next to the rehearsal
tools, and why "Prepare for a real conversation" (feature 7) matters: it is
the bridge to the need the AI apps have already proven people will pay for.

### Recommended focus

1. **Primary (launch): self-improvement habit builders.** They find apps in
   the store, understand subscriptions, and value streaks and progress. The
   current four subjects already serve them.
2. **Secondary (first paid packs): couples and parents of teens.** High pain,
   high emotional payoff, and each adds a distinctive feature (practising
   together, a teen-specific pack).
3. **Expansion (B2B): new managers, then front-line teams.** Same engine,
   workplace packs, sold per seat to L&D and HR budgets. Higher revenue per
   customer but a slower sale; do it once the consumer product retains well.
4. **Channel: coaches and therapists.** Cheap to court and they bring
   motivated users. A simple "recommended by your coach" code is enough at
   first.

## 3. Positioning and marketing

**One-line pitch:** *"Five playful minutes a day to make hard conversations
feel less like a fight."*

**Three messages:**

- **Practice, not lectures.** You do the thinking; the app is the sparring
  partner. (Contrast with books and courses people never finish.)
- **Real life is the scoreboard.** The nightly reflection shows fewer
  conflicts and more turned-around moments over time. This is the
  screenshot to put in the store listing.
- **Private by design.** Nothing you write leaves your phone. In a category
  where people type about their partner, boss and kids, this matters, and
  the category's record is poor [S22]. But competitors say "private" too
  [S32], so make it checkable: no account, no sign-in, works in flight
  mode, and a store privacy label that says what we say. Use it as proof of
  character, not as the headline. The headline is the method.

**Channels, cheapest first:**

1. **App store optimisation.** Keywords around communication, conflict,
   relationships, workplace, mindfulness. Screenshots of a scenario, the
   role-play bubble and the progress chart.
2. **Short-form video.** "First thought vs. reframe" is a ready-made format:
   the defensive thought, then three generous reframes, in 20 seconds. The
   scenario library is an endless source of these. Each post links to the
   free app.
3. **Shareable scenario cards.** An optional "share this scenario" image (the
   situation and a suggested reframe, never the user's own words). Turns
   content into marketing without touching private data.
4. **Newsletter / blog.** A weekly "scenario of the week", mirroring the
   subscription drop. Builds an audience before any paid spend.
5. **Coach and therapist outreach.** A one-page PDF and free coach codes.
6. **Podcasts and parenting / relationship creators.** Sponsorships or
   affiliate codes once conversion numbers are known.
7. **Paid acquisition.** Only after trial-to-paid conversion and retention
   are measured, so the cost per acquisition can be judged.

**Timing hooks:** the holiday season (family friction), New Year
(self-improvement), Valentine's Day (couples), back to school (parents of
teens), performance-review season (managers).

Only New Year has hard data behind it. Health and fitness installs dip on
24 and 25 December, start climbing on the 26th, and were 46% above the
December baseline on 1 January 2025; January is the category's best month
for both downloads and revenue [S27]. Two consequences:

- **Be in the stores, with a tuned listing, by 26 December.** For this
  year that means the free app only. A new personal Google Play account
  must first run a closed test with at least 12 testers opted in for 14
  continuous days before it can apply for production access, and the
  review after that usually takes about a week [S30]. Counting back from 26
  December, the closed test has to start by about **1 December 2026**.
  If that is too tight, do not rush it: target iOS for the New Year window
  and Android when ready.
- **January users churn fastest.** They arrive on a resolution and leave
  with it. Do not judge retention on the January cohort alone, and do not
  spend money acquiring it.

**Notes on the channels, from the research:**

- *App store optimisation.* The "argue" namespace is busy with AI verdict
  apps and "win arguments" apps [S32]. The subtitle has to do the
  positioning work the name cannot: lead with *calmer conversations* and
  *daily practice*, and keep "argument" out of the keyword set where it
  attracts the wrong searcher.
- *Short-form video.* Treat as a time-boxed experiment, not a plan: for
  example 20 videos over six weeks, with a stop rule. The supporting
  evidence is vendor case studies; expect three to six months before
  organic posting moves installs [S33]. YouTube Shorts and Reels reuse the
  same clips at no extra cost.
- *Borrowed audiences.* Jefferson Fisher's 2025 book *The Next
  Conversation: Argue Less, Talk More* [S32] shows a large audience for
  this exact promise, built on short video. People who follow that kind of
  content are the natural first audience; the phrase overlap with the app
  name helps discovery and is also a reason to check the trademark
  position *(check)*.
- *Paid acquisition.* See the unit economics in section 8. Not before the
  app earns well above $1 per install.

### What we can honestly claim

The ingredients are well studied; the app itself is not. Use the first
kind of sentence, never the second.

| Ingredient | Evidence | Safe to say |
|---|---|---|
| Reframing a conflict (cognitive reappraisal) | In a randomised study of 120 married couples, three seven-minute writing exercises a year, reappraising a recent conflict from a neutral observer's view, stopped the usual decline in marital quality [S23]. A meta-analysis of 30 trials of reappraisal delivered by phone found a small-to-medium benefit across mental-health outcomes, but no clear effect on general wellbeing [S24]. | "Built on reappraisal, a technique studied for decades." |
| Producing ideas before seeing suggestions | The generation effect: across 86 studies, people remember what they generate better than what they read, by about 0.4 standard deviations [S25]. | "You think first, because that is what sticks." |
| Role-play and rehearsal | Rehearsal with feedback improves communication skills in training settings, but gains shrink when moving from role-play to real people [S26]. | "Practice makes the words easier to find." |

- **Do not say** "clinically proven", "reduces conflict by X%", or
  anything about anxiety, depression or treatment. Paired's "89% see
  positive changes" is its own internal figure [S13]; copying that style
  invites the scrutiny it attracts.
- **The transfer gap is the product's reason for the reflection.** The
  research says skills fade between practice and real life. The nightly
  reflection is the part of the design aimed at that gap, which is a
  genuine and defensible story.
- **A content idea from the evidence:** the neutral-observer reframe from
  the couples study ("how would someone who wants the best for both of you
  describe this?") deserves to be a named, recurring reframe type.
- **Later, if the app retains:** an opt-in before-and-after survey, or a
  small study with a university partner, would turn "built on" into
  "tested". It costs little and is the only route to a real efficacy claim.

## 4. Monetization model

### Recommended: freemium plus subscription

**Free forever:**

- The four core subjects with a starter set of scenarios (the current 32, or
  a subset of them).
- Daily reflection and the progress chart, in full. The reflection is the
  measure that matters (north star), so it must never be paywalled.
- Streak and today's totals.

**ArgueLess Plus (subscription):**

- **New scenarios every week** across the core subjects (for example, four
  to eight a week), so daily practice never runs dry.
- **Themed packs** as they ship: Couples, Parents of teens, At work, Family
  holidays, Customer-facing, Online.
- Paid-only features as they arrive (section 5): the phrasebook drill, voice
  role-play, practise-together for couples, deeper progress insights.
- The whole back catalogue, not just this week's drop. Subscribers who join
  late get everything.

**Price points to test** (checked against comparable apps, November 2026):

- Monthly: **$7.99**, with $9.99 as the test arm. The category median is
  $9.99 [S1]; a low monthly price mostly cannibalises the annual plan.
- Annual: **$39.99**, the default offer, shown as a monthly equivalent
  ($3.33). This is the category median and sits in the middle of the
  direct competitors' $29.99 to $49.99 [S15][S35].
- Free trial on the annual plan: start at **7 days**, and test 14. Longer
  trials convert better in the benchmark data [S1], and a habit product
  needs more than a week to show progress on the chart. Headspace uses 14
  days on annual and 7 on monthly [S12].
- **No weekly plan.** Weekly plans now produce more than half of all
  subscription app revenue and the role-play competitors use them, but
  they churn fastest [S5]. They also sit badly with "kind".
- Couples plan: **$59.99 a year covering two people**, below Paired
  ($79.99) and Lasting ($119.99) [S13]. A six-person family plan is a
  different product (Headspace and Calm both charge $99.99 [S12]) and can
  wait for the parents-of-teens pack.
- For reference: Headspace $69.99 a year, Calm $79.99, Finch Plus about
  $47.99, Fabulous about $39.99 [S12][S14]. Being narrower and cheaper
  than the big two, and level with the habit apps, is the right place.
- Run price tests through the billing SDK's experiments rather than by
  editing store prices; expect to need a few hundred trial starts per arm
  before the result means anything.

**Store fees.** Budget on **15% in both stores**, confirmed:

- *Apple:* 15% under the App Store Small Business Program (under $1M a
  year in proceeds). Enrolment is a form in App Store Connect and is **not
  automatic**; do it before the first paid sale [S9]. Outside the
  programme the rate is 30% in a subscriber's first year and 15% after.
- *Google:* since 30 June 2026 in the US, UK and EEA the subscription fee
  is a 10% service fee plus a 5% billing fee when using Play Billing; the
  older flat 15% applies elsewhere. Either way, 15% [S10].
- *RevenueCat*, if used: nothing up to $2,500 of monthly tracked revenue,
  then 1% of tracked revenue, which is measured before the stores' cut
  [S11].
- *Later option:* on the US App Store, apps may now link out to a web
  checkout, currently with no Apple commission while the courts settle a
  rate [S17]. It is worth knowing about and not worth building yet: it
  brings our own payment processing, refunds and cancellation law (section
  6.8), and the rate may change.

### What the model earns, roughly

Illustrative only, using category medians [S1][S3][S5]. Per 1,000 installs
of a median health and fitness subscription app: about 69 start a trial and
about 29 are paying by day 35. A freemium app with a generous free tier
should expect fewer, nearer 20 [S6]. At $39.99 with most choosing annual,
that is roughly **$0.50 to $1.20 of revenue per install in the first
year**, before the 15% store fee.

| Goal | Installs needed per month, at about $1 of revenue per install |
|---|---|
| Cover costs (developer accounts, hosting, domain): about $50 a month after fees | about 60 |
| The median subscription app's revenue: about $500 a month [S34] | about 500 |
| $2,500 a month before fees (where RevenueCat starts charging) | about 2,500 |

These are the numbers behind open question 1. A side project that pays for
itself is realistic on organic installs. A business needs either thousands
of organic installs a month or conversion well above the median.

### Alternatives considered

| Model | Verdict |
|---|---|
| Paid up-front | Simple, but no recurring revenue to fund new content. Hard to sell an unknown app. Reject. |
| One-off pack purchases only | Works for a small catalogue, but caps revenue and fragments the library. Offer as a supplement later if subscribers ask for "just the couples pack". |
| Ads | Breaks the private-by-default promise and the calm tone. Reject outright. |
| Lifetime purchase | Useful as a launch promotion for early fans (for example, $79.99, limited time). Risky as a permanent offer because content costs keep coming. |
| B2B per-seat licences | Yes, as phase 3 (section 7). Roughly $3 to $5 per seat per month for small teams, falling to $1 to $3 at scale: Headspace and Calm list about $56 to $70 per person per year for small teams and $12 to $36 for large ones [S16]. Sell from a training budget, not a wellness budget; role-play training tools charge far more per user [S15]. |

### Paywall tone

- **Offer Plus early and kindly, twice at most.** A skippable screen at the
  end of onboarding ("Here is what Plus adds. The free app is yours either
  way."), and one more after the first completed practice, when the user
  has just felt the value. About half of paid conversions in subscription
  apps happen on day 0 [S6], and most installers are gone before they would
  ever exhaust 32 scenarios [S7]. Waiting for the catalogue to run out
  hides the offer from nearly everyone. Both screens must have an obvious
  "Not now" that is the same size as the purchase button.
- After that, the paywall appears only when the user runs out of free
  scenarios in a subject, opens a locked pack, or taps a Plus feature.
  Never mid-practice, never after a reflection, and never as a
  notification.
- Copy is an invitation, not a loss: "Fresh scenarios every week" rather
  than "You've run out".
- A user who never pays can keep practising: once they finish the free
  scenarios, they get repeats (the picker already favours the oldest
  played). The free app stays useful.

## 5. Product features for the target segments

Each feature is tagged with the segments it serves, its tier, and a rough
size (S, M or L). Ordered within each group by expected value.

### For everyone (retention)

1. **Phrasebook and quick drill** (Plus, M). A personal collection of the
   phrases the user liked or wrote, with a 60-second "flashcard" drill using
   spaced repetition. It turns practice into words that come to mind in the
   moment. It is the most direct bridge from practice to real life.
2. **Gentle daily reminder** (Free, S). A local notification at a time the
   user picks. Warm copy, no streak guilt, easy to turn off. No server
   needed.
3. **Weekly look-back** (Free, S). Once a week: "3 turned-around moments
   this week, up from 1." Celebrates progress without grading.
4. **Home-screen widget** (Free, M). Today's scenario title, or the streak.
   A cheap way to stay visible.
5. **Onboarding that asks where friction shows up** (Free, S). Work, home,
   partner, kids, online. Used only on the device to order subjects and
   suggest packs. This is also the moment to pitch the matching pack.
6. **Voice role-play** (Plus, M). Say the reply out loud and the device
   transcribes it, using on-device speech recognition so nothing is
   uploaded. The app already asks people to say it out loud; this rewards
   them for doing it.
7. **"Prepare for a real conversation"** (Plus, L). The user picks a
   template (feedback to a colleague, asking a partner for help, a hard talk
   with a teen) and fills in a few private fields, then runs the same
   reframe → phrases → role-play flow on it. No AI needed in a first
   version: the generic suggestions come from the pack. This is the feature
   that turns the app from practice into a tool for real conversations.

### For couples

8. **Practise together** (Plus, L). Both partners play the same scenario,
   then optionally compare favourite phrases by showing one phone to the
   other, or exchanging a share code. No server-side shared data in a first
   version. Note the billing catch in section 6.2: one subscription for two
   people is the category norm, and Google Play cannot share one.
9. **Couples pack** (Plus, content). Chores, money, in-laws, plans, tone of
   voice, screen time. Written from both sides.

### For parents of teens

10. **Parents of teens pack** (Plus, content). Curfews, phones, school,
    slang, slammed doors. Strong fit for *confusion is a signal*.

### For managers and workplace users

11. **At-work pack** (Plus, content). Feedback, meetings, being interrupted,
    pushing back upward, steamrolled teammates.
12. **Team edition** (B2B, L). Org codes that unlock Plus for staff, the
    company's own scenarios, and an admin view of *aggregate, opt-in*
    usage only (active users, practices completed). Never anyone's ideas,
    replies or reflections. Section 6 covers the privacy design.

### For coaches and therapists

13. **Coach codes** (Channel, S). A redeemable code that unlocks a trial or a
    pack, with simple attribution so the coach can be rewarded.
14. **Printable / PDF scenario sheets** (Coach tier, S). For sessions and
    workshops.

### Later, if the data supports it

15. **AI role-play partner** (Plus, L). A live, multi-turn role-play instead
    of a single scripted reply. Powerful, but it breaks "nothing leaves the
    device" unless it runs on-device or the user explicitly opts in with
    clear wording. Revisit when on-device models are good enough, or offer
    as a clearly labelled opt-in. Research note: this is exactly what the
    direct competitors sell, at $30 to $50 a year [S15], and AI apps in
    general convert better but churn about 30% faster than others [S4].
    Not having it is a position ("no AI, nothing uploaded"), not just a
    gap; decide which before building it.
16. **Localisation** (M per language). Scenarios are culture-specific; this
    means rewritten packs, not translations. Not soon: the US is about
    half of category spending and North American subscribers are worth
    roughly 30% more than Western European ones [S27][S34]. Cover the
    English-speaking stores first (US, UK, Canada, Australia), with UK
    spelling and scenarios checked for American readers. German is the
    most plausible second language when the time comes.

### Deliberately not building

- Social feeds, leaderboards or public profiles. They conflict with privacy
  and with "kind, never a grade".
- Scoring the user's answers. Self-rating is the design; automatic grading
  would feel like judgement.
- Anything for unsafe relationships. Out of scope by the north star.

## 6. Technical requirements

The current app is fully offline: content ships in `app/assets/content/`,
and it uses no network. A content subscription changes that, so the main
design rule is: **the network carries content and receipts in, never user
data out.**

### 6.1 Content delivery

- **Packs as static files on a CDN.** Each pack is a JSON file in today's
  format (schemaVersion 1), plus a signed **manifest** listing packs, their
  versions, hashes, entitlement (`free`, `plus`, `pack:<id>`) and minimum app
  version. Static hosting (Cloudflare R2/Pages, S3 + CloudFront, Firebase
  Hosting) is cheap and needs no application server.
- **A `CompositeContentSource`** behind the existing `ContentSource` seam:
  bundled assets plus downloaded packs merged into one `ContentLibrary`. The
  screens do not change, which is what the seam was built for.
- **An offline cache** in app-private storage, written with
  `AtomicJsonFile`. The app always works offline with whatever it last
  downloaded. Download on launch (rate-limited) and from a manual refresh.
- **Integrity.** HTTPS plus SHA-256 hashes from the manifest. Sign the
  manifest (for example, with Ed25519) so a tampered CDN cannot inject
  content. A pack that fails validation is ignored, never half-loaded.
- **Scenario ids** become pack-namespaced (`couples/cp-01`) or stay globally
  unique by prefix. The existing rule holds: ids are permanent; retiring a
  scenario removes it; saved records keep their own text.
- **Schema evolution.** The manifest's minimum-app-version field stops old
  apps from downloading packs they cannot read. Bump `schemaVersion` only
  for breaking changes, as now.
- **Subjects from packs.** Packs need to be able to add subjects (Couples
  might be a new subject) or add scenarios to existing ones. `ContentLibrary`
  needs to merge both.
- **Locked content.** The library knows about locked scenarios (for the
  paywall and "coming in Plus"), but the picker only serves unlocked ones.
  Fetch only the titles of locked packs, so the content itself stays
  behind the entitlement.

### 6.2 Subscriptions and entitlements

- **Store billing:** StoreKit 2 (iOS) and Google Play Billing (Android).
- **Recommendation: RevenueCat** (or a similar SDK) rather than building
  receipt validation ourselves. It handles both stores, trials, restore,
  family sharing on iOS, and webhooks. It is free up to $2,500 of monthly
  tracked revenue, then 1% [S11]. It stores an anonymous app-user id and
  the purchase receipts, not user content. Disclose it in the privacy
  policy.
- **The privacy-label cost of that choice.** Today the app can truthfully
  show Apple's "Data Not Collected" label, the strongest possible proof of
  the privacy promise. RevenueCat's own guidance says an app using it must
  declare "Purchases" as collected; with anonymous ids only, it can be
  marked as not linked to identity [S11]. The label would then read "Data
  Not Linked to You: Purchases". That is honest and modest, but it is no
  longer the empty label. The alternative is the stores' own billing APIs
  with on-device verification (Flutter's `in_app_purchase`), which sends
  nothing to a third party but gives up cross-store dashboards, price
  experiments and easy entitlement sharing. **Recommendation:** still
  RevenueCat, because measuring conversion matters more in year one, with
  the About page wording changed to "your words never leave your phone;
  the store and our billing provider know only that a purchase happened".
  Revisit if the empty label proves to be a selling point.
- **Sharing one subscription between two people.** Apple lets a developer
  switch on Family Sharing for auto-renewing subscriptions. Google Play's
  Family Library does not share subscriptions or in-app purchases [S18].
  So a couples plan that works on Android, or across an iPhone and an
  Android phone, needs our own mechanism: a pairing code that grants the
  partner a promotional entitlement through the billing provider. That
  needs a small server function and an identifier for the partner, which
  must be designed so it carries no user content. Size this with feature 8
  before promising a couples price.
- **No account required.** Entitlement comes from the store account. Restore
  purchases from Settings. This keeps the privacy story simple.
- **Content protection.** Plus packs are served from signed, short-lived
  URLs issued after an entitlement check (a tiny serverless function that
  asks RevenueCat), or simply left unprotected at first. Determined people
  can copy any client-side content; the value is the steady stream of new
  content, not secrecy. **Recommendation:** start unprotected-but-unlisted
  and add signed URLs if leakage becomes a measurable problem (YAGNI).
- **Entitlement seam:** an `Entitlements` interface in core
  (`isUnlocked(packId)`), with a store-backed implementation in the app and
  a fake in tests.
- **Store compliance:** clear price and renewal terms on the paywall, links
  to the terms and the privacy policy, restore button, trial terms, and
  cancellation instructions. Both stores reject paywalls that miss these.

### 6.3 Content pipeline (making a weekly drop)

1. Generate a batch from `docs/content/prompts/scenario-batch.md` (plus new
   pack-specific prompts, kept in the same folder).
2. Automated checks: the existing `shipped_content_test` rules, run against
   the batch (word limits, six reframes, six phrases, id format, no reuse).
3. Review: the `cora` and `grace` agents, then a **human read of every
   scenario** before release. AI-generated content about relationships and
   emotions needs human eyes; one bad scenario in a paid drop costs trust.
4. Publish: upload the pack, update and sign the manifest. A small script
   (`tool/publish_pack.dart`) does this.
5. Schedule: write drops a few weeks ahead so a missed week never happens.

At four to eight scenarios a week, this is a few hours of review per week:
the main ongoing cost of the business.

### 6.4 Notifications

- **Daily reminder:** local notifications only (`flutter_local_notifications`).
  No server, no push token.
- **"New scenarios this week":** also a local notification, scheduled when the
  manifest shows a new drop. Remote push (FCM / APNs) is only needed if
  timing must be exact. It also adds a device token to a server, so avoid it
  at first.

### 6.5 Measuring the business without breaking privacy

We need retention and conversion numbers, but the app promises nothing
leaves the device. Options, in order of preference:

1. **Store analytics** (App Store Connect, Play Console) and **RevenueCat**
   dashboards: installs, trials, conversion, churn. No code needed.
2. **Opt-in, anonymous, aggregate counters** (for example, TelemetryDeck,
   which is privacy-focused, or a self-hosted equivalent): "practice
   completed", "reflection saved", "paywall shown". Never content, never
   counts from the reflection itself. Off by default, or on with a clear
   first-run choice. Either way, the About page's "Your data" copy must
   be updated to say exactly what is sent.
3. **Crash reporting** (Sentry or Firebase Crashlytics), opt-in, with
   breadcrumbs that never include user text.

### 6.6 Data safety for paying users

People who pay will be upset if a phone change wipes their history.

- **Decide the Android auto-backup question** (open in CLAUDE.md). Options:
  allow Google backup for the two files (convenient, but it leaves the
  device; on Android 9 and later with a screen lock set, the backup is
  end-to-end encrypted with a key Google does not hold, and the manifest
  can require that [S31]), or exclude them and
  offer an **export/import file** instead. **Recommendation:** export/import
  first (it fits "private by default"), and let iCloud / Google backup be an
  explicit setting the user turns on.
- iOS: by default, files in the documents directory go into iCloud backup.
  Same decision, same setting.

### 6.7 B2B (phase 3)

- **Org codes** redeemed in-app, which grant Plus through the entitlement
  layer (RevenueCat promotional entitlements, or our own small service).
- **Custom content:** the company's own packs, delivered by the same
  manifest system, visible only to its codes.
- **Admin dashboard:** a small web app showing aggregate, opt-in counts per
  org, with a minimum group size (for example, no figures for groups under
  five) so no individual can be singled out.
- **Invoicing:** Stripe, outside the app stores. Apple's guideline
  3.1.3(c) allows this for apps sold directly to organisations for their
  employees; consumer, single-user and family sales must still use in-app
  purchase [S17]. Keep the two clearly separate: an org code unlocks, it
  never sells.
- SSO and MDM only if a large customer requires them.

### 6.8 Legal and policy

- Privacy policy and terms (required for subscriptions in both stores).
- A wellness disclaimer: practice tool, not therapy or medical advice; the
  "Everyday friction only" text already on the About page.
- **Age rating.** Apple's tiers are now 4+, 9+, 13+, 16+ and 18+; the old
  12+ and 17+ are gone, and every app must answer a new questionnaire that
  includes medical and wellness topics [S19]. Expect 13+ or lower. Google
  uses its own questionnaire.
- **App store age-verification laws** *(check with a lawyer before selling
  subscriptions)*. Texas's App Store Accountability Act has been
  enforceable since late May 2026 while its appeal continues; Utah,
  Louisiana and Alabama have similar laws, with California's following
  [S20]. Stores must verify ages and pass an age category and parental
  consent status to apps; developers must rate the app and each in-app
  purchase, and use the signal they receive. Both stores now provide an
  API for it. For an app aimed at adults the practical work is likely
  small (read the signal, do not sell to a minor without the store's
  consent flag), but it is new, state-specific and still in court.
- **Subscription and cancellation law.** The FTC's "click-to-cancel" rule
  was struck down in July 2025 and is not in force; a new rulemaking began
  in March 2026. The older federal law (ROSCA) and state auto-renewal laws
  still apply, California's being the strictest: clear terms before
  purchase, express consent, renewal reminders for annual plans, and
  cancellation as easy as sign-up [S21]. Store billing handles the
  cancelling and most of the reminders; the paywall copy is ours to get
  right. A web checkout would make all of it ours.
- **Health claims.** See "What we can honestly claim" in section 3. Claims
  about outcomes need evidence about this product.
- Store data-safety forms: currently "no data collected"; this changes with
  RevenueCat, analytics or crash reporting, and must be kept accurate.
- GDPR / CCPA: minimal exposure while content stays on the device. Opt-in
  analytics need consent, and B2B needs a data-processing agreement.

## 7. Phased roadmap

Each phase ends with a go/no-go decision based on numbers, not on schedule.

| Phase | What ships | Exit test |
|---|---|---|
| **0. Polish and soft launch (free)** | Dark-mode fix, launcher icon, onboarding, daily reminder, privacy policy, backup decision, closed testing on Play (12 testers for 14 continuous days is a store requirement for new personal accounts [S30]), then TestFlight. Store listing live by 26 December if achievable. Name and trademark check. | Testers practise on 3+ days in their first week; qualitative feedback says the scenarios feel real. Then, on public installs: day-1 retention of 25% or more and day-7 of 10% or more. |
| **1. Content subscription** | Manifest and CDN packs, `CompositeContentSource`, entitlements via RevenueCat, paywall, weekly drops, pack pipeline. Phrasebook drill as the first Plus-only feature. | Day-30 retention of 8% or more (category median is 3 to 5%). At least 5% of installs start a trial, at least 35% of trials convert, and at least 2% of installs are paying by day 35 (targets in section 8). If retention passes and conversion fails, change the offer, not the product. |
| **2. Segment packs** | Couples, Parents of teens and At work packs; practise-together; voice role-play; "prepare for a real conversation". Marketing aimed at each segment. | One pack clearly outsells the others; use it to choose the B2B and marketing focus. |
| **3. Teams (B2B)** | Org codes, custom packs, aggregate dashboard, Stripe invoicing. Pilot with 2–3 friendly organisations. | Pilots renew, or say what would make them renew. |
| **4. Optional AI** | AI role-play partner or personalised scenarios, on-device or clearly opt-in. | Only if users ask for it and the privacy design holds up. |

## 8. Metrics to watch

- **Activation:** finished first practice; saved first reflection.
- **Habit:** practice days per week; day-1, day-7, day-30 retention.
- **North star (self-reported, local):** share of moments that were
  automatic or turned around, trending up. This stays on the device. At
  most, an opt-in anonymous "trend up / flat / down" signal, and only if
  we decide we need it.
- **Revenue:** trial starts, trial-to-paid, monthly vs. annual mix, churn,
  refund rate, revenue per pack.
- **Content health:** scenarios skipped or abandoned mid-practice (opt-in
  counter), and the rating distribution, which shows whether the
  suggestions feel useful.

### Benchmarks and first targets

Medians are for health and fitness subscription apps unless stated. The
target column is where ArgueLess should aim, set a little under the median
where the free tier costs conversion and above it where the product should
be strong.

| Metric | Category median | Strong | First target |
|---|---|---|---|
| Day-1 retention | about 20 to 25% [S7] | 35%+ | 25% |
| Day-7 retention | about 7 to 8% [S7] | 15%+ | 10% |
| Day-30 retention | 3 to 5% [S7] | 8 to 12% | 8% |
| Install to trial start | 6.9% [S3] | 23%+ | 5% |
| Trial to paid | 37.7% [S3] | 51%+ | 35% |
| Install to paid by day 35 | 2.9% (freemium apps overall: 2.1%) [S3][S6] | 6.2%+ | 2% |
| Revenue per install, day 60 | $0.66 [S3] | | $0.50 |
| First renewal, monthly plan | 57% [S2] | 68% | 55% |
| First renewal, annual plan | 25% [S2] | 37% | 30% |
| Share of annual cancellations in month 1 | 35% [S4] | | watch |

Day-30 retention is the one to beat the median on. Everything about the
product (five minutes, daily, a chart of real progress) is a retention
design, and renewal follows activity: subscribers still active late in
their year renew at about 86% [S1].

**Paid acquisition test, for later.** Do not buy installs until revenue
per install at day 60 is above the cost of an install. Median cost per
install for the category on Apple Ads search in the US is about $3.77, and
$4 to $10 for meditation and wellness on iOS generally [S8]. At the median
$0.66, the app loses about $3 on each bought install.

## 9. Risks

| Risk | Mitigation |
|---|---|
| Self-help apps lose most users within a month. | Keep sessions short, reminders kind, and content fresh; the reflection chart shows real progress. |
| Content quality slips as volume rises. | Human review of every scenario; a fixed weekly volume we can review well; a backlog written ahead. |
| AI-generated content gets something emotionally wrong. | The prompt's safety rules, two review agents, a human read, and an in-app "report this scenario" link (it opens an email with the scenario id, nothing else). |
| Network and analytics erode the privacy promise. | The "content in, nothing out" rule; analytics opt-in and aggregate; About and store data forms kept exactly accurate. |
| Drift into therapy territory. | No clinical claims; the safety paragraph; scenario rules exclude abuse and unsafe situations; packs reviewed against the north star. |
| A crowded wellness market. | A narrow, concrete promise (hard conversations), practice over content, and privacy as the differentiator. |
| The paywall is seen by too few people. | Early, kind, skippable offer (section 4); measure "paywall shown" per install from week one. |
| The name is misread or contested. | "Argue" attracts searchers who want to win or be judged right, and the phrase "argue less" is used by a bestselling book and existing workshops [S32]. Subtitle carries the positioning; run a trademark search (USPTO classes 9 and 42) before spending on the brand *(check)*. |
| AI role-play apps define the category first. | Position on habit and method, not rehearsal; ship "Prepare for a real conversation"; keep the AI question (open question 6) under review. |
| Annual subscribers lapse silently and never return. | Only about 5% of cancelled annual subscribers come back within a year [S4]. Keep them active with the weekly drop and the weekly look-back; do not rely on win-back offers. |
| New state age-verification and auto-renewal laws. | Section 6.8; a one-hour legal review before the first paid release. |
| One-person content operation. | Generation prompts and the pipeline make a drop a few hours of work; consider a freelance editor once revenue allows. |

## 10. Open questions for Eric

1. **Ambition and budget:** a side project that pays for itself, or a
   business to grow? This sets how much goes into paid acquisition and B2B.
2. **Which secondary segment first:** couples or parents of teens?
3. **Weekly drop size:** 4, 6 or 8 scenarios? This sets the ongoing review
   workload.
4. **Analytics:** off entirely, or opt-in anonymous counters?
5. **Backup:** export/import file, platform backup, or both?
6. **AI:** rule it out for the foreseeable future (strongest privacy story),
   or plan the opt-in path?
7. **Free tier size:** all 32 current scenarios, or fewer, to make Plus more
   compelling? The research sharpens this. Generous free tiers convert at
   about a fifth the rate of hard paywalls [S6], and a 32-scenario runway
   outlasts most users [S7]. Revised recommendation: keep the reflection,
   chart and all four subjects free for ever; keep the 32 free for the
   soft launch to earn reviews; and decide between 32 and about 16 (four
   per subject) from real data once the early offer is in place. Never go
   to a hard paywall: it contradicts "kind" and the north star.
8. **Brand:** is "ArgueLess" clear enough in the store? A subtitle such as
   "Calmer conversations in 5 minutes a day" would help. No app with this
   exact name turned up in this research, but that is not a clearance:
   search both stores and the USPTO directly *(check)*. The neighbours
   are Arguelyzer, ArgueResolver, Argument and Argue [S32].
9. **Billing provider:** RevenueCat (better measurement, a "Purchases, not
   linked to you" privacy label) or the stores' own APIs (an empty privacy
   label, less insight)? Section 6.2.
10. **New Year window:** aim for a free listing by 26 December 2026, which
    needs the Play closed test running by about 1 December, or launch
    when ready and treat January 2028 as the first planned season?
11. **Evidence:** is a small opt-in outcome survey, or a university
    partner, worth the effort once retention is proven? It is the only
    route to an efficacy claim.

## 11. Sources

Checked 10 November 2026. Benchmark reports summarise other apps and
differ in method; RevenueCat reports medians across both stores, Adapty
averages mostly App Store data. Where a secondary article is cited for a
primary report's figures, both are listed. Items marked (vendor) come from
a company with something to sell and are weaker evidence.

- **[S1]** RevenueCat, *State of Subscription Apps 2026* (115,000+ apps):
  <https://www.revenuecat.com/state-of-subscription-apps>
- **[S2]** RevenueCat, renewal rates by category, 2026:
  <https://www.revenuecat.com/blog/growth/average-subscription-renewal-rates-by-app-category>
- **[S3]** Sahha, health and fitness conversion benchmarks (tabulates
  RevenueCat 2026) (vendor):
  <https://sahha.ai/blog/health-app-monetization-first-month/>
- **[S4]** 9to5Mac on RevenueCat's 2026 retention findings:
  <https://9to5mac.com/2026/05/27/new-report-shows-annual-app-subscribers-rarely-return-after-they-cancel/>;
  AI-app churn figures as summarised at
  <https://launchshots.app/blog/app-subscription-churn-2026>
- **[S5]** Adapty, health and fitness subscription benchmarks 2026:
  <https://adapty.io/blog/health-fitness-app-subscription-benchmarks/> and
  *State of In-App Subscriptions 2026*:
  <https://adapty.io/state-of-in-app-subscriptions/>
- **[S6]** Hard paywall against freemium, from RevenueCat 2026 data:
  <https://www.buildmvpfast.com/blog/hard-paywall-vs-free-trial-revenuecat-indie-app-2026>;
  day-0 conversion share as summarised by SaaStr:
  <https://saastr.com/the-top-10-learnings-from-revenuecats-state-of-subscription-apps-how-115000-mobile-apps-deliver-16b-in-revenue-whats-working-whats-quietly-killing-growth>
- **[S7]** Retention benchmarks (compilations of UXCam, AppsFlyer, Adjust
  and Business of Apps data; sources disagree, hence the ranges):
  <https://userpilot.com/blog/mobile-app-retention/>,
  <https://www.trypropel.ai/resources/blogs/retention-benchmarks-by-vertical-2026>,
  <https://fitnessrefined.co/fitness-app-retention-statistics/>
- **[S8]** Cost per install: AppTweak median via
  <https://insertaffiliate.com/blog/mental-health-app-user-acquisition-cost-benchmarks/>;
  Admiral Media ranges via
  <https://ideaequity.ai/blog/cost-per-install-benchmarks-2026>
- **[S9]** Apple commission and the Small Business Program:
  <https://www.forasoft.com/blog/article/how-to-avoid-apple-pay-commission-204>,
  <https://pricepush.app/blog/apple-small-business-program>
- **[S10]** Google Play fees: Android Developers Blog, March 2026:
  <https://android-developers.googleblog.com/2026/03/a-new-era-for-choice-and-openness.html>;
  worked example:
  <https://pricepush.app/blog/google-play-subscription-fees-2026-real-math>
- **[S11]** RevenueCat pricing: <https://www.revenuecat.com/pricing>;
  privacy-label guidance:
  <https://www.revenuecat.com/docs/platform-resources/apple-platform-resources/apple-app-privacy>
- **[S12]** Headspace and Calm prices and trials:
  <https://subbuddy.io/en/services/compare/headspace-vs-calm>
- **[S13]** Couples apps: <https://twogle.com/blog/couples-app-comparison>,
  <https://lovefix.app/resources/apps/paired-app-review-2026/>,
  <https://ichooseyou.app/best-couples-apps/> (all vendor)
- **[S14]** Finch: <https://joingerald.com/learn/financial-wellness/finch-app-cost>;
  Fabulous: <https://apppricinglab.com/app/apple/1203637303>
- **[S15]** AI conversation-practice apps and prices, checked September
  2026 by one of the apps compared (vendor):
  <https://www.vocalimage.app/en/articles/37-practice-difficult-conversations-ai-apps/>
- **[S16]** Workplace pricing:
  <https://www.getforte.com/blog/best-employee-wellbeing-platforms-small-business>,
  <https://firsthr.app/compare/performance/corporate-wellness-software>,
  <https://www.aihratlas.com/tools/headspace-for-work>
- **[S17]** Apple guideline 3.1.3(c):
  <https://developer.apple.com/news/?id=xqk627qu>; US external links:
  see [S9]
- **[S18]** Sharing purchases: Google,
  <https://support.google.com/googleone/answer/7007852>; comparison:
  <https://adapty.io/blog/app-purchases-family-sharing/>
- **[S19]** Apple age ratings:
  <https://9to5mac.com/2025/07/24/apple-notifies-developers-of-new-app-store-age-rating-system/>
- **[S20]** App Store Accountability Acts: Future of Privacy Forum,
  <https://fpf.org/blog/comparing-enacted-app-store-accountability-acts/>;
  <https://www.mofo.com/resources/insights/251111-texas-targets-app-stores-with-new-accountability-law>
- **[S21]** Cancellation law:
  <https://renewalrules.com/click-to-cancel-rule/ftc-click-to-cancel-rule-vacated>,
  <https://churnfree.com/blog/ftc-click-to-cancel-rule/>
- **[S22]** Privacy record of the category: Mozilla Foundation,
  <https://www.mozillafoundation.org/en/blog/shady-mental-health-apps-inch-toward-privacy-and-security-improvements-but-many-still-siphon-personal-data/>;
  BetterHelp and the FTC:
  <https://abcnews.com/Health/mental-health-apps-put-privacy-risk-stay-protected/story?id=99733313>
- **[S23]** Finkel et al. (2013), *A Brief Intervention to Promote Conflict
  Reappraisal Preserves Marital Quality Over Time*, Psychological Science:
  <https://sparq.stanford.edu/sites/g/files/sbiybj19021/files/media/file/finkel_et_al._2013_-_a_brief_intervention_to_promote_conflict_reappraisal.pdf>
- **[S24]** Morello et al. (2023), cognitive reappraisal in mHealth
  interventions, meta-analysis:
  <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10623449/>
- **[S25]** Bertsch et al. (2007), *The generation effect: a meta-analytic
  review*: <https://pubmed.ncbi.nlm.nih.gov/17645161/>
- **[S26]** Communication skills training and transfer (systematic
  review): <https://pmc.ncbi.nlm.nih.gov/articles/PMC9949884/>
- **[S27]** Seasonality: Adjust,
  <https://www.adjust.com/blog/2024-holiday-app-trends/>; Sensor Tower,
  <https://sensortower.com/blog/state-of-mobile-health-and-fitness-in-2025>;
  US share of spending (2022 data):
  <https://appnext.com/blog/thinking-of-a-new-years-resolution-how-about-boosting-discovery-of-your-fitness-app/>
- **[S28]** Manager training gap:
  <https://executiveeducation.wharton.upenn.edu/thought-leadership/wharton-at-work/2024/09/new-leaders-need-training/>,
  <https://careertrainer.ai/en/reports/difficult-conversations-statistics/>
- **[S29]** Therapy homework: provider survey in
  <https://cdn.clinicaltrials.gov/large-docs/85/NCT05866185/Prot_SAP_001.pdf>;
  <https://pmc.ncbi.nlm.nih.gov/articles/PMC13375209/>
- **[S30]** Google Play testing requirement for new personal accounts:
  <https://support.google.com/googleplay/android-developer/answer/14151465>
- **[S31]** Android Auto Backup:
  <https://developer.android.com/identity/data/autobackup>
- **[S32]** Names and neighbours: Arguelyzer,
  <https://apps.apple.com/us/app/arguelyzer-argument-analyzer/id6757536803>;
  ArgueResolver,
  <https://apps.apple.com/us/app/argueresolver-whos-right/id6753915561>;
  Whose Fault?,
  <https://apps.apple.com/us/app/whose-fault-couple-fights/id6768369592>;
  Argument,
  <https://news.marketersmedia.com/argument-introduces-structured-ai-conflict-resolution-app-for-everyday-disputes/89200675>;
  After the Argument, <https://aftertheargument.tepesoft.com/>; Jefferson
  Fisher, *The Next Conversation: Argue Less, Talk More*,
  <https://www.penguinrandomhouse.com/books/750014/the-next-conversation-by-jefferson-fisher/>
- **[S33]** Short-form video (vendor):
  <https://semnexus.com/tiktok-organic-and-paid-a-2026-app-growth-playbook>
- **[S34]** Market concentration and regional value, summarising the
  RevenueCat and Adapty 2026 reports:
  <https://chuvak-pavel.medium.com/state-of-app-monetization-2026-key-trends-from-revenuecat-and-adapty-8bdc23a4bb6f>
- **[S35]** Price medians by category:
  <https://www.airbridge.io/en/blog/subscription-app-pricing-by-category-2026-benchmark>
