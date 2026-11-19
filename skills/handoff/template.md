---
name: handoff-<stream>
description: "HANDOFF <stream> <YYYY-MM-DD>: <state in a few words>; next = <first action>"
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

**State.** Two or three sentences: what exists now, what has been checked and what hasn't, and
the decisions in force, each with where it is recorded or will be.

**Next.**
1. The first concrete action, specific enough to start without asking.
2. …

**Waiting / parked.**
- Item: who parked it or what it waits on; when to revisit.

**Watch out.**
- Only what the next steps need. Lessons live in their topical memories: [[<slug>]].

<!--
Field notes (leave this comment out of real stream files):
- checked: when the git state in `repos` was last verified by commands.
- active_in / active_since: added under `metadata` only while a session holds the stream (its
  ListAgents name, the date), removed on handoff. Don't write them as null: the memory system
  re-serializes the frontmatter, drops null values, and adds node_type, originSessionId, modified.
- repos: every repo the stream touches; `pushed` = HEAD is on its upstream;
  `own_uncommitted` = this stream's files left uncommitted;
  `do_not_touch` = files there that belong to someone else (e.g. the user's untracked notes).
- read_first: memories and repo files a resuming session reads before anything else.
- Body ≤ 40 lines; an item is one or two sentences. Empty sections are dropped, not left with
  placeholders.
-->
