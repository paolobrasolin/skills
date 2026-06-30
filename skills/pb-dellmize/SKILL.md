---
name: pb-dellmize
description: Edit the AI-writing tells out of a piece of text so it reads like a careful human wrote it — diagnose the giveaways (significance-puffery, rule-of-three, em-dash overuse, filler hedges, fancy copulas, elegant variation, formatting/citation cruft), then make minimal, meaning-preserving edits. Use when the user wants to de-AI-ify / humanize / de-slop a draft, email, doc, abstract, or review, or says text "sounds like ChatGPT / an LLM".
argument-hint: "[file path | paste text] [--light | --heavy] [--report-only]"
---

# De-LLM-ize

Take a piece of text and edit out the tells that mark it as LLM-generated, so it reads like a careful human wrote it. This is **copy-editing, not rewriting**: preserve the author's meaning, claims, structure, and voice — remove the slop.

The goal is *not* to beat an AI detector. Detectors are unreliable, and writing to defeat them produces worse prose. The goal is text a discerning human editor would sign off on: concrete, unpadded, un-inflated, specific, in one voice.

The core insight: the problem is almost never a single word. It's **puffery** (inflating the mundane into the momentous), **vagueness** (claims with no referent), **forced symmetry** (everything in threes and balanced pairs), and **throat-clearing** (filler that announces a point instead of making it). Treat the word lists in `tells.md` as a *detection aid*, not a find-and-replace table.

## Cardinal rule: meaning is sacred

Never change what the text asserts. Don't add facts, drop claims, alter numbers, reorder an argument, soften a position, or invent specifics to replace vague ones. If a sentence is vague *and you don't know the concrete fact it should state*, cut the puffery around it or flag it for the author — **never fabricate**. When in doubt, the smaller edit wins.

## Input

- `/de-llm-ize path/to/file.md` → edit that file.
- `/de-llm-ize` with pasted text → return the edited text plus a diff of what changed.
- `--light` (default): surgical — cut filler, fix the worst lexical/rhetorical tells, leave voice and structure alone.
- `--heavy`: also rework formulaic macro-structure (inflated intros, "challenges and future directions" tails, pervasive parallelism, mechanical bold/headings).
- `--report-only`: diagnose and report the tells with locations; make no edits.

If no text is supplied, ask for the file path or the text. Before editing a file in place, confirm — or show the rewrite first.

## Workflow

### 1. Read and diagnose
Read the whole text, then read `tells.md`. Scan for every category of tell and build a short **tell report**: `category → location/quote → suggested fix`. Don't edit yet. Tells *cluster* — report density, not just instances. One "crucial" is noise; five AI-vocabulary words plus three rule-of-threes plus a "stands as a testament" is the signal.

### 2. Confirm scope (skip if obvious)
If the text has heavy *structural* tells and the user passed no flag, briefly say what `--light` vs `--heavy` would each change, and ask which. Otherwise proceed at `--light`.

### 3. Edit
Apply the moves in `tells.md`, in priority order:
- **Cut before you swap.** Most tells are deletable — filler, hedges, self-summarizing `-ing` tails, significance-puffery. Delete first; replace only when the slot must be filled.
- **Concrete over vague** — state the fact, or cut the claim; don't invent the fact.
- **Plain over fancy** — `is`/`has`, not `serves as`/`boasts`/`stands as`.
- **Break forced symmetry** — trim rule-of-three and "not X but Y" to what is actually true.
- **Repeat the right word** — kill elegant variation; the precise term beats a thesaurus parade.
- **One voice** — match the surrounding register; don't introduce a new one.

Every edit must be meaning-preserving. Keep the author's correct technical terms exactly as written.

### 4. Verify
Re-read the result against the original and check:
- Did any claim, fact, number, citation, or hedge-direction change? (Must be **no**.)
- Did I introduce a *new* tell — choppiness from over-cutting, a register shift, lost nuance, a robotic terseness?
- Is it still recognizably the same author writing?

Fix regressions before presenting. Over-correction (sterile, clipped prose) is its own AI tell.

### 5. Present
Show the **tell report** (what you found and why it reads as AI), then the edited text or a before→after diff of the changed passages. For a file, apply with Edit once confirmed. Call out anything you flagged but deliberately did **not** change — especially vague claims only the author can make concrete.

## Ground rules

1. **Editing, not authoring.** Remove tells; don't add content, arguments, or opinions.
2. **Smaller edit wins.** Prefer deletion and the lightest touch that resolves the tell.
3. **Don't mangle good prose.** Many "tells" are also normal writing. Honor the *leave it alone* list in `tells.md` — em-dashes, the copula "is", and the rule of three are all fine in moderation. The signal is **overuse and puffery**, not any single occurrence.
4. **Don't fabricate specifics.** Vague + unknown → cut or flag, never invent.
5. **Detectors are not the target.** Report honestly; never promise the result will "pass as human" or beat a detector.
6. **Preserve formatting intent.** Strip *cruft* (stray markdown in plain prose, emoji bullets, citation artifacts, curly-quote paste damage); keep formatting the author clearly wants.
