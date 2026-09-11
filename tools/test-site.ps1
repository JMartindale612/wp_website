[CmdletBinding()]
param(
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repositoryRoot

function Add-Failure {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$Message
    )

    $Failures.Add($Message)
}

function Test-InternalTarget {
    param(
        [string]$Target,
        [System.IO.FileInfo]$Page,
        [string]$SiteRoot
    )

    $cleanTarget = ($Target -split '[?#]', 2)[0]
    if ([string]::IsNullOrWhiteSpace($cleanTarget) -or $cleanTarget -match '^(?:https?:|mailto:|tel:|javascript:|data:)') {
        return $true
    }

    if ($cleanTarget.StartsWith('/')) {
        $candidate = Join-Path $SiteRoot $cleanTarget.TrimStart('/')
    }
    else {
        $candidate = Join-Path $Page.DirectoryName $cleanTarget
    }

    $alternatives = @(
        $candidate,
        "$candidate.html",
        (Join-Path $candidate 'index.html')
    )

    return ($alternatives | Where-Object { Test-Path -LiteralPath $_ }).Count -gt 0
}

if (-not $SkipBuild) {
    & bundle exec jekyll build
    if ($LASTEXITCODE -ne 0) {
        throw 'Jekyll build failed.'
    }
}

$siteRoot = Join-Path $repositoryRoot '_site'
if (-not (Test-Path -LiteralPath $siteRoot)) {
    throw 'Generated site directory is missing. Run Jekyll build first.'
}

$failures = [System.Collections.Generic.List[string]]::new()
$htmlFiles = Get-ChildItem -Path $siteRoot -Filter '*.html' -Recurse -File

foreach ($page in $htmlFiles) {
    $html = Get-Content -LiteralPath $page.FullName -Raw
    $displayName = $page.FullName.Substring($siteRoot.Length).TrimStart('\', '/')

    foreach ($elementName in @('h1', 'main')) {
        $count = [regex]::Matches($html, "<$elementName\b", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Count
        if ($count -ne 1) {
            Add-Failure $failures "$displayName has $count <$elementName> elements; expected exactly one."
        }
    }

    $ids = [regex]::Matches($html, '\bid\s*=\s*(?:"([^"]+)"|''([^'']+)'')', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) |
        ForEach-Object { if ($_.Groups[1].Success) { $_.Groups[1].Value } else { $_.Groups[2].Value } }
    $duplicateIds = $ids | Group-Object | Where-Object { $_.Count -gt 1 }
    foreach ($duplicateId in $duplicateIds) {
        Add-Failure $failures "$displayName has duplicate id '$($duplicateId.Name)'."
    }

    $images = [regex]::Matches($html, '<img\b[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($image in $images) {
        if ($image.Value -notmatch '\balt\s*=') {
            Add-Failure $failures "$displayName contains an image without an alt attribute."
        }
    }

    $resources = [regex]::Matches($html, '\b(?:href|src)\s*=\s*(?:"([^"]+)"|''([^'']+)'')', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($resource in $resources) {
        $target = if ($resource.Groups[1].Success) { $resource.Groups[1].Value } else { $resource.Groups[2].Value }
        if (-not (Test-InternalTarget -Target $target -Page $page -SiteRoot $siteRoot)) {
            Add-Failure $failures "$displayName references missing internal file '$target'."
        }
    }
}

$requiredPostFields = @('title', 'date', 'summary', 'description', 'author', 'type', 'tags', 'status')
Get-ChildItem -Path (Join-Path $repositoryRoot '_posts') -Filter '*.md' -File | ForEach-Object {
    $post = $_
    $content = Get-Content -LiteralPath $post.FullName -Raw
    $frontMatter = [regex]::Match($content, '\A---\s*\r?\n(?<frontMatter>.*?)\r?\n---', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if (-not $frontMatter.Success) {
        Add-Failure $failures "Post $($post.Name) has no YAML front matter."
        return
    }

    $yaml = $frontMatter.Groups['frontMatter'].Value
    foreach ($field in $requiredPostFields) {
        if ($yaml -notmatch "(?m)^$field\s*:\s*\S") {
            Add-Failure $failures "Post $($post.Name) is missing required '$field' front matter."
        }
    }

    $hasHeroImage = $yaml -match '(?m)^hero_image\s*:\s*\S'
    $hasHeroAlt = $yaml -match '(?m)^hero_alt\s*:\s*\S'
    if ($hasHeroImage -and -not $hasHeroAlt) {
        Add-Failure $failures "Post $($post.Name) has hero_image but no hero_alt."
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    throw "Site validation failed with $($failures.Count) issue(s)."
}

Write-Output "Site validation passed for $($htmlFiles.Count) generated HTML pages."
