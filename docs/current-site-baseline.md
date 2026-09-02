# Current site baseline

Recorded before structural refactoring on 2 September 2026.

## Repository state

- Branch: `main`
- Baseline commit: `29f8283a1b5102503c1d5515fec8ca826f5e1877`
- Locally known upstream: `origin/main` at the same commit
- Production domain: <https://weaponisedpasts.org>
- Hosting/build system: GitHub Pages and Jekyll
- Custom domain file: `CNAME`

The working tree was clean before Batch A began.

## Public URLs that must be preserved

| Content | URL |
| --- | --- |
| Home | `https://weaponisedpasts.org/` |
| Project | `https://weaponisedpasts.org/project.html` |
| People | `https://weaponisedpasts.org/people.html` |
| Contact | `https://weaponisedpasts.org/contact.html` |
| News | `https://weaponisedpasts.org/news/` |
| Welcome post | `https://weaponisedpasts.org/news/welcome/` |
| Job advertisement | `https://weaponisedpasts.org/news/job_advertisement/` |
| EAA call | `https://weaponisedpasts.org/news/calls_for_submission_eaa/` |

Existing URLs will not be renamed during layout or blogging-infrastructure work.

## Current page structure

- `index.html`, `project.html`, `people.html`, and `contact.html` are complete,
  hand-written HTML documents.
- `news.html` contains Jekyll front matter and loops through `site.posts`.
- Markdown posts in `_posts/` use `_layouts/post.html`.
- Header, navigation, footer, and script markup are duplicated across pages.
- The post layout contains an empty placeholder footer rather than the full site
  footer.

## Current visual system

- Base theme: Alpha by HTML5 UP.
- Main typeface: Inter, loaded from Google Fonts.
- Principal custom colours:
  - Red: `#933222`
  - Cream: `#F4E7DC`
  - Navy: `#37464F`
- Header: cream background with project logo and Home/About/News navigation.
- Hero sections: full-width photographic backgrounds with centered white text.
- Content: white cards on a light grey page background.
- Footer: navy contact/social/navigation section followed by a cream partner-logo
  bar.

## Measured repository inventory

- 165 tracked files before Batch A.
- Approximately 39.67 MB in the working tree.
- 113 image files using approximately 36.28 MB.
- A reference scan identified 87 images, approximately 29.23 MB, as apparently
  unused. This is only a heuristic; no image may be deleted without manual review
  and approval.
- `assets/sass/main.scss` contained 3,317 lines.
- `assets/css/main.css` contained 5,196 generated lines.
- Approximately 1,148 lines at the end of `main.scss` were project-specific
  additions.
- The custom Sass contained three `.hero` definitions and multiple repeated
  footer and logo-bar sections.

## Completed baseline validation

Validation was completed on 2 September 2026 using Ruby 3.3.12, Bundler 2.6.9,
Jekyll 3.10.0, and the GitHub Pages 232 dependency set.

- A clean local Jekyll build completed successfully.
- All eight URLs/routes above rendered locally.
- Each route was captured at desktop and mobile viewport sizes. The 16 reference
  PNGs are in `docs/baseline-screenshots/`.
- The local and live versions of every route had identical visible text, browser
  title, and H1 output at the time of comparison.
- The original News loop produced a non-fatal Liquid syntax warning. Its filter
  pipeline was moved into an `assign` statement; the subsequent build was clean
  and the News page's visible output still matched production.
- Jekyll prints an optional Faraday retry-middleware notice. It does not affect
  the build, and no extra dependency is required for this site.

The screenshots record the existing site, including current defects. In
particular, the ordinary HTML pages have no `lang` attribute; several pages use
an empty logo H1 as well as a content H1; the post layout uses an empty logo H1
and a lower-level article title; `people.html` repeats `id="main"`; and the EAA
post supplies an additional content H1. These are backlog items, not Batch A
visual changes.

No visual redesign was made in Batch A.
