# nexstep-dev-team

A Claude Code plugin providing a specialized AI development team for Next.js/Drizzle/PostgreSQL SaaS projects.

## Agents

| Agent | Role | Model |
|-------|------|-------|
| Project Orchestrator | Task breakdown, parallel coordination | Opus |
| DevOps Engineer | Docker, CI/CD, GitHub Actions, deployment | Opus |
| Frontend Developer | Next.js, React, shadcn/ui, Tailwind | Sonnet |
| Backend Developer | TypeScript, Drizzle, PostgreSQL, APIs | Opus |
| UI/UX Designer | SaaS UX, FLUX image generation | Opus |
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

## Parallel Execution

Use the Project Orchestrator to break tasks into parallel workstreams:

```
> Plan this feature: user settings page with profile editing

The orchestrator will output phased terminal commands:

Terminal 1: claude -p "As backend-developer: ..." --worktree
Terminal 2: claude -p "As ui-ux-designer: ..." --worktree
Terminal 3: claude -p "As devops-engineer: ..." --worktree
```

## Auto PR Review

The PR Reviewer automatically triggers when you run `gh pr create` or `git push`.
