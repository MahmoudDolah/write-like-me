# write-like-me

A Claude Code plugin that drafts Slack messages, Jira comments, GitHub PR/issue
text, and similar content on your behalf in *your* actual writing voice —
instead of the "AI-speak" Claude defaults to.

It works by calibrating a voice profile from real samples of your writing
(pasted directly, and/or auto-fetched from GitHub/Slack/Jira), then having
Claude apply that profile *while drafting* — not as a rewrite pass afterward.

## Install

```
git clone https://github.com/MahmoudDolah/write-like-me.git
cd write-like-me
./install.sh
```

This validates the plugin and symlinks it into `~/.claude/skills/write-like-me`,
where it auto-loads every session as `write-like-me@skills-dir` — no
marketplace registration needed. Because it's a symlink (not a copy), editing
files in your clone takes effect immediately; just run `/reload-plugins` in an
active session, or start a new one.

Other install.sh options:

```
./install.sh --copy        # copy instead of symlinking
./install.sh --force       # replace whatever's already at the target path
./install.sh --uninstall   # remove it
```

For a one-off test without installing anything, load it for a single session
instead:

```
claude --plugin-dir /path/to/write-like-me
```

## Usage

### 1. Calibrate your voice

```
/voice-calibrate
```

Paste writing samples directly, and/or let it auto-fetch your own authored
content from GitHub (PR descriptions, issue/PR comments, commit messages —
via `gh`), Slack, or Jira (if an MCP tool for those is configured; otherwise
it'll tell you and fall back to manual paste). It always asks which
repos/channels/projects and content types to include — nothing is fetched
without confirmation.

Before anything is used, you'll see a preview list of everything found (with
source + excerpt) so you can exclude anything that isn't actually your voice —
useful if, say, some of your GitHub history includes Claude-generated PR
descriptions or commit messages, which shouldn't feed back into the profile.

The result is written to `~/.claude/voice-profile/profile.md` — a core voice
description, an anti-AI-speak checklist, per-platform modifiers
(Slack/Jira/GitHub/other), and a handful of verbatim example snippets. The
full raw samples are not kept; only this distilled profile is.

### 2. Just write normally

No command needed for everyday use. The `compose-in-voice` skill self-invokes
whenever Claude is about to draft something meant for Slack, Jira, GitHub, or
similar — whether you're going to copy-paste the result yourself or Claude is
about to post it directly via a tool call.

### 3. Refine it over time

```
/voice-feedback
```

Give an explicit correction ("more like this", or a rewritten example) and
it'll fold that into the existing profile — adjusting a rule or swapping in a
fresher example snippet.

### 4. Check what's in the profile

```
/voice-profile
```

Shows `~/.claude/voice-profile/profile.md` as-is. It's a plain markdown file,
so you can also just open and hand-edit it directly.

## Notes

- The voice profile lives at the user level (`~/.claude`), not inside any
  project repo, so it's available across all your projects.
- Auto-fetch only ever collects content authored by *you* (matched by
  account/login), never content you're just mentioned in.
- GitHub auto-fetch needs `gh` authenticated (`gh auth status`). Slack/Jira
  auto-fetch need a corresponding MCP tool configured — without one,
  `/voice-calibrate` just asks you to paste/export instead.
