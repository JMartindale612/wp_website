[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Title,

    [Parameter(Mandatory = $true)]
    [string]$Summary,

    [ValidateSet("update", "news", "event", "vacancy", "publication")]
    [string]$Type = "update",

    [string]$Author = "Weaponised Pasts team",

    [datetime]$Date = (Get-Date),

    [switch]$Publish
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$slug = $Title.ToLowerInvariant() -replace "[^a-z0-9]+", "-"
$slug = $slug.Trim("-")

if (-not $slug) {
    throw "The title must contain at least one letter or number."
}

if ($Publish) {
    $destinationDirectory = Join-Path $repoRoot "_posts"
    $fileName = "{0}-{1}.md" -f $Date.ToString("yyyy-MM-dd"), $slug
    $status = "published"
}
else {
    $destinationDirectory = Join-Path $repoRoot "_drafts"
    $fileName = "$slug.md"
    $status = "draft"
}

$destination = Join-Path $destinationDirectory $fileName

if (Test-Path -LiteralPath $destination) {
    throw "A post already exists at $destination"
}

New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

$escapedTitle = $Title.Replace('"', '\"')
$escapedSummary = $Summary.Replace('"', '\"')
$escapedAuthor = $Author.Replace('"', '\"')
$postDate = $Date.ToString("yyyy-MM-dd")

$content = @"
---
layout: post
title: "$escapedTitle"
date: $postDate
summary: "$escapedSummary"
description: "$escapedSummary"
# hero_image: /images/replace-with-image.jpg
# hero_alt: "Describe the important content of the hero image"
author: "$escapedAuthor"
type: $Type
tags:
  - project update
status: $status
# expires: YYYY-MM-DD
---

Write the opening paragraph here.

## First section

Continue the article here.
"@

Set-Content -LiteralPath $destination -Value $content -Encoding utf8
Write-Host "Created $destination"

if (-not $Publish) {
    Write-Host "Preview drafts with: bundle exec jekyll serve --livereload --drafts"
}
