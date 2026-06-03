---
name: brand-identity
description: Create a distinctive logo mark and a token-based theme for a project, using the "Asphodel method" — one reusable SVG path composed by rotation, plus a one-primary/one-accent CSS variable system with light/dark/high-contrast themes. Use when a user wants a logo, app icon, brand mark, wordmark, or a cohesive color/design-token system for an app.
---

# Brand Identity (the Asphodel method)

Build a memorable logo and a cohesive theme from two ideas:

1. **One shape, many rotations** — a strong mark from a single SVG path, recolored and
   reordered, never redrawn.
2. **One primary + one accent** — every color/motion value is a CSS variable; themes
   are just token overrides.

Full rationale and annotated source: read `./GUIDE.md` (next to this file) before deep
work. Starter files: `./templates/mark.template.svg`, `./templates/theme.template.css`.

## When to use

A user asks for a logo, app icon, favicon, brand mark, wordmark, or a design-token /
theming system — or wants their app to "look like it belongs together."

## Procedure

### 1. Establish the concept (ask, don't assume)
- Get the product name and one-line vibe (playful? technical? calm?).
- Derive a **metaphor**: a noun in/around the name with a *simple silhouette*. Default to
  **one primitive repeated radially** (Asphodel: a lens petal × 6 → a flower). Propose
  1–2 concepts and confirm before drawing.
- **(Optional, advanced) Double reading** — if the name offers a shape that can play two
  roles at once (a teardrop as both flower-petal and butterfly-wing), reuse one primitive
  for both and overlap them. Powerful, but the plain radial mark is the better default.
- Pick **one primary + one accent** color.

### 2. Build the mark — one path, composed by rotation
- Draw ONE primitive path pointing up from the origin, ending near center so rotated
  copies meet cleanly (keep to ~2 Bézier curves). Start from `mark.template.svg`.
- Use a `viewBox="0 0 512 512"` and a squircle plate `<rect rx="96">` for app-icon feel.
- Wrap each copy in `<g transform="rotate(N)">` inside ONE parent
  `<g transform="translate(256,262) rotate(θ)">` (a master tilt like 35° adds motion).
- **Layer back-to-front** — SVG has no z-index; source order = depth. Background
  elements first; scale midground copies to ~0.9 so they peek out; draw the focal
  element last in the **brightest** color.
- Finish with 1–2 `stroke` paths (body, stem, horizon) — not fills.
- **Verify legibility at 16px.** Reduce element count or raise contrast if it muddies.

### 3. Build the theme — tokens, not literals
- Start from `theme.template.css`. Define `:root` with semantic, role-named tokens
  (`--brand-primary`, `--text-secondary`, `--success`…), NOT literal names.
- Add a `.dark` (or `[data-theme="dark"]`) block that **overrides the same token
  names**. Add a high-contrast block targeting WCAG AAA (7:1) if accessibility matters.
- Include motion tokens (durations + named easings) and honor
  `@media (prefers-reduced-motion: reduce)`.
- Components must reference tokens only — never hardcode hex.

### 4. Wordmark
- Render the brand name as clipped gradient text (no image):
  `background: linear-gradient(135deg, var(--brand-primary), var(--brand-accent));
  -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;`
  Keep the `-webkit-` prefixes.

### 5. Wire it in
- Ship the SVG as a static asset (e.g. `public/icon.svg`); import as a URL and render
  in `<img alt="...">`. Reuse it for favicon, web-push icon/badge, OAuth `logo_uri`,
  PWA manifest.
- Export PNG raster icons from the SVG for mobile + web with the bundled script:
  `./export-icons.sh path/to/icon.svg ./icons` (iOS 120/152/167/180 + 1024, favicons, PWA).

### 6. Refinement pass (do this on a COPY, never edit a loved mark blind)
You cannot judge a mark in source — **rasterize and look, especially small.** Render at
512 / 64 / 32 / 16px (`./export-icons.sh icon.svg ./icons`, or
`qlmanage -t -s 64 -o . icon.svg` on macOS) after every change, then apply the
high-leverage, low-risk moves:
- **Two-mark system:** a detailed mark mushes at favicon size. Ship a simplified
  `icon-small.svg` for ≤32px — drop the thin strokes and lowest-contrast/redundant
  elements, scale the rest up ~8% — and keep the detailed mark for ≥120px.
- **Separate near-equal values:** two fills at nearly the same *lightness* muddy where
  they touch. Push one warmer/darker, the other cooler/lighter.
- **Plate gradient for depth:** a subtle, close-hue vertical gradient beats a flat plate
  beside other home-screen icons. Keep it subtle — strong gradients look cheap.
- **Stroke survivability:** thin strokes vanish on downscale — give them weight, and
  shorten any that crowd a corner. If a stroke can't survive small, put it only on the
  hero mark.
- **Focal gradient:** optional premium touch (tip-lighter on the focal shape); opt-in
  only, since it trades away flat purity.
- Always compare before/after renders with the user before replacing a production mark.

### 7. Verify & ship
- Check both themes and contrast; run the project's build/format checks.
- Regenerate the raster icon set from the final SVG(s) with `export-icons.sh`.

## Guardrails
- One primitive shape beats a clever scene. If you're drawing many distinct paths, stop
  and find the shared geometry.
- Semantic token names over literal ones — re-skinning should touch one file.
- Don't pre-build 200 tokens; start ~15 and grow with real needs.
- Match the host project's conventions (Tailwind vs plain CSS, asset locations).
