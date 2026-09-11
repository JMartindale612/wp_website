[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repositoryRoot

$imageFiles = git ls-files images
$referenced = [System.Collections.Generic.List[string]]::new()
$apparentlyUnused = [System.Collections.Generic.List[string]]::new()

foreach ($imageFile in $imageFiles) {
    $references = git grep -Il -F -- $imageFile -- ':!images' ':!docs' 2>$null
    if ($references) {
        $referenced.Add($imageFile)
    }
    else {
        $apparentlyUnused.Add($imageFile)
    }
}

Write-Output "Referenced images ($($referenced.Count))"
$referenced | Sort-Object
Write-Output ''
Write-Output "Apparently unused images ($($apparentlyUnused.Count))"
Write-Output 'Review these manually before removing anything: this check cannot identify images kept for imminent future use.'
$apparentlyUnused | Sort-Object
