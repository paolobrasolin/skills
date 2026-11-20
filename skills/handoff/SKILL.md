---
name: handoff
description: "Hand off a workstream to memory so a fresh session can continue it, or resume one from memory. Use when the user says things like \"handoff to memory\", \"we continue in a fresh session\", \"wrap up for today\", \"resume from the handoff\", \"pick up where we left off\". Modes: /handoff [stream], /handoff resume [stream], /handoff close [stream], /handoff migrate."
argument-hint: "[stream] | resume [stream] | close [stream] | migrate"
---

# Handoff

A handoff lets a fresh session continue a workstream without re-deriving it. Each workstream
(a *stream*) has one small snapshot file, rewritten at every handoff; everything else goes where
it lasts.

Arguments: `$ARGUMENTS`. Empty or a stream name → handoff. `resume [stream]`, `close [stream]`,
`migrate` → those modes. A request in words maps to the mode it means.

## Terms

- Open stream: a stream with a HANDOFF line in `MEMORY.md`.
- Holder: the session a stream file names in `active_in`.
- Records: git, and the project's issues and docs.

## Where things go

| Content | Destination |
|---|---|
| Snapshot of a stream: state, next steps, what waits, what to watch | The stream file, rewritten each time, body ≤ 40 lines |
| Lessons, gotchas, recipes that outlive the stream | Topical memory files, one topic each, edited in place |
| The user's corrections and confirmed ways of working | Feedback memories |
| Durable project facts (layout, toolchain, conventions) | Project memories (type `project`), one topic each |
| Log of finished work | Nowhere in memory: git, issues and project docs hold it |

If a decision or result is recorded nowhere but in this session, say so and propose where it
belongs (a repo doc, an issue comment); writing there follows the project's usual approval rules.

Memory is the auto-memory directory named in the system prompt; follow its file format
(frontmatter, one line per memory in `MEMORY.md`).

## The stream file

`handoff-<stream>.md` in memory. `<stream>` is short kebab-case naming the work, not the
session: `auth-rework`, `data-import`. Format: `template.md` next to this file. The frontmatter
holds the state a resume checks; the body holds what a reader needs.

Every body line must be true now and needed for what comes next; delete the rest. No narrative
of what was done: that is the log. An item is one or two sentences: detail lives where it lasts
(a repo doc, an issue, a topical memory), and the item points to it.

While you hold a stream you may patch its file when something a successor would need changes (a
decision lands, HEAD moves). Between a resume and the user's go you write only `active_in`. A
handoff does not patch: it writes the body anew.

Its line in `MEMORY.md`, at the top with the other open streams:
`- [HANDOFF <stream>](handoff-<stream>.md) — <YYYY-MM-DD>: next = <first action>`

Whenever you change the body or `repos`, set `checked` to today and keep that line's date and
first action in step. Taking or releasing `active_in` does not count.

A stream file written by an earlier version of this skill may differ from the template (a missing
section or field, a dated description): read it as it is. The next handoff writes it in the
current format; nothing else has to migrate it.

## Rules for parallel sessions

Several sessions may work on one project at once, in one checkout or in worktrees, and they
share the memory directory.

- Rewrite only your own stream file. Never write `MEMORY.md` or another shared memory whole:
  re-read it right before, change only your lines with Edit. If Edit fails because the file
  changed, re-read and retry.
- Your session's name: ListAgents states it ("This session is …"). By default it is the folder's
  name plus a short suffix (`my-project-aa`); any other name was set with `claude -n <name>`.
- In git, record and touch only your own commits and files. Never commit, stash, reset, check
  out or clean anything you didn't make: a dirty tree may be another stream's work. Mention
  unrecognised uncommitted files by name; don't open, change or move them: they may hold secrets.
- `active_in` (with `active_since`) marks the session holding a stream: added on resume, removed
  on handoff. Absent means nobody holds it. So does a name that isn't running, which also tells
  you that the last holder never handed off.

## Mode: handoff — `/handoff [stream]`

Two exits first. If this session did nothing a fresh session would continue, say so and write
nothing. If the stream is finished (nothing left in Next, nothing waiting), propose
`/handoff close` instead of a snapshot.

1. Stream name: the one you resumed; else the argument; else an open stream in `MEMORY.md` that
   this session's work continues; else the session's name if set with `claude -n`; else propose
   one and confirm it with the user. If the argument names another stream than the one you
   resumed, ask which one is meant.
2. Check git in every repo the stream touched: branch, HEAD, ahead/behind upstream (`no-remote`
   if it has none), uncommitted files. From commands, not from recollection: your memory of the
   session tells you only which commits and files are yours. If a commit since the recorded
   `head` isn't yours, say so in the report.
3. Sort the session's content by the table above. Put lessons and feedback into an existing
   topical file where one fits (look first); create a file only for a new topic, with its
   `MEMORY.md` line. When you add to a file, bring its description and its `MEMORY.md` line up
   to date. Fix or delete memory lines this session proved wrong.
4. Read the current stream file if there is one, then write it anew from the template: carry over
   what is still true (parked items above all) and drop the rest. `checked` = today, no
   `active_in`; uncommitted files that aren't yours go in `do_not_touch`.
5. Update the stream's `MEMORY.md` line.
6. Report in a few lines: the Next list, what changed in memory (files created, edited,
   deleted), anything left uncommitted or unpushed, and any decision recorded nowhere else, with
   where you propose to put it.

Handoff never commits or pushes; if the user wants that, it is a separate request under the
project's rules. If memory still holds old-style handoff notes (dated "next session" files,
HANDOFF lines with no stream file, state inside `MEMORY.md` lines), don't fix them here:
mention `/handoff migrate` in your report, not in the stream file.

## Mode: resume — `/handoff resume [stream]`

1. Choose the stream: the argument; else the only open one; else list the open streams (the
   HANDOFF lines of `MEMORY.md`) and ask.
2. Read the stream file (`template.md` explains its fields) and everything in `read_first`.
3. Check each repo in `repos` against git: the path exists; branch; HEAD as recorded, or the
   commits since (`git log <head>..HEAD`; if another stream file's `head` is among them, name
   that stream); pushed state (with no remote, `false` and `no-remote` say the same);
   uncommitted files, each untracked one listed (`git status -uall`), against `own_uncommitted`
   and `do_not_touch` (one in neither list is unrecognised). Check the issues or tasks the
   stream file names, too. Where the records and the stream file disagree, the records win: say
   what differs.
4. If `active_in` names a session that ListAgents shows running, stop and ask. If it names one
   that isn't running, or this very session after a `/clear`, the last holder never handed off
   and the snapshot may predate its last work: say so in the report (who, since when, `checked`)
   and trust the records over it. Then set `active_in` (your session's name) and `active_since`
   (today) under `metadata`.
5. Report in at most 10 items of one or two sentences: where the stream stands, any drift, the
   first Next step, any Waiting item whose time has come, any choice that needs the user
   (explained plainly), and `checkout` if it is not the directory you are in. Wait for the
   user's go before editing anything else, the stream file included.

## Mode: close — `/handoff close [stream]`

For a finished stream.

1. If `active_in` names another session that ListAgents shows running, stop and ask.
2. Check the Goal's "done when" against the records and say what you find. If it is not met,
   say what is left and ask before going on.
3. Move what lasts (lessons, feedback, project facts) to their memories.
4. Check git: if anything of the stream is uncommitted, or unpushed in a repo that has a remote,
   report it and stop.
5. Show the user what will be deleted; on their yes, delete the stream file and its `MEMORY.md`
   line.

## Mode: migrate — `/handoff migrate`

Once per project, to convert existing memory to this scheme: read `migrate.md` next to this file
and follow it.
