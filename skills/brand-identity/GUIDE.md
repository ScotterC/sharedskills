# Brand Identity Guide — the Asphodel method

How the Asphodel (ShadowSky) logo and theme were built, written so any project can
reproduce the *approach* rather than copy the artwork. Two ideas do all the work:

1. **One shape, many rotations** — a memorable mark from a single SVG path.
2. **A token system** — one primary + one accent color, expressed as CSS variables,
   drive the entire UI (light, dark, and high-contrast).

---

## Part 1 — The single-path radial mark

### The core trick

A strong mark from **one path**. Draw a single primitive once, then **rotate copies of
it around a shared center** and recolor. The Asphodel logo is a six-petal flower: one
lens-shaped petal, drawn six times at 60° intervals, plus a center dot.

```svg
<svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <!-- Rounded-square plate. rx ≈ viewBox/5.3 gives the iOS-ish squircle feel. -->
  <rect width="512" height="512" rx="96" fill="#f5f0e8"/>

  <!-- One group sets the shared center; each petal is the SAME path, rotated 60°. -->
  <g transform="translate(256,256)">
    <g transform="rotate(0)">  <path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#a898cd"/></g>
    <g transform="rotate(60)"> <path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#d698a6"/></g>
    <g transform="rotate(120)"><path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#cfb575"/></g>
    <g transform="rotate(180)"><path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#84c1ab"/></g>
    <g transform="rotate(240)"><path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#8ba5c6"/></g>
    <g transform="rotate(300)"><path d="M0,-30 Q-76,-105 0,-180 Q76,-105 0,-30Z" fill="#d6b382"/></g>
    <circle r="22" fill="#8a7850"/>
  </g>
</svg>
```

The petal path is one lens: from an inner tip at `0,-30`, out to a point at `0,-180`,
the two quadratic curves bulging to a half-width of ~38 at the middle. You never redraw
it — six fills, one geometry. Edit the path once and all six petals update together.

Differentiation between the copies comes from exactly two things:

- **`rotate()`** — where each copy points. Even spacing (here, a clean 60°) reads as
  calm and symmetric; a master tilt on the parent group reads as motion.
- **draw order** — SVG has no z-index; later elements paint on top (painter's
  algorithm). For non-overlapping petals it doesn't matter; the moment copies overlap,
  **order is depth** (see the layered variant below).

### Advanced: the layered variant (one shape, two readings)

The same trick composes a richer mark when copies overlap *and* the primitive does
double duty. An earlier Asphodel mark was a butterfly alighting on the flower — and the
butterfly's **wing is the same teardrop as the flower's petal**. One path, two roles:

```svg
<g transform="translate(256,262) rotate(35)">  <!-- shared center + master tilt -->
  <!-- Flower petals: drawn FIRST → behind. -->
  <g transform="rotate(175)"><path d="M0,-30 C-46,-62 -52,-136 0,-180 C52,-136 46,-62 0,-30Z" fill="#e8e0d0"/></g>
  <!-- ... -->
  <!-- Hindwings: same path, scaled 0.91, drawn behind the forewings so they peek out. -->
  <g transform="rotate(336) scale(0.91)"><path d="..." fill="#e4eaf2"/></g>
  <!-- Forewings: full size, on top, BRIGHTEST color → the focal point. -->
  <g transform="rotate(355)"><path d="..." fill="#5fb5d8"/></g>
  <!-- Finish with 1–2 strokes: body along the tilt, stem opposite it. -->
  <g transform="rotate(30)"><path d="M0,-10 Q1.2,-32 0,-54" stroke="#c8d8e8" stroke-width="3" fill="none"/></g>
</g>
```

What makes the layered variant work:

- **The double reading** — the concept is encoded *structurally*, not decoratively. The
  wing and the petal are the same geometry, so the eye registers the rhyme before the
  brain names it. That shared DNA is what makes a mark feel designed, not assembled.
- **Depth from draw order + scale** — background petals first, midground copies scaled
  ~0.9 and drawn behind, the brightest pair full-size on top.

The plain flower is the better *default*: pure, symmetric, almost no source. Reach for
the layered variant only when your product name offers a genuine two-role shape.

### How to build your own

1. **Name → metaphor.** Find a noun in (or evoked by) the product name with a simple
   silhouette. "Asphodel" → a flower → petals → a lens. Aim for one primitive shape,
   not a scene.
2. **Draw the primitive once**, pointing up from the origin, ending near the center so
   rotated copies meet cleanly. Keep it to 2 Bézier curves if you can.
3. **Compose by rotation.** Wrap each copy in `<g transform="rotate(N)">`. Even spacing
   (the flower's 60°) reads as calm and symmetric; a master tilt on the parent group
   reads as motion.
4. **Color the copies.** A different fill per copy (the flower's six pastels) or one
   repeated fill — your call. Add a center element (a dot) if the petals leave a gap.
5. **(Optional, advanced) Go layered.** If the name offers a genuine two-role shape,
   reuse the primitive for both (petal = wing) and overlap copies: layer back-to-front —
   background elements first, midground scaled ~0.9, the brightest pair full-size on
   top — and finish with 1–2 strokes (a body, a stem) for "hand."
6. **Test at 16px.** App icons live in tab bars and favicons. If it muddies when small,
   reduce element count, raise contrast against the plate, or ship a bolder small
   variant (see Part 4).

### Geometry cheatsheet

| Want | Do |
| --- | --- |
| Squircle plate | `<rect rx="{viewBox/5.3}">` (96 on a 512 grid) |
| Shared center | one parent `<g transform="translate(cx,cy)">` |
| Overall energy | `rotate(θ)` on the parent — flower stays at 0° (symmetry); butterfly variant uses 35° (motion) |
| Even radial petals | rotate copies by `360/N` (flower: six at 60°) |
| Depth | order in source = stacking order; no z-index in SVG |
| "Behind" elements | same path + `scale(0.85–0.92)`, drawn earlier |
| Focal point | brightest / most-saturated fill, drawn last |

---

## Part 2 — The token-driven theme

The mark gives you a logo. The token system makes the whole app feel like it belongs
to that logo. Asphodel's entire palette derives from **one primary and one accent**:

```css
--asph-primary: #ff6b9d;   /* vibrant pink  */
--asph-accent:  #7c3aed;   /* deep purple   */
```

### Principles that made it scale

- **Everything is a variable.** Colors, shadows, motion durations, easing curves,
  letter-spacing — all `--asph-*` tokens on `:root`. Components reference tokens, never
  literals. Re-skinning the app = editing one file.
- **Semantic, not literal, names.** `--asph-text-secondary`, `--asph-like`,
  `--asph-success` — named by *role*. Swapping the hex never touches a component.
- **Themes are token overrides.** `.dark`, `[data-high-contrast="true"]`, and
  `@media (prefers-contrast: more)` redefine the *same* token names. Components are
  written once and inherit every theme for free.
- **A motion vocabulary, too.** Durations (`--transition-fast: 150ms`) and named
  easings (`--ease-spring-soft`, `--ease-bounce`) live beside colors, so interactions
  are as consistent as the palette. `@media (prefers-reduced-motion)` collapses them
  globally.
- **Accessibility is a first-class theme.** Dedicated high-contrast light/dark blocks
  hit WCAG AAA (7:1), plus a token-based focus-ring system. Built in from the start,
  not bolted on.

### The gradient-text wordmark

The "Asphodel" wordmark is the two brand colors as clipped gradient text — no image:

```css
.asph-gradient-text {
  background: linear-gradient(135deg, var(--asph-primary) 0%, var(--asph-accent) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

An animated variant uses a 3-stop gradient at `background-size: 200%` so it can shift
on hover. The `-webkit-` prefixes are required (Safari/Chromium); keep both.

### Minimum viable token file

See `templates/theme.template.css`. Define `:root`, override under `.dark`, add a
high-contrast block, and reference tokens everywhere. Start with ~15 tokens; grow as
real needs appear — don't pre-build 200.

---

## Part 3 — Wiring it into an app

- **Ship the SVG as a static asset** (`public/icon.svg`) and import it as a URL:
  `import appIcon from "/icon.svg"` → `<img src={appIcon} alt="Brand" />`. Vector,
  cache-friendly, recolorable by editing one file.
- **Reuse it for system surfaces:** favicon, web-push `icon`/`badge`, OAuth
  `logo_uri`, PWA manifest.
- **Raster only where required.** iOS/Android app icons need PNGs (e.g.
  120/152/167/180 px, plus mono/tinted variants). Render the SVG to PNG at build/export
  time; keep the SVG as the source of truth. Use the bundled `export-icons.sh`:

  ```bash
  ./export-icons.sh path/to/icon.svg ./icons   # emits the iOS + web/PWA PNG set
  ```

  It auto-selects the best rasterizer installed (`rsvg-convert` > `inkscape` > `magick`
  > macOS `qlmanage`). Install `librsvg` for the crispest output: `brew install librsvg`.
- **Always set `alt`** on the logo `<img>` for screen readers.

> `templates/mark.preview.png` is a rendered preview of `mark.template.svg` — what the
> starter mark looks like before you make it yours.

---

## Part 4 — The refinement pass

A first-draft mark is rarely the shipping mark. These are the highest-leverage,
lowest-risk polish moves — learned from refining the Asphodel icon after it was already
loved. Do them on a *copy*, render before/after, and compare; don't edit a beloved mark
blind.

### Render-and-look is the whole method

You cannot judge a mark in source. **Rasterize it and look — especially small.** Use
`export-icons.sh` (or `qlmanage -t -s 64 -o . icon.svg` on macOS) to render at 512, 64,
32, and 16px every time you change something. Most flaws only appear at size:

- **At 16–32px**, overlapping elements merge into a blob and thin strokes vanish.
- **At 512px**, value clashes and flatness become obvious.

### 1. Ship a two-mark system (responsive logo)

A detailed mark that sings at 512px turns to mush in a favicon or tab bar. The fix is
the industry-standard move: **two marks, not one.**

- **Hero mark** — full detail, for sidebars, landing pages, app icons ≥120px.
- **Small mark** — a simplified sibling for ≤32px: drop the thin strokes and the
  lowest-contrast / most-redundant elements (Asphodel's small variant drops the body,
  stem, and pale hindwings — 8 leaves → 6), then scale the remainder up ~8% to reclaim
  the visual reach you removed. Same geometry, fewer parts, more air.

Keep both as separate SVGs (`icon.svg`, `icon-small.svg`) and wire the small one to the
favicon.

### 2. Separate near-equal values

Two fill colors at nearly the same *lightness* (not hue — lightness) muddy together where
they touch, even if the hues differ. Squint at the mark: if two shapes blur into one, push
them apart in value — make one warmer/darker, the other cooler/lighter. Asphodel's cream
`#e8e0d0` and pale-lavender hindwing `#e4eaf2` were near-identical in lightness; nudging
the cream warmer/darker (`#ddcfb4`) and the wing cooler (`#dde6f2`) made the layering read.

### 3. Add depth with a plate gradient

A flat background plate looks dated beside the gradient-heavy icons it sits next to on a
home screen. A *subtle* vertical gradient (Asphodel: `#1c2240` → `#0f1224`) reads flat at
a glance but premium up close. Keep the two stops close in hue; a strong gradient looks
cheap.

### 4. Make strokes survive downscaling

Hairline strokes (the body, a stem, a horizon) are the first thing to disappear when an
icon shrinks. Give them enough weight to survive (Asphodel bumped stem 3→4, body 2.5→3),
and shorten any stroke that reaches toward a corner so it doesn't crowd the squircle. If a
stroke can't survive at all, it belongs only on the hero mark — see #1.

### 5. Use focal gradients sparingly

A tip-lighter gradient on the focal element adds dimension — but it trades away the flat
purity that makes a modern mark feel crisp. Make it opt-in, not default, and only if the
flat version already works.

---

## Checklist for a new project

- [ ] Name → metaphor → one primitive shape (with a double reading if possible)
- [ ] One reusable path, composed by `rotate()` around a shared center
- [ ] Back-to-front layering; brightest color on the focal element, drawn last
- [ ] Squircle plate (`rx ≈ size/5.3`) if you want an app-icon feel
- [ ] **Rendered and eyeballed at 512 / 64 / 32 / 16px** — not judged in source
- [ ] No two fills muddy together (separate near-equal values)
- [ ] Subtle plate gradient for depth (close-hue stops)
- [ ] Strokes thick enough to survive downscaling; none crowd the corners
- [ ] A simplified **small/favicon variant** exists for ≤32px (two-mark system)
- [ ] Legible at 16px
- [ ] One primary + one accent color chosen
- [ ] Token theme file: `:root` + `.dark` + high-contrast, semantic names
- [ ] Gradient-text wordmark via `background-clip: text`
- [ ] Motion tokens + `prefers-reduced-motion` honored
- [ ] SVG shipped as static asset; reused for favicon / push / OAuth / manifest
- [ ] Raster icons exported from the SVG for mobile
