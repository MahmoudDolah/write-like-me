---
description: Learn (or re-learn) the user's writing voice from real samples — pasted directly, and/or auto-fetched from GitHub/Slack/Jira — producing/updating ~/.claude/voice-profile/profile.md
argument-hint: [pasted samples, and/or paths to files/exports containing them — optional if you'd rather auto-fetch]
---

The user wants to (re-)calibrate their writing-voice profile for the
`write-like-me` plugin. Calibration input can come from two places, and both
can be used together in one run:

- **Manual samples**, pasted or pointed to below.
- **Auto-fetched content** you pull yourself from GitHub/Slack/Jira on the
  user's behalf (their own authored content only — never anyone else's).

Manual samples / pointers provided (may be empty):

$ARGUMENTS

## Step 1 — decide sources

If `$ARGUMENTS` is empty, or even if it isn't, ask the user whether they'd
also like you to auto-fetch recent writing from GitHub, Slack, and/or Jira to
supplement it. Don't assume — always ask which of these they want for this
run; skip straight to Step 3 for any source they decline.

## Step 2 — auto-fetch (per source, only if the user opted in)

For every source below: only ever collect content **authored by the user
themselves** (match on their actual account/login/user id, not just content
they were mentioned in or reacted to), and never fetch more broadly than the
scope they confirm.

### GitHub
1. Check `gh auth status`. If not authenticated, tell the user and skip
   GitHub for this run.
2. Get their login: `gh api user --jq .login`.
3. Ask which repos or orgs to search — do not default to "everything
   accessible" unless the user explicitly says so.
4. Ask which content types to include (no default pre-selected): PR
   descriptions, issue/PR comments, commit messages. Mention that commit
   messages tend to be terse/imperative and can skew the profile toward
   choppier than how the user actually writes to people, so confirm they
   still want them if chosen.
5. Fetch accordingly, e.g. `gh search prs --author=<login> --repo <repo>`,
   `gh search issues --author=<login> --repo <repo>`, and `gh api` calls for
   PR/issue comments, scoped to the confirmed repos/orgs and filtered to the
   user's login.

### Slack
1. Check whether a Slack MCP tool is available (look for a tool whose name
   contains "slack"). If none is configured, tell the user Slack auto-fetch
   isn't available in this environment and suggest pasting/exporting
   messages instead — don't attempt raw API calls without a configured tool.
2. If available, ask which channels/workspaces to search, then use the tool
   to fetch messages authored by the user in that scope.

### Jira
1. Check whether a Jira MCP tool is available (look for a tool whose name
   contains "jira" or "atlassian"). If none is configured, tell the user and
   suggest pasting/exporting comments/descriptions instead.
2. If available, ask which projects to search, then use the tool to fetch
   comments/descriptions authored by the user in that scope.

## Step 3 — preview before extraction

Combine everything (manual samples + anything fetched) into a numbered list,
each entry showing a short excerpt and its source (e.g. `repo#PR123`, a
channel name, a ticket key). Show this list to the user and ask them to
confirm it as-is or tell you which numbers to drop, **before** using any of
it below. This step still happens even if every item came from manual paste —
it's the user's chance to exclude anything they don't want shaping the
profile.

## Step 4 — extract the profile

Using only the confirmed set of samples from Step 3:

1. Check whether `~/.claude/voice-profile/profile.md` already exists.
   - If it does, show the user a short summary of what's there and confirm
     whether to overwrite it, merge new observations into it, or cancel.
     Don't clobber an existing profile silently.
2. Extract:
   - **Core voice** — sentence/paragraph rhythm, recurring vocabulary and
     phrasing, punctuation and formatting habits (contractions, em-dashes,
     bullets vs. prose, capitalization quirks), directness/hedging level,
     typical openers and sign-offs.
   - **Anti-patterns to strip** — note specifically the AI-speak tells that
     are *absent* from the user's real writing (stock phrases, reflexive
     triadic lists, over-hedging, motivational tone, etc.) so the profile can
     tell a future draft to avoid them.
   - **Platform modifiers** — if samples are tagged or clearly recognizable by
     platform, capture how formality/length/structure shift per platform
     (Slack / Jira / GitHub / Other-default). If everything given is one
     platform, still create the other sections but note they're inferred/
     tentative rather than directly observed.
   - **Example snippets** — pick 3-6 short, verbatim excerpts (ideally spread
     across platforms) that best represent the voice, for future few-shot
     reference.
3. Write the result to `~/.claude/voice-profile/profile.md` (create the
   `~/.claude/voice-profile/` directory if needed), using this structure:

   ```markdown
   # Voice Profile

   ## Core voice
   ...

   ## Anti-patterns to strip (AI-speak tells)
   ...

   ## Platform modifiers
   ### Slack
   ...
   ### Jira
   ...
   ### GitHub
   ...
   ### Other / default
   ...

   ## Example snippets (few-shot)
   ...
   ```

4. Once written, do not echo the full raw sample/fetched text back or persist
   it anywhere else — only the distilled profile (including the small number
   of chosen example snippets) should remain. Tell the user the profile has
   been created/updated, show them the file path, and briefly summarize what
   you picked up (e.g. "casual, short sentences, no exclamation points, drops
   greetings entirely in Slack").
