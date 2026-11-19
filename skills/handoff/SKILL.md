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

## Where things go

| Content | Destination |
|---|---|
| Snapshot of a stream: state, next steps, what waits, what to watch | The stream file, rewritten each time, body ≤ 40 lines |
| Lessons, gotchas, recipes that outlive the stream | Topical memory files, one topic each, edited in place |
| The user's corrections and confirmed ways of working | Feedback memories |
| Durable project facts (layout, toolchain, conventions) | The project's state memory |
| Log of finished work | Nowhere in memory: git, issues and project docs hold it |

If a decision or result is recorded nowhere but in this session, say so and propose where it
belongs (a repo doc, an issue comment); writing there follows the project's usual approval rules.

Memory is the auto-memory directory named in the system prompt; follow its file format
(frontmatter, one line per memory in `MEMORY.md`).

If the project keeps its handoff in the repo (its CLAUDE.md or a memory pointer says so, e.g.
`docs/HANDOFF.md`), write the stream file there instead, same format, and leave committing to the
project's usual rules. Memory then only points to it.

## The stream file

`handoff-<stream>.md` in memory. `<stream>` is short kebab-case naming the work, not the
session: `auth-rework`, `data-import`. Format: `template.md` next to this file. The frontmatter
holds the state a resume checks; the body holds what a reader needs.

Every body line must be true now and needed for what comes next; delete the rest. No narrative
of what was done: that is the log.

Its line in `MEMORY.md`, at the top with the other open streams:
`- [HANDOFF <stream>](handoff-<stream>.md) — <YYYY-MM-DD>: next = <first action>`

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
  unrecognised uncommitted files; don't act on them.
- `active_in` (with `active_since`) marks the session holding a stream: added on resume, removed
  on handoff. Absent means nobody holds it.

## Mode: handoff — `/handoff [stream]`

1. Stream name: the one you resumed; else the argument; else the session's name if set with
   `claude -n`; else propose one and confirm it with the user.
2. Check git in every repo the stream touched: branch, HEAD, ahead/behind upstream, your
   uncommitted files. From commands, not from recollection.
3. Sort the session's content by the table above. Put lessons and feedback into an existing
   topical file where one fits (look first); create a file only for a new topic, with its
   `MEMORY.md` line. Fix or delete memory lines this session proved wrong.
4. Rewrite the stream file from the template: `checked` = today, no `active_in`.
5. Update the stream's `MEMORY.md` line.
6. Report in a few lines: the Next list, what changed in memory (files created, edited,
   deleted), anything left uncommitted or unpushed.

Handoff never commits or pushes; if the user wants that, it is a separate request under the
project's rules. If memory still holds old-style handoff notes (dated "next session" files,
HANDOFF lines with no stream file, state inside `MEMORY.md` lines), don't fix them here:
mention `/handoff migrate`.

## Mode: resume — `/handoff resume [stream]`

1. Choose the stream: the argument; else the only open one; else list the open streams (the
   HANDOFF lines of `MEMORY.md`) and ask.
2. Read the stream file and everything in `read_first`.
3. Check each repo in `repos` against git: the path exists; branch; HEAD as recorded, or the
   commits since (`git log <head>..HEAD`; say which stream they belong to if another stream file
   claims them); pushed state; uncommitted files against `own_uncommitted`. Check issues too if
   the project tracks work there. Where the project's records and the stream file disagree, the
   records win: say what differs.
4. If `active_in` names a session that ListAgents shows running, stop and ask. Otherwise add
   `active_in` (your session's name) and `active_since` (today) under `metadata`.
5. Report in at most 10 lines: where the stream stands, any drift, the first Next step, any
   choice that needs the user (explained plainly). Wait for the user's go before editing
   anything else.

## Mode: close — `/handoff close [stream]`

For a finished stream.

1. Move what lasts (lessons, feedback, project facts) to their memories.
2. Check git: if anything of the stream is uncommitted or unpushed, report it and stop.
3. Show the user what will be deleted; on their yes, delete the stream file and its `MEMORY.md`
   line.

## Mode: migrate — `/handoff migrate`

Once per project, to convert existing memory to this scheme: read `migrate.md` next to this file
and follow it.
