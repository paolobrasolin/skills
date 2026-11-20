---
name: handoff-<stream>
description: "HANDOFF <stream>: <what the stream is for, in a few words>"
metadata:
  type: project
  stream: <stream>
  checked: <YYYY-MM-DD>
  checkout: <absolute path of the checkout or worktree the stream works in>
  repos:
    - path: <absolute path>
      branch: <branch>
      head: <short sha>
      pushed: true
      own_uncommitted: []
      do_not_touch: []
  read_first:
    - "[[<memory slug>]]"
    - "<repo-relative path>"
---

**Goal.** One or two sentences: what the stream is for, and when it is done.

**State.** Two or three sentences: what exists now, what has been checked and what hasn't, and the decisions in force, each with where it is recorded or will be.

**Next.**
1. The first concrete action, specific enough to start without asking.
2. …

**Waiting / parked.**
- Item: who parked it or what it waits on; when to revisit.

**Watch out.**
- Only what the next steps need. Lessons live in their topical memories: [[<slug>]].

<!--
Field notes (leave this comment out of real stream files):
- description: what the stream is for. Once it has this form it stays as it is from handoff to
  handoff: the date and the next action live in `checked`, in the body and in the `MEMORY.md`
  line, nowhere else.
- checked: the day the body or `repos` was last brought up to date. Taking or releasing
  `active_in` does not change it.
- active_in / active_since: added under `metadata` only while a session holds the stream (its
  ListAgents name, the date), removed on handoff. Don't write them as null: the memory system
  re-serializes the frontmatter, drops null values, and adds node_type, originSessionId, modified.
- node_type, originSessionId, modified: the memory system's own. If the file has them, keep them
  as they are when you write it anew.
- repos: every repo the stream touches; `pushed` = HEAD is on its upstream (`true` or `false`),
  or `no-remote` when the repo has none;
  `own_uncommitted` = this stream's files left uncommitted;
  `do_not_touch` = files there that are someone else's or of unknown owner (e.g. the user's
  untracked notes).
- read_first: memories and repo files a resuming session reads before anything else.
- Next: a step that needs the user's go is still a Next item, not a Waiting one; say in the item
  that it needs the go.
- Body ≤ 40 lines, where an item or a paragraph is one line: don't hard-wrap it. An item is one
  or two sentences. Empty sections are dropped, not left with placeholders.
-->
