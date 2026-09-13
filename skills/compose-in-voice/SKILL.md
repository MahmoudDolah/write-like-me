---
name: compose-in-voice
description: Use whenever you are about to draft text that will be posted or sent on the user's behalf to another person or system — a Slack message, a Jira/Linear ticket or comment, a GitHub PR description or issue comment, an email, a status update, or similar. Trigger BEFORE writing the content, not as a rewrite pass afterward: this applies whether the user will copy-paste your draft themselves or you are about to send it directly via a tool call (gh, an MCP Slack/Jira tool, etc). Do not use for code, code comments, commit messages (unless the user asks for it explicitly for one of these platforms), or text staying inside this conversation.
---

# Compose in the user's voice

Goal: produce text that sounds like the user actually wrote it, not identifiable
LLM/"AI-speak." This skill governs *how* you draft the content, not what you say —
it never changes the underlying facts, code, or intent of the message.

## Steps

1. **Load the voice profile.** Read `~/.claude/voice-profile/profile.md`.
   - If it does not exist, tell the user briefly that no voice profile is set up
     yet, suggest running `/voice-calibrate`, and then proceed with the user's
     request in your normal voice. Never block the task on a missing profile.

2. **Identify the destination.** Work out which platform this text is headed
   for from context — an explicit tool call about to be made (e.g. `gh`, a
   Slack/Jira/Linear MCP tool), or what the user asked for. If it's ambiguous,
   default to the profile's "Other / default" modifier.

3. **Draft using the profile:**
   - Apply the **Core voice** section for baseline sentence rhythm, vocabulary,
     punctuation habits, directness/hedging level, and typical openers/sign-offs.
   - Layer on the matching **Platform modifier** (formality, length, structure)
     on top of the core voice — don't discard the core voice, adjust it.
   - Actively strip anything on the **Anti-patterns** list (stock AI-speak tells
     like "I hope this helps!", "Let's dive in", reflexive triadic lists,
     over-hedging, motivational filler, excessive em-dashes — whatever that
     section lists).
   - Use the **Example snippets** as a pattern reference for rhythm and word
     choice — do not copy them verbatim or template off their specific wording.

4. **Keep it proportionate.** Match the length and structure the user actually
   uses for that platform (per the modifier) — don't pad a normally terse Slack
   message into a formal essay, and don't compress a normally detailed Jira
   comment into a one-liner.

5. If the user gives live feedback on a draft in this conversation ("more like
   this", "too formal", etc.), apply it to the current draft immediately. Only
   suggest `/voice-feedback` if they want the correction remembered for future
   drafts, not just this one.
