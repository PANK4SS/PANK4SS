#!/usr/bin/env bash
# Render README.md from themes/README.template.md using a theme's config.
# Usage: ./scripts/apply-theme.sh [theme]     (no argument lists the themes)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template="$root/themes/README.template.md"
theme="${1:-}"

list_themes() {
  echo "Available themes:"
  for conf in "$root"/themes/*/theme.conf; do
    dir="$(basename "$(dirname "$conf")")"
    label="$(sed -n 's/^LABEL=//p' "$conf")"
    accent="$(sed -n 's/^ACCENT=//p' "$conf")"
    printf '  %-12s %s (#%s)\n' "$dir" "$label" "$accent"
  done
}

if [ -z "$theme" ]; then
  list_themes
  exit 0
fi

conf="$root/themes/$theme/theme.conf"
if [ ! -f "$conf" ]; then
  echo "Unknown theme: $theme" >&2
  list_themes >&2
  exit 1
fi

conf_get() { sed -n "s/^$1=//p" "$conf" | head -1; }
LABEL="$(conf_get LABEL)"
ACCENT="$(conf_get ACCENT)"
THEME="$theme"
[ -n "$ACCENT" ] || { echo "No ACCENT in $conf" >&2; exit 1; }
[ -n "$LABEL" ] || LABEL="$theme"

missing=0
for asset in PANK4SS.webp About.webp Motif.svg Typing.svg; do
  if [ ! -f "$root/themes/$theme/$asset" ]; then
    echo "Missing asset: themes/$theme/$asset" >&2
    missing=1
  fi
done
[ "$missing" -eq 0 ] || { echo "Aborted: theme '$theme' is incomplete." >&2; exit 1; }

sed -e "s/{{THEME}}/$THEME/g" \
    -e "s/{{LABEL}}/$LABEL/g" \
    -e "s/{{ACCENT}}/$ACCENT/g" \
    "$template" > "$root/README.md"

echo "README.md now uses theme '$theme' ($LABEL, #$ACCENT)."
