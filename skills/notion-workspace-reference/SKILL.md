---
name: notion-workspace-reference
description: >
  Complete reference for the user's personal Notion workspace — all page URLs,
  database collection IDs, sub-page structures, and contextual notes. Use this
  skill whenever the user mentions any of their Notion pages by name
  (Dashboard, Projects, TerraStride, Rhythm, Gestura, Finance Tracker, etc.),
  asks you to navigate to, create, update, or link to a Notion page, references
  a database, task list, social post, sprint, transaction, or any other
  workspace entity, or when building prompts/automations that interact with
  their Notion setup. Always consult this skill before making any Notion API
  calls or constructing Notion URLs so you have the correct IDs and context.
---

# Notion Workspace Reference

This is the authoritative map of the user's Notion workspace. Refer to it any
time you work with their Notion data. All collection IDs are confirmed live.

---

## Quick URL Index

| Page | Category | URL |
|------|----------|-----|
| Dashboard | Personal | https://www.notion.so/Dashboard-28c25413b0c780fbae1beed893176279 |
| Projects Dashboard | Business | https://www.notion.so/Projects-dashboard-ffc25413b0c783d7b70181bb2d7891fb |
| Work Dashboard | Work | https://www.notion.so/Work-dashboard-ddae2517b71e463e80ba20a87de80ebb |
| Business Dashboard | Business | https://www.notion.so/Business-dashboard-d78a96b4e09b4beb85c9cbfa8921edcb |
| TerraStride | Business | https://www.notion.so/TerraStride-29425413b0c781df9990cf6ddc8b4dea |
| Rhythm | Business | https://www.notion.so/Rhythm-2a225413b0c78012895bfbd68b1f55dc |
| Gestura | Business | https://www.notion.so/Gestura-2ce25413b0c780139accfd2c4b444a98 |
| Finance Tracker | Finance | https://www.notion.so/Finance-Tracker-26b25413b0c7808b8442cb56cc27d252 |

---

## Page Details

### 🏠 Dashboard — Personal
**URL:** https://www.notion.so/Dashboard-28c25413b0c780fbae1beed893176279

Top-level personal operating system. The home page that aggregates all life
areas in one view. Edits to linked databases here propagate workspace-wide.

**Sections:**
- **Habits** — Daily habit tracker with one-click logging buttons
- **Gym** — Workout Tracker database — log and view training sessions
- **Library** — Book library with reading progress tracking
- **Notes** — Quick scratch space for ideas, links and reminders
- **Salary** — View of Savings — income and savings overview
- **Work** — Filtered view of work-related tasks
- **Business** — Filtered view of business tasks across all projects
- **College** — Filtered view of college/academic tasks
- **Finance** — Spending by category — filtered view of Transactions

---

### 🎯 Projects Dashboard — Business
**URL:** https://www.notion.so/Projects-dashboard-ffc25413b0c783d7b70181bb2d7891fb

Central project and task management hub. Source of truth for all active work
across projects.

**Databases & Collection IDs:**
- **Projects DB** — `collection://8e025413-b0c7-82ae-b0aa-87a762dffee9`
  - DB URL: https://www.notion.so/0d025413b0c7822aad7481a727d92b8b
  - Fields: Project name (TITLE), Owner, Status, Priority, Dates, Summary, Tasks (relation), Is Blocking (relation), Blocked By (relation), Completion (rollup)
  - Status options: Planning, In progress, Paused, Backlog, Done, Canceled
  - Priority options: Low, Medium, High
- **Tasks DB** — `collection://be125413-b0c7-82d0-a9b6-8791b1959cc0`
  - DB URL: https://www.notion.so/43825413b0c782199de7819b360d7559
  - Source for all task views across all dashboards
- **Sprints DB** — `collection://c8ed332b-f924-46b9-928a-c85571b436d5`
  - DB URL: https://www.notion.so/43fcefc80af7414dab2d8fbceb9d6c48
- **Social Posts DB** — `collection://f5ce360f-97e5-4435-82b9-0042c8c7564b`
  - DB URL: https://www.notion.so/d2c4fae40a914ff6a3b22add0d17a3b9
  - Fields: Post Name (TITLE), Platform (X/Instagram/TikTok/LinkedIn/Threads), Status (Draft/Scheduled/Posted), Post Date, Post Time, Post Type (Thread/Single tweet/Quote-tweet/Action brief/Story/Reel), Content Type (Training Tip/Motivation/Promotion/Community/Web3 Education/Territory Mindset/Humour), Content, Hashtags, Image Prompt, Media Notes, Project (relation → Projects DB)

**Terrastride project entry in Projects DB:**
- Page URL: https://www.notion.so/33925413b0c7804bbea7f0bcabe6caca

---

### 💼 Work Dashboard — Work
**URL:** https://www.notion.so/Work-dashboard-ddae2517b71e463e80ba20a87de80ebb

Dedicated workspace for employment/job-related tasks, notes and resources.
Separate from business tasks — use only for employer/job-related work.

**Sections:**
- **Notes** — Freeform notes area with images and scratch content
- **Resources** — Pinned links and reference materials for work
- **Tasks** — Filtered view of work tasks

**Work Tasks collection ID:** `collection://468dedc0-9635-4be2-a0b1-344530eead8a`

---

### 📈 Business Dashboard — Business
**URL:** https://www.notion.so/Business-dashboard-d78a96b4e09b4beb85c9cbfa8921edcb

Hub for all entrepreneurial and side-project activity. Contains links to all
business projects and a unified task view.

**Sections:**
- **Projects** — Embedded Projects database filtered to business work
- **Marketing** — https://www.notion.so/28f25413b0c7804b80ebf1a30a89976f
- **TerraStride** — https://www.notion.so/29425413b0c781df9990cf6ddc8b4dea
- **Rhythm** — https://www.notion.so/2a225413b0c78012895bfbd68b1f55dc
- **Gestura** — https://www.notion.so/2ce25413b0c780139accfd2c4b444a98
- **Tasks** — Unified business task view

**Business Tasks collection ID:** `collection://317d0fe3-7b75-46dd-afa3-261e170839bc`

**Solana API endpoint:** https://z5rmxszcb8.execute-api.eu-central-1.amazonaws.com/users

---

### 🏃 TerraStride — Business
**URL:** https://www.notion.so/TerraStride-29425413b0c781df9990cf6ddc8b4dea

Run-to-earn mobile app. Users claim territory by running routes, compete in
user-created events, and earn USDC rewards. Built on Solana.

**Key features:** territory claiming, user-created events, USDC rewards,
coaching programs (coming soon).

**Sub-pages:**
- **Tasks Tracker** — `collection://29425413-b0c7-8122-8cf7-000bf686528a`
- **Docs** — https://www.notion.so/33625413b0c7804e8607f90aa3304d79
- **X posts** — https://www.notion.so/32c25413b0c78027a08ef31fc07ba5ef (parent of April schedule pages)
- **Social media** — https://www.notion.so/29425413b0c781f1ab14e9793c369f79
- **Pitch script** — https://www.notion.so/29425413b0c780ab800aebf4b82529e8
- **Other scripts** — https://www.notion.so/29525413b0c780d19432c4ebd814b1b7
- **One liner & blurb** — https://www.notion.so/29425413b0c781a684f2d376729b6a99
- **Resources** — https://www.notion.so/29425413b0c7816f91dcf098cf1c084f
- **INTVL comparison** — https://www.notion.so/32925413b0c78082b58eeed4028c2ead
- **TO DO** — https://www.notion.so/2b825413b0c78081b366d522b6003f20

**External links:**
- Figma: https://www.figma.com/design/WL1nsmoCda3539pnPa1nzT/TerraStride
- GitHub: https://github.com/kjakopovic/TerraStride

---

### 🎵 Rhythm — Business
**URL:** https://www.notion.so/Rhythm-2a225413b0c78012895bfbd68b1f55dc

Music or rhythm-based application project. Early-stage. Check Feature List
for current scope before assuming capabilities.

**Sub-pages:**
- **Tasks Tracker** — `collection://30925413-b0c7-8085-b014-000bc60e5dcd`
  - DB URL: https://www.notion.so/30925413b0c7803d8fded672da86861d
- **Feature list** — https://www.notion.so/30925413b0c7804e8d9cdcd0ff33b57c

---

### ✋ Gestura — Business
**URL:** https://www.notion.so/Gestura-2ce25413b0c780139accfd2c4b444a98

AI-powered gesture recognition application. Competition-stage project with
active stakeholder meetings. The Prompts sub-page is critical for AI
integration context.

**Sub-pages:**
- **Tasks Tracker** — `collection://31a25413-b0c7-8029-b28f-000b5bdb3ff2`
  - DB URL: https://www.notion.so/31a25413b0c7807ea386f4bdd3e29c8c
- **UI/UX** — https://www.notion.so/2ce25413b0c780f9be25cbc8dd2c895f
- **Prompts** — https://www.notion.so/2cf25413b0c78098a8c3c77b96ccf0d0
- **Tcom meeting notes** — https://www.notion.so/2e725413b0c780a9969ce941b34b2177
- **Gestura tasks** — https://www.notion.so/2fb25413b0c78000aa98d47edd84abc9
- **Vijece pitch** — https://www.notion.so/31f25413b0c780fea68fd6b8f8a334cb
- **Ri-comp prez content** — https://www.notion.so/33425413b0c78077ab83deb401c99586

---

### 💰 Finance Tracker — Finance
**URL:** https://www.notion.so/Finance-Tracker-26b25413b0c7808b8442cb56cc27d252

Personal finance management system. Tracks all spending, subscriptions,
savings and trends. Transactions is the source database — all other views are
filters of the same collection. Savings data also surfaces in the main Dashboard.

**Core database:**
- **Transactions DB** — `collection://26b25413-b0c7-80af-9d86-000b7a8fbcaf`
  - DB URL: https://www.notion.so/26b25413b0c780f5a19ae1a23cb232a6

**View sub-sections:**
- **Amount Spent** — Total spending by time period
- **Subscriptions** — Recurring subscription costs
- **Spending per Person** — Who money was spent with or on
- **Monthly Breakdown** — Month-by-month spending summary
- **Savings** — Savings tracking (also visible on main Dashboard)
- **Trends** — Spending trend analysis over time

---

## Common Patterns

### Linking to a project from a task or social post
When creating pages in the Tasks DB or Social Posts DB that belong to
TerraStride, use the project relation:
```
"Project": ["https://www.notion.so/33925413b0c7804bbea7f0bcabe6caca"]
```

### Creating a task under a specific project
Use `data_source_id: be125413-b0c7-82d0-a9b6-8791b1959cc0` (Tasks DB) as the
parent, then set the Project relation field to the relevant project page URL.

### Creating a social post
Use `data_source_id: f5ce360f-97e5-4435-82b9-0042c8c7564b` (Social Posts DB).
Required fields: Post Name, Platform, Status, Post Date, Content Type, Content.

### Fetching a specific dashboard
Pass the page URL directly to the `notion-fetch` tool `id` parameter.
No need to search — all URLs are listed above.
