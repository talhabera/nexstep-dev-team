---
name: FLUX Image Generation
description: This skill should be used when the user asks to "generate image", "create mockup", "design hero image", "make an icon", "generate placeholder", or when the UI/UX designer agent needs to create images using BFL FLUX API.
---

# FLUX Image Generation

Generate images using BFL FLUX API for SaaS mockups, hero sections, icons, and website content.

## API Quick Reference

- **Endpoint:** `https://api.bfl.ai/v1/flux-2-pro` (production quality)
- **Auth:** `x-key: $BFL_API_KEY` header
- **Flow:** POST request → get `polling_url` → poll until `Ready` → download image
- **URL expiry:** Result URLs expire in 10 minutes — download immediately

## Model Selection

| Use Case | Model | Path | Cost |
|----------|-------|------|------|
| Quick mockups | FLUX.2 [klein] 9B | `/v1/flux-2-klein-9b` | $0.015/img |
| Production images | FLUX.2 [pro] | `/v1/flux-2-pro` | $0.03/img |
| Maximum quality | FLUX.2 [max] | `/v1/flux-2-max` | $0.07/img |
| Text/typography | FLUX.2 [flex] | `/v1/flux-2-flex` | $0.05/img |
| Image editing | FLUX.1 Kontext [pro] | `/v1/flux-kontext` | $0.04/img |

## Standard Sizes for Web

- Hero sections: 1920x1080 or 1440x810
- Card thumbnails: 640x480 or 800x600
- Icons/avatars: 512x512
- OG images: 1200x630
- Mobile hero: 750x1334

## Prompting for SaaS

When generating images for SaaS products:
- Include "clean, modern, minimal" for consistent SaaS aesthetic
- Specify "white background" or "gradient background" for versatility
- For dashboards: "screenshot of a modern SaaS dashboard, data visualization"
- For people: "professional headshot, diverse, natural lighting"
- For abstract: "geometric shapes, tech-inspired, brand colors [specify hex]"

## Reference

For proven prompt templates and patterns, see `references/prompt-patterns.md`.
