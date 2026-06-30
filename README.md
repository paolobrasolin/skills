# skills

Personal repository of [@paolobrasolin](https://github.com/paolobrasolin)'s Claude Code plugins, published as a **plugin marketplace** (`.claude-plugin/marketplace.json`) for native, versioned install.

Plugins live under `plugins/<name>/` and are listed in the marketplace manifest. Today it ships one:

| Plugin | What it does |
|--------|--------------|
| [`pb-skills`](./plugins/pb-skills) | Groups individual agent skills. Also installable cross-agent via `npx skills`. |

## The `pb-skills` plugin

`pb-skills` bundles individual skills — each skill defines the conventions, architecture, and guardrails for a specific area. Its skills sit at **top-level `skills/`** so `npx skills` (vercel-labs) can discover them too, and are linked into the plugin via a symlink:

```
.claude-plugin/marketplace.json      # lists the plugin at ./plugins/pb-skills
plugins/pb-skills/
├── .claude-plugin/plugin.json
└── skills -> ../../skills           # symlink to the real top-level skills/
skills/
└── pb-<topic>/SKILL.md              # the one real copy (npx reads this)
```

One real copy of each skill, reachable by both the marketplace plugin (through the symlink) and `npx skills` (at the top level). The symlink is the bridge between the conventional plugin layout and npx's need for a top-level `skills/`.

## Install

### Option A — Claude Code plugin (native, versioned)

```bash
claude plugin marketplace add paolobrasolin/skills
claude plugin install pb-skills@paolobrasolin
```

Update to the latest version with `claude plugin update pb-skills`. Users only receive updates when `version` in `plugin.json` is bumped.

### Option B — npx skills (cross-agent)

```bash
npx skills add paolobrasolin/skills
```

Install a single skill: `npx skills add paolobrasolin/skills --skill pb-<topic>`. Update: `npx skills update`. (Always tracks the latest commit on the branch — no version pinning.)

## Adding a new skill

Skills belong to the `pb-skills` plugin:

1. Create `skills/pb-<topic>/SKILL.md` (kebab-case folder, **`pb-` prefix**) with YAML frontmatter:
   ```markdown
   ---
   name: pb-<topic>
   description: Short summary of what the skill does and when to use it.
   ---

   # Title

   Skill content...
   ```
2. The skill is picked up automatically — the `pb-skills` plugin sees it through the `skills/` symlink, and `npx skills` reads the top-level `skills/` directly. No manifest changes needed.
3. Bump `version` in `plugins/pb-skills/.claude-plugin/plugin.json` to release the update to marketplace users.
4. Validate with `claude plugin validate plugins/pb-skills --strict` (plugin + skills) and `claude plugin validate .` (marketplace), then open a PR against `main`.

## Adding a new plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` (see [`pb-skills`](./plugins/pb-skills/.claude-plugin/plugin.json) for a template).
2. Add an entry for it to the `plugins` array in `.claude-plugin/marketplace.json`.
3. Validate with `claude plugin validate plugins/<name> --strict` and `claude plugin validate .`.

## Conventions

- One marketplace, many plugins: each plugin is a folder under `plugins/<name>/` with its own `.claude-plugin/plugin.json`, all listed in `.claude-plugin/marketplace.json`
- Skills (owned by `pb-skills`) live under `skills/`, one folder per skill, named `pb-<topic>` in kebab-case — the `pb-` prefix namescopes these skills and avoids clashing with other plugins' `/commands`
- Each skill has a single required file: `SKILL.md`; frontmatter must have `name` and `description`, and the `description` must make clear **when** the skill should activate
- Keep `SKILL.md` lean — push detail into sibling files (e.g. `docs/`) and load them on demand (progressive disclosure)
- English for repo docs, manifests, example code, and commit messages. Skill prose (`SKILL.md`, `docs/`) may be in any language, while code blocks stay English
- Distribution and versioning live in the manifests (`.claude-plugin/marketplace.json` + each `plugins/<name>/.claude-plugin/plugin.json`) — validate with `claude plugin validate plugins/<name> --strict`
- The `plugins/pb-skills/skills` symlink is load-bearing: it's how the plugin reaches the top-level `skills/`. Don't delete it or move skills into the plugin folder
