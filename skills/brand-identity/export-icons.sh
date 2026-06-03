#!/usr/bin/env bash
# export-icons.sh — rasterize a brand SVG to the PNG sizes apps actually need.
#
# Usage:
#   ./export-icons.sh path/to/icon.svg [out_dir]
#
# Outputs (into out_dir, default ./icons):
#   App Store / master:  icon-1024.png
#   iOS app icon:        icon-180.png 167 152 120
#   Web / PWA:           favicon-16.png 32 48, apple-touch-180.png, pwa-192.png 512
#
# The SVG is the source of truth — re-run this whenever the SVG changes.
# Picks the best rasterizer available: rsvg-convert > inkscape > magick > qlmanage(macOS).

set -euo pipefail

SVG="${1:-}"
OUT="${2:-./icons}"

if [[ -z "$SVG" || ! -f "$SVG" ]]; then
  echo "usage: $0 path/to/icon.svg [out_dir]" >&2
  exit 1
fi
mkdir -p "$OUT"

# Sizes to emit: "<pixels>:<filename>"
SIZES=(
  "1024:icon-1024.png"
  "180:icon-180.png"
  "167:icon-167.png"
  "152:icon-152.png"
  "120:icon-120.png"
  "512:pwa-512.png"
  "192:pwa-192.png"
  "180:apple-touch-180.png"
  "48:favicon-48.png"
  "32:favicon-32.png"
  "16:favicon-16.png"
)

# Detect a rasterizer once.
RASTER=""
if command -v rsvg-convert >/dev/null 2>&1; then RASTER="rsvg"
elif command -v inkscape   >/dev/null 2>&1; then RASTER="inkscape"
elif command -v magick     >/dev/null 2>&1; then RASTER="magick"
elif command -v qlmanage   >/dev/null 2>&1; then RASTER="qlmanage"
else
  echo "No SVG rasterizer found. Install one:" >&2
  echo "  brew install librsvg     # rsvg-convert (recommended, crispest)" >&2
  echo "  brew install imagemagick # magick" >&2
  echo "  npm i -g @resvg/resvg-js # or use sharp in a Node script" >&2
  exit 1
fi
echo "Rasterizing $SVG with: $RASTER"

render() { # render <px> <outfile>
  local px="$1" out="$2"
  case "$RASTER" in
    rsvg)     rsvg-convert -w "$px" -h "$px" -o "$out" "$SVG" ;;
    inkscape) inkscape "$SVG" --export-type=png --export-width="$px" \
                --export-height="$px" --export-filename="$out" >/dev/null 2>&1 ;;
    magick)   magick -background none -density 384 "$SVG" -resize "${px}x${px}" "$out" ;;
    qlmanage) # qlmanage writes <svgname>.png into a dir; render then move + downscale.
              local tmp; tmp="$(mktemp -d)"
              qlmanage -t -s "$px" -o "$tmp" "$SVG" >/dev/null 2>&1
              mv "$tmp/$(basename "$SVG").png" "$out"
              command -v sips >/dev/null 2>&1 && sips -z "$px" "$px" "$out" >/dev/null 2>&1 || true
              rm -rf "$tmp" ;;
  esac
}

for entry in "${SIZES[@]}"; do
  px="${entry%%:*}"; name="${entry##*:}"
  render "$px" "$OUT/$name"
  echo "  → $OUT/$name (${px}px)"
done

echo "Done. ${#SIZES[@]} icons written to $OUT"
echo "Note: qlmanage is the lowest-quality fallback — prefer rsvg-convert for shipping icons."
