# skills

Personal Claude Code **plugin marketplace** (`.claude-plugin/marketplace.json`): a catalog of @paolobrasolin's plugins, one folder per plugin under `plugins/<name>/`. It currently ships a single plugin, `pb-skills`, which groups individual agent skills and doubles as an `npx skills` source.

Install, usage, and the add-a-skill / add-a-plugin walkthroughs live in [README.md](./README.md).

## Repo layout

- `.claude-plugin/marketplace.json` — the marketplace manifest; lists every plugin. Add new plugins here.
- `plugins/<name>/.claude-plugin/plugin.json` — one folder per plugin, each with its own manifest and `version`.
- `skills/<name>/SKILL.md` — top-level skills, owned by the `pb-skills` plugin (reached via the `plugins/pb-skills/skills` → `../../skills` symlink) and also discovered by `npx skills`.

## Rules

- The repo is the marketplace; `pb-skills` is one plugin within it. Don't conflate the two — new plugins get their own `plugins/<name>/` folder and a marketplace entry.
- One skill per kebab-case folder under `skills/`, containing only a `SKILL.md` (frontmatter `name` + `description`). No `package.json` or executable code inside skill folders.
- Name skills `pb-<topic>` (kebab-case) — the `pb-` prefix namescopes these skills and avoids clashing with other plugins' `/commands`. The folder name and frontmatter `name` must match.
- Skills physically live at top-level `skills/<name>/` (so `npx skills` finds them); the `pb-skills` plugin reaches them through the symlink `plugins/pb-skills/skills` → `../../skills`. Don't move skills into the plugin dir or delete that symlink — `npx` needs the real top-level dir, the plugin needs the link.
- `SKILL.md` is a lean router: short body, with detail pushed into sibling files (`docs/`) loaded on demand. Write the `description` with concrete trigger keywords so Claude knows when to fire.
- After editing manifests or skills, run `claude plugin validate plugins/<name> --strict` (plugin + skills) and `claude plugin validate .` (marketplace).
- Bump `version` in the relevant `plugin.json` on every release — it's the single source of truth; `claude plugin update` keys off it.
- English for repo docs, manifests, example code, and commits. Skill prose may be in any language, but code blocks are always English.
