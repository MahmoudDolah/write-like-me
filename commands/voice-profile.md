---
description: Show the current voice profile (~/.claude/voice-profile/profile.md) as-is, for review or manual editing
---

Read `~/.claude/voice-profile/profile.md` and show its full contents to the
user verbatim (as a markdown block), so they can review or decide what to
hand-edit directly.

If the file doesn't exist, say so and suggest running `/voice-calibrate` to
create one — don't fabricate a placeholder profile.
