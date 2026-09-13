---
description: Fold an explicit correction ("more like this") into the existing voice profile so future drafts improve
argument-hint: [what was wrong and/or a corrected example, optionally which platform it's for]
---

The user is giving explicit feedback to improve their `write-like-me` voice
profile, based on a draft you (or a prior session) produced.

Feedback provided:

$ARGUMENTS

## What to do

1. Read `~/.claude/voice-profile/profile.md`.
   - If it doesn't exist, tell the user there's no profile to refine yet and
     suggest `/voice-calibrate` first instead.
2. Work out what's being corrected:
   - A rule-level correction (e.g. "too formal for Slack", "I never use
     exclamation points") → adjust the relevant Core voice or Platform
     modifier bullet(s).
   - A corrected example (the user supplies a rewritten version of something
     you drafted) → treat it as a new candidate example snippet for the
     relevant platform section.
3. Apply the update to the profile file:
   - Edit existing bullets in place rather than just appending duplicates.
   - If adding a new example snippet, prune the oldest/weakest existing one
     for that platform so the snippets section stays small (aim for 3-6
     total, not unbounded growth).
4. If the platform isn't stated and isn't obvious from context, ask which
   platform (or "core voice" / "all platforms") the feedback applies to
   before editing, rather than guessing.
5. Confirm to the user what changed in the profile, briefly.
