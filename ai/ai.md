# AI Brain

Operate by roles, not personas. Announce to the human what role you need to step into to proceed with your work and follow the process.

# Brain Boot Sequence

- Only `[?]` present → Prompt the user to review/accept; do not proceed.
- Any `[~]` In-Progress → Continue it via TDD (Red → Green → Refactor).
- Else any `[ ]` To-Do → Pick the lowest-numbered To-Do and start TDD.
- Planning gate: For a target story, if no current Plan or the Plan is stale → run `plan <story-id>` and record it under the story before edits.
- After Green/Refactor → Move the story to `[?]` Waiting for Acceptance.
- Driving order: `[~]` > lowest-numbered `[ ]`; ignore `[?]` unless it’s the only state left.

## Winning Streak Rules
- Aim to convert all actionable stories to `[?]` in a streak.
- Preempt early if unclear or blocked; ask for help concisely.

## Iteration Budget
- 2 attempts (consecutive red cycles without green) per story by default.
- Allow a 3rd attempt only if the fix is an obvious adjacent change.
- Track `Attempts: n/3` under the story’s subtasks.

## Preemption Triggers
- Attempt budget exceeded or requirements unclear.
- Cross-cutting refactor required to proceed.
- External dependency or missing contract.
- Flaky tests or unrelated failures.
- Touching too many files for the story’s scope.

## Safety Rails
- Max 3 files and ~100 LOC diff per story without approval.
- Refactor only while green and within touched files.
- One story in flight at a time; start the next only after moving current to `[?]`.

# Numbering
- Epics are numbered `1`, `2`, `3`, ... (in Work Log order).
- Stories under each epic are numbered `1.1`, `1.2`, ...
- Every story begins with its ID: `[ ] 2.3 Title...`
- Use story IDs in commands, plans, and prompts.

# Roles

## Architect
See `ai/agents/architect.txt` for full role guidance.
CRITICAL: Planning gate and TDD-first enablement apply.

## Implementer
See `ai/agents/dev.txt` for full role guidance.
CRITICAL: True Red → Green → Refactor and strict adherence to the Plan.

## Librarian
Merged into QA responsibilities. See `ai/agents/qa.txt`.

## QA
See `ai/agents/qa.txt` for full role guidance.
CRITICAL: Auto-tidy code safely for security, performance, and maintainability; keep tests green.

# Process Flow
- States: `[ ]` To-Do → `[~]` In-Progress → `[?]` Waiting for Acceptance → `[x]` Done.
- Subtasks allowed under each story for focus, relevant file index, attempt tracking, and a Plan section.
- User confirms functionality before moving to Done themselves.

# Files

## `ai.md`
- This file: the brain adhered to at conversation start.

## `ai-inbox.md`
- Unstructured ideas backlog. As items are processed into epics/stories, remove them here.

# Human Preemption
- The user can intervene at any time—stop, correct, or add craftsmanship.

# Command Glossary

## upgrade
- Mine attached context and repo for `// @consider:` tags and curated notes; upgrade Technical Considerations and ADR-lite.
- If no explicit context is given, use recent changes to scope the mining.

## pollinate
- Apply Technical Considerations repo-wide when no active in-progress work; restructure for malleability without changing features.

## seq or sequence
- Ask compact, enumerated questions; user replies with short strings (e.g., `yn112n`).

## next or n
- Follow the Brain Boot Sequence to decide the next step. Optionally pass a story ID to focus a specific item (e.g., `next 2.1`).

## plan <story-id>
- Produce a concise, deterministic plan for the story before edits.
- Output under the story as a `Plan:` subsection using the template below.
- Keep it short and executable; list only what you will actually touch/run.

Plan template (per story)
- Story: <id> <title>
- Context Summary
- Relevant Files (paths + 1‑line notes)
- Relevant Tests (files + test names)
- Contracts/Endpoints (schema + handlers)
- Entry Points
- Commands (exact test commands)
- Risks/Unknowns
- Attempt Budget: 0/3

# Technical Considerations
- Keep items brief, actionable, and justified.

Template per item:
- Name
- Guidance (how to apply)
- Why (rationale)
- Signals/Anti-patterns (detect drift)
- References (link to file without line number as line number will likely change)

- Name: API logic lives in hooks; components only dispatch/select
- Guidance: Encapsulate all network calls inside `useApiContract`-based hooks. Presentational components must not call fetch/axios or touch the API client directly; they dispatch actions and read selectors.
- Why: Enforces separation of concerns, testability, and consistent typing. Avoids UI-transport coupling and duplicated error handling.
- Signals/Anti-patterns: API calls in components; passing raw promises through props; ad-hoc URLs/methods; scattered error handling; untyped request/response shapes.
- References: web-app/src/App/MetricsPage/subhooks/useMetricUpdater.ts, web-app/src/App/hooks/useApiContract.ts

- Name: Type-safe contracts generated from schema.json
- Guidance: Use generated `*API` types with `useApiContract<...>`. Do not hardcode paths or methods outside the schema. Regenerate types when `schema.json` changes.
- Why: Single source of truth and compile-time alignment between client and server; prevents drift and reduces runtime errors.
- Signals/Anti-patterns: `any` in API paths/input/output; path-method mismatches; contracts missing from generated types; divergence from `schema.json`.
- References: web-app/scripts/generate-api-contracts.js, web-app/src/types/index.d.ts, web-app/src/App/hooks/useApiContract.ts

# Decision Records (ADR-lite)
For impactful choices:
- Decision
- Why
- Consequences
- Date
- Links

## ADR: Type-safe API contracts via hooks
- Decision: Adopt generated TypeScript API contracts from `schema.json` and require consuming them through `useApiContract` hooks; keep API logic out of components.
- Why: Ensure compile-time contract alignment, reduce runtime errors, and centralize API concerns for testability and consistency.
- Consequences: Developers must update `schema.json` and regenerate types when APIs change; new endpoints are added via schema-first flow; tests target hooks instead of components for API behavior.
- Date: 2025-10-27
- Links: schema.json, web-app/scripts/generate-api-contracts.js, web-app/src/App/hooks/useApiContract.ts, web-app/src/types/index.d.ts

# Active Work (Work Log)

## Purpose & Vision
Migrate the Monitor page to the relational monitors model and deliver ratio exploration UX. Includes frontend integration with the new endpoints and a guided “ratio mode” for graph-like navigation.

## 1. Relational Monitors Data Integration (Epic)

As a user, I want the Monitor page to load relational monitor data and scores so that I can view and manage monitors correctly without legacy JSON.

### Stories

- [x] 1.1 Update Monitor page to use new `/monitors` endpoint (relational data)
- [x] 1.2 Remove usage of old JSON array endpoint
- [x] 1.3 Keep `/monitors/scores` consumption aligned with relational model
- [x] 1.4 Persist day-range updates via `PUT /monitors`

## 2. Ratio Exploration Experience (Epic)

As a user, I want to enter “ratio mode”, pick a `from` monitor and explore its ratios to other monitors so that I can see trends and navigate the ratio graph.

### Stories

- [x] 2.1 Show a “ratio mode” control on each monitor
- [~] 2.2 Activating ratio mode sets the selected monitor as `from_monitor`
  * [](./web-app/src/App/MonitorPage/Ratios.test.tsx)
  * [](./web-app/src/App/MonitorPage/)
  * Load ratio nodes via `/ratios/nodes?from_monitor_id=<id>`
- [ ] 2.3 Link to other ratios
- [ ] 2.4 Below each link display last 4 ratio values (aligned to `from_monitor`’s `day_range`)
- [ ] 2.5 Show time blocks and averages for both monitors
- [ ] 2.6 Allow navigation: clicking a monitor makes it the new `from_monitor` (graph exploration)

## 3. Ratio CRUD & Monitor–Metric Linking (Epic)

As a user, I want to create and edit ratios and manage monitor–metric links so that I can evolve the analysis model without leaving the Monitor page.

### Stories

- [~] 3.1 Create a ratio between two monitors
- [ ] 3.2 Edit or delete an existing ratio
- [x] 3.3 Add or remove monitor–metric links for a monitor

## Notes

- The `from_monitor` drives time-windowing for ratio calculations.
- Ratio previews use the last value in the returned time-window series.
- Align score and ratio views to the same `day_range` for the `from_monitor`.
