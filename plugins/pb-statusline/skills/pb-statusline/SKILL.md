---
name: pb-statusline
description: Install, update, or remove Paolo's Claude Code status line (folder@branch on the left; model · context · burn-rate-colored rate limits on the right). Use when the user asks to install / set up / wire / remove "the statusline" or "paolo's statusline", typically right after enabling this plugin.
argument-hint: "[install | remove]"
---

# pb-statusline installer

This plugin ships `statusline.sh` at the plugin root. Claude Code plugins cannot set the top-level `statusLine` setting themselves (plugin `settings.json` only supports `agent` and `subagentStatusLine`), so this skill wires it into the user's settings by hand — pointing at the script **inside the plugin directory**, so plugin updates propagate to the live status line without reinstalling.

## Install (default action)

1. Resolve the plugin root: `echo "$CLAUDE_PLUGIN_ROOT"` in Bash. If unset, derive it from this skill's own location — SKILL.md lives at `<plugin root>/skills/pb-statusline/SKILL.md`.
2. Preflight: `command -v jq` — if missing, stop and tell the user to install jq first (`brew install jq` or their package manager). Ensure the script is executable: `chmod +x "<plugin root>/statusline.sh"`.
3. Merge into the **user-level** settings file at `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json`, creating it if absent and preserving every other key:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "<absolute plugin root>/statusline.sh"
     }
   }
   ```

   If a *different* `statusLine` is already configured, show it to the user and ask before overwriting.
4. Confirm to the user: the bar appears on the next render (no restart needed), and future script updates arrive via `claude plugin update pb-statusline` (or marketplace auto-update) with no re-install step.

## Remove

Delete the `statusLine` key from the same settings file — but only if its `command` points into this plugin's directory. If it points elsewhere, show it and ask instead of deleting.

## What the script renders

Left-aligned `folder@branch` (worktree name when in one); right-aligned `model effort · ctx%/size · 5h%/countdown · 7d%/countdown`. Percentages are bold green/yellow/red (thresholds 50/80; the context one turns yellow past 200k tokens regardless of window size). The rate-limit countdowns are colored by burn rate — the share of the window the current pace would cover before exhausting quota: plain ≥100%, green ≥80%, yellow ≥60%, red ≥40%, bright magenta below. Rate-limit sections appear only for Claude Pro/Max subscribers; every section degrades gracefully when its data is absent.

Requirements: bash, jq, Claude Code ≥ 2.1.153 (sets `COLUMNS` for full-width alignment; older versions fall back to 120 columns).
