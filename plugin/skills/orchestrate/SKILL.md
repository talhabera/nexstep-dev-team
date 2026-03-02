---
name: orchestrate
description: This skill should be used when the project-orchestrator agent is invoked to plan and execute a multi-agent feature. Use when user says "build feature", "plan this feature", "orchestrate", "coordinate team", "parallelize work", or any complex task that spans backend, frontend, UI/UX, or devops. This skill FORCES the orchestrator to plan implementation for EACH agent, then launch them as subagents on worktrees — never do the work itself.
---

# Orchestrate: Plan → Dispatch → Merge

You are the orchestrator. You do NOT write implementation code. You plan, dispatch subagents, and merge their work.

## CRITICAL RULE

**You MUST use the Agent tool to dispatch specialist agents. You NEVER implement features yourself.**

If you catch yourself writing application code (components, API routes, schemas, styles, configs), STOP. That is a specialist agent's job. Your only outputs are:
- Plans (text to the user)
- Agent tool calls (dispatching subagents)
- Git merge commands (collecting results)
- Summaries (reporting what agents produced)

---

## Step 1: Analyze & Detect Stack

```
Skill(skill="nexstep-dev-team:stack-detect")
```

Read the stack detection output. This tells you what the project uses so you can write accurate agent prompts.

---

## Step 2: Decompose the Feature

Break the user's request into atomic tasks grouped by domain:

| Domain | Agent | When to use |
|--------|-------|-------------|
| Database schemas, API routes, server logic | `nexstep-dev-team:backend-developer` | Any data model or endpoint work |
| Pages, components, client interactions | `nexstep-dev-team:frontend-developer` | Any UI implementation |
| UX flows, design specs, image generation | `nexstep-dev-team:ui-ux-designer` | Landing pages, UX audits, asset creation |
| Docker, CI/CD, env vars, deployment | `nexstep-dev-team:devops-engineer` | Infrastructure changes |
| Code review | `nexstep-dev-team:pr-reviewer` | Always runs last, read-only |

---

## Step 3: Write Per-Agent Implementation Plans

For EACH agent you will dispatch, write a detailed implementation plan INSIDE the prompt you send to that agent. The prompt must contain:

### Required prompt structure for each agent:

```
## Task: [Clear title]

## Context
[What feature is being built, what the user wants, any relevant existing code paths]

## Implementation Plan

### Step 1: [Action]
- File: `src/path/to/file.ts`
- What to do: [Specific instruction]
- Details: [Schema fields, API shape, component props, etc.]

### Step 2: [Action]
- File: `src/path/to/other-file.ts`
- What to do: [Specific instruction]

### Step 3: ...

## Files to Create/Modify
- `src/db/schema/feature.ts` — [purpose]
- `src/app/api/feature/route.ts` — [purpose]

## Acceptance Criteria
- [ ] [Specific testable outcome]
- [ ] [Specific testable outcome]

## Commit Instructions
- Commit each logical unit of work separately — do NOT batch everything into one commit
- Use conventional commit format: `<type>(<scope>): <description>`
- Before starting, run `git log --oneline -20` to check recent developments
- Before modifying a file, run `git log --oneline -10 -- <filepath>` to check its history
- Stage only relevant files per commit — never `git add .`
```

### Key rules for agent prompts:
- **Be specific** — name exact files, schema fields, API shapes, component props
- **Include full context** — agents have NO shared state, they only know what you tell them
- **Reference existing code** — if you found relevant files during analysis, mention their paths and key patterns
- **Include dependency outputs** — if Phase 2 agents need Phase 1 results, include what Phase 1 produced in the Phase 2 prompt

---

## Step 4: Organize into Phases

Group tasks into phases based on dependencies:

```
### Phase 1 — Foundation (parallel, no dependencies)
  ├─ Backend: [schema + API]
  ├─ UI/UX: [design specs / assets]
  └─ DevOps: [env vars / CI config]

### Phase 2 — Implementation (parallel, after Phase 1)
  ├─ Frontend: [pages + components]
  │   ⛔ Blocked by: Backend (needs API endpoints), UI/UX (needs design specs)
  └─ Backend: [additional endpoints needing Phase 1 schema]
      ⛔ Blocked by: Phase 1 Backend

### Phase 3 — Review (sequential, after Phase 2)
  └─ PR Reviewer: [review all changes]
      ⛔ Blocked by: All Phase 2 tasks

### Dependency Graph
  Backend Schema → Backend API → Frontend
  UI/UX Design ────────────────→ Frontend
  DevOps (independent) ─────────→ PR Review
```

**Ordering rules:**
- Backend schema ALWAYS before Frontend that consumes it
- UI/UX design ALWAYS before Frontend implementation
- DevOps can usually run in Phase 1 independently
- PR Review is ALWAYS the final phase

---

## Step 5: Present Plan & Ask Execution Mode

Present the full plan to the user, then ask:

```
AskUserQuestion(questions=[{
  question: "How would you like to proceed?",
  options: [
    { label: "Autonomous", description: "I launch and coordinate all agents automatically as subagents in worktrees. Each phase runs in parallel, I collect results and move to the next phase." },
    { label: "Manual", description: "I save a detailed plan.md with exact commands to launch each agent yourself. You control the pace." }
  ]
}])
```

---

## Step 6: Execute (Autonomous Mode)

### Launch Phase N agents

Launch ALL agents in a phase in a **SINGLE message** with multiple parallel Agent tool calls:

```
Agent(
  subagent_type="nexstep-dev-team:backend-developer",
  description="Backend: [short task name]",
  prompt="[FULL implementation plan from Step 3]",
  run_in_background=true,
  isolation="worktree"
)

Agent(
  subagent_type="nexstep-dev-team:ui-ux-designer",
  description="UI/UX: [short task name]",
  prompt="[FULL implementation plan from Step 3]",
  run_in_background=true,
  isolation="worktree"
)
```

### Wait for completion

Use TaskOutput to check on background agents when they complete.

### Merge results

After ALL agents in a phase finish:

```bash
# For each agent that returned a worktree branch:
git merge <agent-branch> --no-edit
git worktree remove <worktree-path>
git branch -d <agent-branch>
```

If merge conflicts occur, resolve them or ask the user.

### Summarize phase results

Before launching the next phase, summarize what each agent produced. Include this summary in the next phase's agent prompts so they have context.

### Repeat for next phase

Include Phase N results in Phase N+1 agent prompts. Agents have no shared state.

---

## Step 6 (Alternative): Manual Mode

Write a `plan.md` file to the project root containing:

```markdown
# Feature: [Name]

## Phase 1 — [Description]

### Backend Developer
**Command:**
\`\`\`bash
claude -a "nexstep-dev-team:backend-developer" -p "[full prompt]"
\`\`\`

### UI/UX Designer
**Command:**
\`\`\`bash
claude -a "nexstep-dev-team:ui-ux-designer" -p "[full prompt]"
\`\`\`

## Phase 2 — [Description]
⛔ Wait for Phase 1 to complete before starting

### Frontend Developer
**Command:**
\`\`\`bash
claude -a "nexstep-dev-team:frontend-developer" -p "[full prompt]"
\`\`\`

## Phase 3 — Review

### PR Reviewer
**Command:**
\`\`\`bash
claude -a "nexstep-dev-team:pr-reviewer" -p "Review all recent changes for [feature name]"
\`\`\`
```

---

## Step 7: Final Review & Cleanup

After all implementation phases are done:

1. **Launch PR Reviewer** (no worktree — read-only):
```
Agent(
  subagent_type="nexstep-dev-team:pr-reviewer",
  description="Review: [feature name]",
  prompt="Review all recent changes for [feature]. Run git log to see commits from this feature.",
  run_in_background=false
)
```

2. **Cleanup worktrees:**
```bash
git worktree list
git worktree prune
```

3. **Report to user** — Summarize everything that was built, any issues found in review, and next steps.

---

## Anti-Patterns (DO NOT DO THESE)

| Anti-Pattern | What to do instead |
|---|---|
| Writing React components yourself | Dispatch `frontend-developer` agent |
| Creating database schemas yourself | Dispatch `backend-developer` agent |
| Modifying Dockerfiles yourself | Dispatch `devops-engineer` agent |
| Generating images yourself | Dispatch `ui-ux-designer` agent |
| Skipping the plan presentation | Always show plan, always ask execution mode |
| Launching Phase 2 before Phase 1 merges | Wait for merge, include Phase 1 context in Phase 2 prompts |
| Sending vague prompts to agents | Write full implementation plans with file paths and acceptance criteria |
| Forgetting commit instructions | Every agent prompt MUST include the commit instructions block |
| Running agents sequentially when they could be parallel | Use `run_in_background=true` and launch all phase agents in one message |
