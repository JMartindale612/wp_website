# Weaponised Pasts website

This repository contains the public website and news blog for the Weaponised
Pasts research project: <https://weaponisedpasts.org>.

The site is built with [Jekyll](https://jekyllrb.com/) and hosted by GitHub
Pages. The custom domain is recorded in `CNAME`. The `main` branch is the
production branch: pushing a commit to `main` causes GitHub Pages to rebuild and
publish the website.

> **Important:** A direct `git push` from `main` is a production deployment.
> Preview and check changes locally before pushing them.

## Repository map

| Location | Purpose |
| --- | --- |
| `index.html` | Homepage |
| `project.html` | Project description |
| `people.html` | Team, affiliates, and advisory group |
| `contact.html` | Contact and newsletter forms |
| `news.html` | News landing page; Jekyll fills in the post list |
| `_posts/` | Blog posts written in Markdown |
| `_layouts/default.html` | Shared HTML document shell used by every page |
| `_layouts/page.html` | Layout used by the five ordinary site pages |
| `_layouts/post.html` | Article structure used by individual posts |
| `_includes/` | Shared head, header, footer, and JavaScript markup |
| `_data/navigation.yml` | Header and footer navigation links |
| `_data/social.yml` | Social-media links and icons |
| `_data/partners.yml` | Partner names, logos, and alternative text |
| `_config.yml` | Site title, URL, post URLs, and Jekyll settings |
| `images/` | Photographs, logos, and post images |
| `assets/sass/main.scss` | Authoritative editable stylesheet source for now |
| `assets/css/main.css` | CSS generated from `main.scss` |
| `assets/js/` | HTML5 UP theme behaviour and supporting libraries |
| `.vscode/` | VS Code tasks and project settings |

## One-time Windows setup

Install Ruby with DevKit from <https://rubyinstaller.org/downloads/>. The DevKit
is needed by some Ruby packages. This repository has been tested with Ruby
3.3.12. Close and reopen VS Code or Codex after installation so the updated
Windows `PATH` is loaded.

Open PowerShell in this repository and confirm the tools are visible:

```powershell
ruby --version
bundle --version
```

Install the website's project-local Ruby dependencies:

```powershell
bundle install
```

This reads `Gemfile` and creates `Gemfile.lock`. Commit `Gemfile.lock` so everyone
uses the same package versions.

## Preview the complete website locally

From the repository root, run:

```powershell
bundle exec jekyll serve --livereload
```

Then open <http://localhost:4000> in a browser. Keep the terminal running while
you edit. Jekyll rebuilds the site when files change; LiveReload refreshes the
browser automatically.

Stop the server by clicking its terminal and pressing `Ctrl+C`.

In VS Code, the equivalent commands are available from **Terminal → Run Task**:

- **Website: preview** starts the local server.
- **Website: build** performs a one-off build without starting a server.

Do not use VS Code Live Server as the main preview. It can display ordinary HTML
but cannot render Jekyll's post list, layouts, Markdown, or Liquid expressions.

## Edit an ordinary page

1. Open the relevant root file, such as `project.html`.
2. Make the smallest necessary change.
3. Save the file and review it through the local Jekyll preview.
4. Check both a wide desktop window and a narrow mobile-width window.
5. Run `git diff` before committing.

For links, use meaningful link text rather than a raw address or “click here”.
For informative images, add a concise description in the `alt` attribute.
Decorative images may use `alt=""`.

The root HTML files contain only page-specific content. Shared structure is
maintained separately:

- Edit `_data/navigation.yml` for header and footer navigation links.
- Edit `_data/social.yml` for social accounts.
- Edit `_data/partners.yml` for partner names and footer logos.
- Edit `contact_email` in `_config.yml` for the project email address.
- Edit `_includes/header.html` or `_includes/footer.html` only when their shared
  markup needs to change.

Every ordinary page and blog post receives this shared structure automatically.

## Edit or add a blog post

Posts live in `_posts/` and follow this filename pattern:

```text
YYYY-MM-DD-short-lowercase-title.md
```

For example:

```text
2026-09-02-project-update.md
```

Start a new post with YAML front matter followed by Markdown content:

```yaml
---
layout: post
title: "Project update"
date: 2026-09-02
summary: "A short introduction for the News page."
hero_image: /images/example.jpg
hero_alt: "A concise description of the hero image"
author: "Weaponised Pasts team"
tags:
  - project update
status: published
---
```

The current templates do not use all of these fields yet, but this is the target
content format for the planned blog improvements.

Useful Markdown:

```markdown
## Section heading

This is **bold**, this is *italic*, and this is a
[descriptive link](https://example.org).

- First item
- Second item

![Descriptive alternative text]({{ '/images/example.jpg' | relative_url }})
```

Do not add a second top-level `#` heading inside a post: the post layout supplies
the article title. Use `##` for the first heading within the article.

Renaming an existing post can change its public URL. Preserve existing filenames
and URLs unless a redirect has been planned.

### Drafts

Jekyll drafts will eventually live in `_drafts/`. Once that folder is introduced,
preview them with:

```powershell
bundle exec jekyll serve --livereload --drafts
```

## Edit styles

The current repository contains a Sass source file and its previously compiled
CSS. The Sass source is authoritative:

```text
assets/sass/main.scss
```

The compiled files used by the browser are:

```text
assets/css/main.css
assets/css/main.css.map
```

The repository does not yet contain a reproducible Sass build configuration, so
avoid stylesheet changes during Batch A. Do not edit `main.css` independently:
a later Sass compilation would overwrite it. Batch B will make Jekyll compile
the Sass source and will document the replacement workflow before style changes
are made.

## Safe Git workflow

Before starting work:

```powershell
git status
git pull --ff-only
```

- `git status` shows the current branch and changed files.
- `git pull --ff-only` retrieves remote changes but refuses to create an
  unexpected merge commit.

After editing and previewing:

```powershell
git status
git diff
git add path\to\changed-file
git commit -m "Describe the website change"
git push
```

- `git diff` shows exactly what changed.
- `git add` selects files for the commit; add only files you intended to change.
- `git commit` records the selected changes locally.
- `git push` sends the commit to GitHub. On `main`, this publishes the site.

Never use `git push --force` for this repository.

### VS Code Source Control

The same workflow is available from the Source Control icon in VS Code:

1. Review each changed file.
2. Stage only the intended files with the `+` button.
3. Enter a concise commit message and choose **Commit**.
4. Choose **Sync Changes** or **Push**.

## Check a deployment

After pushing to `main`:

1. Open <https://github.com/JMartindale612/wp_website/actions>.
2. Wait for the GitHub Pages deployment to complete.
3. Open <https://weaponisedpasts.org>.
4. Use `Ctrl+F5` if the browser still shows an older cached version.
5. Check the changed page and at least one unaffected page.

GitHub Pages publication can take several minutes.

## Troubleshooting

### `ruby`, `bundle`, or `jekyll` is not recognised

Close and reopen VS Code or Codex after installing Ruby. If the problem remains,
confirm that the Ruby `bin` directory is present in the Windows `PATH`:

```powershell
where.exe ruby
ruby --version
```

If more than one Ruby installation appears, run `ridk use` and select Ruby 3.3
for that terminal before running Bundler commands.

### A gem is missing

Run `bundle install` from the repository root. Use `bundle exec jekyll ...`
rather than a system-wide `jekyll` command so the project uses its locked gems.

### The local preview looks different from GitHub Pages

Run `bundle update github-pages`, review the resulting `Gemfile.lock` change,
rebuild locally, and commit the lockfile only after confirming the site. Do not
update dependencies as part of an unrelated content edit.

### `git pull --ff-only` refuses to continue

Do not force it. Run `git status` and review whether there are local commits or
uncommitted changes before deciding how to reconcile them.

### A GitHub Pages build fails

Open the failed run in the repository's **Actions** tab and read the first Jekyll
error. Fix and test that error locally before pushing another commit.
