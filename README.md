# ClaudeHub

Personal hub for Claude Code configuration: agents, rules, skills, and plugin marketplaces. The source of truth for what gets mirrored into `~/.claude/` across machines.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Majki1/ClaudeHub/main/install.sh | bash
```

This clones the hub to `~/.claude-hub`, symlinks `skills/`, `agents/`, and `rules/common/` into `~/.claude/`, registers the plugin marketplaces in `~/.claude/settings.json`, and adds a managed block to `~/.claude/CLAUDE.md`. Re-run any time to update — symlinks pick up `git pull` automatically.

Flags:

| Flag | What it does |
|---|---|
| `--copy` | Copy files instead of symlinking (loses live updates). |
| `--force` | Overwrite existing entries at the destination. |
| `--dry-run` | Print what would happen, do nothing. |
| `--uninstall` | Remove all symlinks pointing at `~/.claude-hub` and strip the CLAUDE.md block. |
| `-v` | Show every link/skip decision. |

After install, restart Claude Code and run `/plugin` inside the CLI to install individual plugins from the registered marketplaces.

## Layout

| Path | Purpose |
|---|---|
| `agents/` | Specialized agent personalities, vendored from [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) (MIT). Organized by domain — design, engineering, marketing, sales, etc. |
| `rules/common/` | Shared rule files (`coding-style.md`, `git-workflow.md`, `testing.md`, `security.md`, `agents.md`, ...) loaded by global `~/.claude/CLAUDE.md`. |
| `skills/` | Skill library — both custom skills and curated copies of useful third-party skills. Each skill is a directory with `SKILL.md` + optional `references/`, `rules/`, `scripts/`. |
| `plugins/` | Registry of installed Claude Code plugin marketplaces (`plugins.md`) with install commands. |

## Custom skills (built in this repo)

| Skill | What it does |
|---|---|
| [`founder-playbook`](skills/founder-playbook/) | Decision validation and thinking frameworks for startup founders (GROW, Solution-Focused, fundraising, runway, crypto/web3 specifics). |
| [`react-native-skills`](skills/react-native-skills/) | React Native + Expo best practices. Originally vendored from Vercel's skill; extended with 12 additional rules covering Expo Router groups, typed routes, `+api.ts` server endpoints, project structure, data-fetching anti-patterns, NativeWind variants, splash/font handling, and TypeScript hygiene. See [`references/tutorial-patterns.md`](skills/react-native-skills/references/tutorial-patterns.md) for the provenance of the new rules. |

## Curated skills (mirrored from `~/.claude/skills/`)

A snapshot of the user-installed skill library — kept in this repo so a fresh machine can be provisioned by copying everything under `skills/` to `~/.claude/skills/`. Highlights:

- Document generation: `pdf`, `pptx`, `docx`-adjacent (`canvas-design`, `web-artifacts-builder`)
- Frontend / web: `frontend-design`, `next-best-practices`, `next-upgrade`, `vercel-composition-patterns`, `webapp-testing`
- Mobile: `mobile-design`, `react-native-skills`, `Flutter`
- Design: `canvas-design`, `design-system`, `theme-factory`, `impeccable`, `video-hook-formulas`
- Tooling: `claude-api`, `mcp-builder`, `skill-creator`, `task-observer`
- Integrations: `deploy-to-vercel`, `vercel-cli-with-tokens`, `notion-workspace-reference`

Plugin marketplaces (separate from skills) are tracked in [`plugins/plugins.md`](plugins/plugins.md).

## How this maps to `~/.claude/`

| Repo path | Target |
|---|---|
| `rules/common/*.md` | Referenced by `~/.claude/CLAUDE.md` |
| `agents/<domain>/<agent>.md` | `~/.claude/agents/<domain>/<agent>.md` |
| `skills/<skill>/` | `~/.claude/skills/<skill>/` |
| `plugins/plugins.md` | Reference doc; marketplaces themselves live under `~/.claude/plugins/marketplaces/` |

There is no automated sync yet — copy by hand or write a sync script when ready.

## Conventions

- **Commits**: short, descriptive, no `feat:`/`fix:` prefixes (see `rules/common/git-workflow.md`).
- **Skill format**: `SKILL.md` with YAML frontmatter (`name`, `description`); supporting docs under `references/`; granular rules under `rules/` when a skill has many.
- **No secrets**: this repo is public personal config — never commit API keys, tokens, or private endpoints.
