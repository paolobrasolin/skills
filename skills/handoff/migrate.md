# Migrating a project to stream handoffs

Once per project, from a session in that project. Nothing changes until the user approves the
plan.

1. **Alone.** ListAgents: if another session on this project is running, ask the user to hand it
   off or close it first, since migration rewrites shared files.
2. **Inventory.** Read `MEMORY.md` and every memory file. Find the handoff material: files or
   lines marked HANDOFF, next session, start here, resume point; state carried in `MEMORY.md`
   lines (commit hashes, test counts, "as of" dates); dated DONE sections; lists of gotchas and
   lessons inside state files; in-repo handoffs that the project's CLAUDE.md points to.
3. **Streams.** Work out which workstreams are still open. If unclear, ask; don't invent streams.
4. **Classify** every piece, by the table in `SKILL.md`:
   - snapshot of an open stream → its new stream file (`template.md`);
   - lessons, gotchas, recipes → topical memories, merged into existing ones where they fit;
   - feedback → feedback memories (already there: leave as is);
   - project facts → project memories, one topic each;
   - log of finished work → dropped, after checking it is recorded elsewhere: sample its hashes
     in `git log`, its issues on GitHub, its decisions in the project's docs. What is recorded
     nowhere: list it for the user to decide (keep in a memory, move to a repo doc, drop);
   - stale or contradicted → dropped, naming what contradicts it;
   - copies of the global CLAUDE.md or of another memory → dropped.
5. **Index.** `MEMORY.md`: one short line per memory (about 150 characters at most), open
   streams first, no state in the lines.
6. **Plan.** Show the user a table: each current file → what happens to its parts (kept, moved to
   X, dropped because Y); then the new file list and the new `MEMORY.md`. Wait for approval;
   adjust as asked.
7. **Back up.** The memory directory is not under version control: copy it to
   `memory-backup-<YYYY-MM-DD>` next to it, and tell the user the path.
8. **Apply.** This is the one time `MEMORY.md` is rewritten whole. Then check: every `MEMORY.md`
   line points to an existing file and every file has a line; `[[links]]` point to existing
   slugs (or are deliberate placeholders); stream bodies are within 40 lines.
9. **Report:** files created, edited, deleted; the backup path, with the command that deletes it
   (`rm -r <path>`) for when the user is satisfied; what is left for the user.
