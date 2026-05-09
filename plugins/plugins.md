# Claude Code Plugin Marketplaces

Installed plugin marketplaces and their install commands.

## Install a Marketplace

In Claude Code, run:

```
/plugin marketplace add <owner>/<repo>
```

Then browse and install plugins:

```
/plugin
```

## Marketplaces

| Marketplace | Repo | Install Command | Last Updated |
|-------------|------|-----------------|--------------|
| [claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | `anthropics/claude-plugins-official` | `/plugin marketplace add anthropics/claude-plugins-official` | 2026-05-09 |
| [everything-claude-code](https://github.com/affaan-m/everything-claude-code) | `affaan-m/everything-claude-code` | `/plugin marketplace add affaan-m/everything-claude-code` | 2026-03-07 |
| [claude-hud](https://github.com/jarrodwatts/claude-hud) | `jarrodwatts/claude-hud` | `/plugin marketplace add jarrodwatts/claude-hud` | 2026-03-23 |
| [callstack-agent-skills](https://github.com/callstackincubator/agent-skills) | `callstackincubator/agent-skills` | `/plugin marketplace add callstackincubator/agent-skills` | 2026-03-24 |
| [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | `nextlevelbuilder/ui-ux-pro-max-skill` | `/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill` | 2026-04-11 |
| [expo-plugins](https://github.com/expo/skills) | `expo/skills` | `/plugin marketplace add expo/skills` | 2026-04-12 |

## Install Locations

All marketplaces install to `~/.claude/plugins/marketplaces/<name>/`.

| Marketplace | Local Path |
|-------------|------------|
| claude-plugins-official | `~/.claude/plugins/marketplaces/claude-plugins-official` |
| everything-claude-code | `~/.claude/plugins/marketplaces/everything-claude-code` |
| claude-hud | `~/.claude/plugins/marketplaces/claude-hud` |
| callstack-agent-skills | `~/.claude/plugins/marketplaces/callstack-agent-skills` |
| ui-ux-pro-max-skill | `~/.claude/plugins/marketplaces/ui-ux-pro-max-skill` |
| expo-plugins | `~/.claude/plugins/marketplaces/expo-plugins` |

## Bulk Install

Run all of these to add every marketplace:

```bash
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add affaan-m/everything-claude-code
/plugin marketplace add jarrodwatts/claude-hud
/plugin marketplace add callstackincubator/agent-skills
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
/plugin marketplace add expo/skills
```

## Management Commands

| Command | Purpose |
|---------|---------|
| `/plugin` | Browse and install plugins from added marketplaces |
| `/plugin marketplace list` | List added marketplaces |
| `/plugin marketplace add <repo>` | Add a marketplace |
| `/plugin marketplace remove <name>` | Remove a marketplace |
| `/plugin marketplace update <name>` | Update a marketplace to latest |
