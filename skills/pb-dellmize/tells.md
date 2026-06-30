# The catalog of tells

Diagnostic reference for `de-llm-ize`. Each entry: the **pattern**, **why** it reads as AI, and the **fix**. Adapted from Wikipedia's *Signs of AI writing* and editing practice. None of these is proof on its own — weigh **density and combination**. Always favor the smallest meaning-preserving edit.

---

## 1. Significance-puffery (the biggest tell)

Inflating the mundane into the momentous, or appending grand meaning the author never earned.

- **Patterns:** "stands/serves as a testament to", "plays a vital/crucial/pivotal role in", "underscores/highlights the importance of", "reflects a broader", "marks a key turning point", "is a cornerstone of", "leaves a lasting legacy", "in an ever-evolving landscape".
- **Why:** humans state what a thing *is* or *does*; LLMs editorialize about how *significant* it is.
- **Fix:** delete the significance frame and keep the fact. Don't replace it with a different grand claim.
  - *Before:* "The library serves as a testament to the city's rich cultural heritage."
  - *After:* "The library opened in 1903 and holds the city's oldest manuscript collection." (if you know the fact) — otherwise just cut the sentence.

## 2. Filler & throat-clearing

Phrases that announce a point instead of making it.

- **Patterns:** "It's important to note that", "It's worth mentioning/noting that", "It is widely regarded that", "Needless to say", "In today's fast-paced world", "When it comes to", "At the end of the day", "It goes without saying".
- **Fix:** delete the frame; the sentence almost always stands on its own.
  - *Before:* "It's important to note that the results were inconclusive."
  - *After:* "The results were inconclusive."

## 3. Self-summarizing participial tails

A trailing `-ing` clause that restates the sentence's "impact" with no new information or attribution.

- **Patterns:** "..., highlighting the need for X", "..., emphasizing its role in Y", "..., reflecting a growing trend", "..., ensuring a seamless experience", "..., contributing to overall success", "..., showcasing the potential of Z".
- **Why:** the model pads each sentence with a vague consequence clause.
- **Fix:** delete the tail, or convert it into a real claim with a subject and a source.
  - *Before:* "Adoption grew 12%, underscoring the platform's value to small businesses."
  - *After:* "Adoption grew 12%." (cut) — or, if attributable: "Adoption grew 12%; the company credits its small-business pricing."

## 4. Rule of three / forced parallelism

Everything arrives in balanced triples and matched pairs.

- **Patterns:** three adjectives ("fast, reliable, and scalable"), three-part phrases, "X, Y, and Z" where two would do; repeated parallel sentence openings.
- **Why:** an LLM rhythm default; over-symmetry reads as manufactured.
- **Fix:** trim to the items that are actually true and load-bearing; vary the rhythm.
  - *Before:* "It is powerful, versatile, and intuitive, offering speed, flexibility, and ease of use."
  - *After:* "It's fast and easy to pick up." (keep the claims you can defend)

## 5. Negative parallelism ("not X but Y")

- **Patterns:** "not just X, but Y", "not X, but rather Y", "It's not about A; it's about B", "X isn't merely Y — it's Z".
- **Why:** a signature LLM rhetorical move, especially in openers and closers.
- **Fix:** state Y directly; drop the contrast unless the negation carries real information.
  - *Before:* "This isn't just a tool — it's a complete workflow."
  - *After:* "This is a complete workflow."

## 6. Fancy copulas & marketing verbs

Avoiding plain "is/are/has" in favor of inflated substitutes.

- **Patterns:** "serves as", "stands as", "represents", "boasts", "features", "offers", "delivers", "showcases", "embodies", "maintains" — where "is" or "has" is meant.
- **Fix:** use the plain copula.
  - *Before:* "The app boasts a robust feature set and serves as an ideal solution."
  - *After:* "The app has the features most teams need."

## 7. AI-vocabulary clusters

Individually harmless words that, *clustered*, signal generation. Don't ban them — flag density and prefer plainer choices when one isn't pulling its weight.

- **High-signal set:** delve, tapestry, testament, boasts, bolster, crucial, pivotal, intricate, interplay, landscape, meticulous, underscore, vibrant, enduring, garner, nuanced, multifaceted, realm, robust, seamless, leverage, foster, navigate (figurative), resonate, elevate, unlock, harness, embark, myriad, plethora.
- **Connectives over-used:** "Additionally", "Moreover", "Furthermore", "Notably", "Importantly" stacked at sentence starts.
- **Fix:** keep at most where precise; otherwise swap for the ordinary word ("delve into" → "examine"/"look at"; "leverage" → "use"; "a myriad of" → "many"; "foster" → "encourage"). Cut stacked connectives.

## 8. Elegant variation

Swapping in synonyms to avoid repeating a key term, producing unnatural lexical churn.

- **Pattern:** the same referent called "the model", "the system", "the framework", "the architecture", "the solution" across four sentences.
- **Why:** repetition-penalty artifact; humans repeat the right noun.
- **Fix:** pick the correct term and repeat it. Precision beats variety.

## 9. Promotional / editorializing tone

Press-release or travel-brochure register where neutral prose belongs.

- **Patterns:** "vibrant", "rich", "stunning", "nestled in", "natural beauty", "groundbreaking", "must-have", "game-changing", "a diverse array of", "renowned for".
- **Fix:** neutralize to fact; drop the adjectives that assert quality rather than describe it.

## 10. Vague attribution (weasel sourcing)

- **Patterns:** "Experts argue", "Studies show", "It is widely believed", "Industry reports suggest", "Observers note", "Critics say" — with no named source.
- **Fix:** name the source, or cut the claim. Don't invent a source. If only the author can supply it, flag it.

## 11. Formulaic macro-structure (`--heavy`)

- **Inflated intro:** opens by situating the topic in a sweeping context ("Throughout history…", "In an increasingly digital world…") before saying anything specific. → Cut to the first real sentence.
- **"Challenges and future directions" tail:** a closing paragraph of the shape "Despite its [strengths], [subject] faces challenges… As technology evolves, it will likely…" → Cut speculation; keep only concrete, sourced points.
- **Mechanical sectioning:** every section the same length and shape, each ending on a tidy summary sentence. → Let structure follow content.

## 12. Punctuation & formatting

- **Em-dash overuse:** em-dashes as the default clause separator throughout. → Vary with commas, periods, parentheses; keep em-dashes where they earn their place. (One or two is *normal* — see §14.)
- **Curly quotes/apostrophes** in a plain-text or code context, mixed with straight ones → normalize to the document's convention (paste damage).
- **Excessive boldface:** every key term **bolded** mechanically, "key-takeaways" styling. → Bold sparingly or not at all.
- **Title Case In Headings** where the document uses sentence case → match the document's convention.
- **Emoji as bullets/markers** (✅, 🚀, 🔑) in prose that isn't chat → remove.
- **Inline-header lists:** "**Benefit:** description" rows used as a default layout → convert to prose or a clean list, drop the bold labels if they add nothing.
- **Stray thematic breaks** (`---`) inserted above headings → remove.

## 13. Generation artifacts (always remove)

- **Citation cruft:** `oaicite`, `oai_citation`, `contentReference`, `turn0search0`, `:contentReference[...]`, `+1`, `grok_card`, `attached_file` — leftover tool markup. Remove and, if it stood in for a real citation, flag the gap.
- **Tracking params:** `utm_source=…&utm_medium=…` appended to URLs → strip.
- **Stray markdown** (`**`, backticks, `#`) pasted into a plain-text destination → render or remove.
- **Meta-disclaimers:** "As an AI language model…", "As of my last knowledge update…", "I don't have access to real-time…", "I hope this helps!", "Certainly! Here's…", "Feel free to…" → delete.
- **Placeholder text:** "[Insert X here]", "This section needs expansion", an unfilled template → flag for the author.

## 14. Leave it alone (false positives)

These are normal writing. Do **not** "fix" them on sight; act only on clear overuse or puffery:

- A single em-dash, or two in a long piece.
- The copula "is/are" — and even a *little* parallelism or one rule-of-three.
- Passive voice where it's the right choice (the actor is unknown or irrelevant).
- One occurrence of an "AI-vocabulary" word used precisely.
- Professional, polished tone — polish ≠ AI.
- Correct technical terminology and domain jargon — never simplify away accuracy.
- Genuine significance, when stated concretely and attributed.

Over-correcting good prose into clipped, sterile sentences is itself a tell. Restraint is the skill.

---

## The editor's eye — final test

Before finishing, ask of every changed passage:

1. **Does it say something, or just announce that something is important?** Keep the saying; cut the announcing.
2. **Could a skeptical reader ask "according to whom?" or "so what, specifically?"** If yes and the text doesn't answer, the claim is puffery — cut it or flag it.
3. **Would the author have written it this way?** The result must sound like *them*, edited — not like a different, blander writer.
4. **Did I change any meaning?** If yes, revert. Meaning is sacred.
