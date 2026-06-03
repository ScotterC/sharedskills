# Brand Identity — the Asphodel method

A reusable method (skill + guide + templates) for giving a project a distinctive logo
and a cohesive theme, distilled from how the Asphodel / ShadowSky brand was built.

## The idea in one screen

**The logo is one SVG path, rotated.** The Asphodel mark is a six-petal flower: a single
lens-shaped petal drawn six times, each copy rotated 60° around a shared center, plus a
center dot. Six fills, one path. Change the geometry once and every petal updates. That's
the whole method — a memorable mark with almost no source.

Differentiation between repeated copies comes from **color + draw order** (SVG has no
z-index: later elements paint on top). When copies overlap, draw order *is* depth — see
the layered butterfly variant in `GUIDE.md`, where the same trick stacks wings over
petals from one teardrop path.

**The theme is one primary + one accent.** Every color, shadow, motion duration, and
easing curve is a semantic CSS variable on `:root`. Dark mode and high-contrast mode
just **override the same token names**, so components are written once and inherit every
theme for free.

## What's here

| File | Purpose |
| --- | --- |
| `SKILL.md` | Invokable skill — walks an agent through concept → mark → theme → wiring |
| `GUIDE.md` | The deep reference: annotated source, the geometry, the why |
| `templates/mark.template.svg` | Starter single-path radial mark to edit |
| `templates/mark.preview.png` | Rendered preview of the starter mark |
| `templates/theme.template.css` | Starter token system (`:root` + dark + high-contrast) |
| `export-icons.sh` | Rasterize an SVG to the iOS + web/PWA PNG set |
| `SETUP.md` | How to install the skill into a project |

## Quick start

1. Install the skill (see `SETUP.md`) — or just read `GUIDE.md` and copy the templates.
2. In any project, invoke `/brand-identity` and describe the product.
3. The skill establishes a concept (name → metaphor → one shape), builds the mark from
   `mark.template.svg`, generates a token theme from `theme.template.css`, and wires the
   SVG into the app (favicon, push, OAuth, manifest, mobile raster icons).

## Reference implementation

- Mark (flower, the logo): `BSKY/public/asphodel-icon.svg`
- Small/favicon variant: `BSKY/public/asphodel-icon-small.svg`
- Layered variant (butterfly, advanced example): `BSKY/public/butterfly-icon.svg`
- Theme: `BSKY/src/styles/asphodel-theme.css`
- Wordmark: `.asph-gradient-text` (clipped gradient text)
