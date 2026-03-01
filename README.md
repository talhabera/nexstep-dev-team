# nexstep-dev-team

A Claude Code plugin providing a specialized AI development team for Next.js/Drizzle/PostgreSQL SaaS projects. The orchestrator breaks features into phases and launches specialist agents as parallel subagents in isolated worktrees.

## Agents

| Agent | Role | Model |
|-------|------|-------|
| Project Orchestrator | Task breakdown, phased subagent coordination | Opus |
| Backend Developer | TypeScript, Drizzle, PostgreSQL, APIs | Opus |
| Frontend Developer | Next.js, React, shadcn/ui, Tailwind | Sonnet |
| UI/UX Designer | SaaS UX, FLUX image generation | Opus |
| DevOps Engineer | Docker, CI/CD, GitHub Actions, deployment | Opus |
| PR Reviewer | Code quality, security, DRY/SOLID | Opus |

## Skills (13)

stack-detect, code-conventions, drizzle-patterns, deployment-checklist, flux-image-gen, docker-patterns, github-actions-ci, shadcn-radix-patterns, nextjs-app-router, better-auth-patterns, api-route-patterns, saas-ux-patterns, security-checklist

## Installation

1. Add the marketplace:
```
/plugin marketplace add talhabera/nexstep-dev-team
```

2. Install the plugin:
```
/plugin install nexstep-dev-team
```

## Requirements

- `BFL_API_KEY` environment variable for FLUX image generation (UI/UX Designer)

## How It Works

The Project Orchestrator decomposes features into phased workstreams and launches specialist agents automatically — no manual terminal commands needed.

```
> Build a settings page with user profile editing

The orchestrator will:
1. Plan phases and present them for approval
2. Launch Phase 1 agents in parallel (e.g. Backend + UI/UX + DevOps)
3. Collect results, then launch Phase 2 (e.g. Frontend)
4. Run PR Reviewer on all changes

Each agent runs in its own isolated worktree.
```

## Auto PR Review

The PR Reviewer hook automatically triggers when you run `gh pr create` or `git push`.

## Project Structure

```
plugin/
├── agents/          # 6 specialist agents
├── skills/          # 13 domain-specific skills
└── scripts/         # Supporting scripts
```
