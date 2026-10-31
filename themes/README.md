# Themes

The profile README is generated, never edited by hand.

| File | Role |
| --- | --- |
| `themes/README.template.md` | Single source of the README layout and text. |
| `themes/<name>/theme.conf` | Theme identity: folder name, label, accent color. |
| `themes/<name>/*` | Assets of that theme: `PANK4SS.webp`, `About.webp`, `Motif.svg`, `Typing.svg`. |
| `scripts/apply-theme.sh` | Renders `/README.md` from the template plus a theme. |

## Available themes

| Theme | Label | Accent |
| --- | --- | --- |
| `default` | Green Matrix | `#BDF400` |
| `halloween` | Halloween | `#FF6600` |

## Switch theme

```bash
./scripts/apply-theme.sh            # list themes
./scripts/apply-theme.sh halloween  # write README.md with the halloween theme
./scripts/apply-theme.sh default    # back to green
```

The script fails rather than writing a broken README if an asset is missing.

## Add a theme

1. `mkdir themes/<name>`
2. Write `themes/<name>/theme.conf`:
   ```
   THEME=<name>
   LABEL=<Readable Name>
   ACCENT=RRGGBB
   ```
   `ACCENT` is a bare hex value, no `#`: it is injected into the SVG assets, the
   streak card, the stats cards and the activity graph.
3. Copy `Motif.svg` and `Typing.svg` from another theme and swap the accent:
   ```bash
   sed 's/#BDF400/#<ACCENT>/g' themes/default/Motif.svg > themes/<name>/Motif.svg
   ```
4. Add `PANK4SS.webp` (banner, 800 px wide) and `About.webp` (portrait, 400 px wide).
   Source PNG and JPG files are git-ignored on purpose, only the exported WebP is committed:
   ```bash
   cwebp -q 85 -resize 400 0 source.png -o themes/<name>/About.webp
   ```
5. `./scripts/apply-theme.sh <name>`

## Editing the content

Change the wording, the stack icons or the cards in `themes/README.template.md`,
then re-run the script. Placeholders available: `{{THEME}}`, `{{LABEL}}`, `{{ACCENT}}`.
