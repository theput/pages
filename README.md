# pages/

A general-purpose, no-extra-cost publishing space for anything in Constellation
that deserves a visible, shareable web page: hardware schematics and build
diaries, excerpts from the Putnam biography, writeups, reference docs — anything
worth a URL. Niimbot label QR codes are one consumer of this space, not the only
one.

## How it works

Each subfolder under `pages/` is one published page, served at:

```
https://<yourdomain>.github.io/pages/<folder-name>
```

The site is published from this repo via GitHub Pages. Once Pages is enabled and
a domain is set, every folder here becomes a live URL automatically — no build
step to think about, no per-page cost.

## Publishing workflow

1. **Start a page.** Copy `_template/` to a new folder named for the page, e.g.
   `cp -r _template my-new-page`. The folder name becomes the URL slug, so keep
   it short and lowercase-with-hyphens.
2. **Write it.** Edit the folder's `index.md`. Keep the page self-contained:
   the markdown plus any images live together in that one folder.
3. **Add images/diagrams** directly inside the page's folder (or a subfolder
   like `schematics/`), and reference them with relative links so they travel
   with the page.
4. **List it.** Add a line for the new page to `pages/index.md` so it shows up
   on the landing page.
5. **Publish.** Commit and push. GitHub Pages serves the update.

## Conventions

- One subfolder = one published page.
- Each page is self-contained: markdown plus its own images, nothing reaching
  into a sibling folder.
- No fixed category list. Projects, parts, writing, reference — anything can
  live here. Organize by what the page *is*, not by a rigid taxonomy.
- Use `_template/` as the starting point for anything new. Folders prefixed with
  `_` are scaffolding, not published pages.

## What's here

- `index.md` — the landing page listing everything currently published.
- `_template/` — blank starter page; copy it when adding anything new.
- `milton/` — Milton the Radio build diary (first live page).
