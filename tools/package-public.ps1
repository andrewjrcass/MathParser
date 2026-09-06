param(
  [string]$Root = '',
  [string]$OutputDir = ''
)

$ErrorActionPreference = 'Stop'
$publicRepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if ([string]::IsNullOrWhiteSpace($Root)) {
  throw 'Pass -Root pointing to the private sealed MathParser 2.0.7.139 workspace.'
} else {
  $Root = (Resolve-Path $Root).Path
}

$versionFile = Join-Path $Root 'VERSION'
if (-not (Test-Path -LiteralPath $versionFile)) {
  throw "VERSION not found under MathParser root: $Root"
}
$version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
if ($version -ne '2.0.7.139') {
  throw "Refusing public 2.0.7.139 package from VERSION=$version"
}

$binaryDir = Join-Path $Root 'build\bin'
if (-not (Test-Path -LiteralPath $binaryDir)) {
  throw "Staged Windows runtime not found: $binaryDir"
}

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
  $OutputDir = Join-Path $Root 'dist-public'
}

$packageName = "MathParser-$version-Windows-x64-Portable"
$packageDir = Join-Path $OutputDir $packageName
$zipPath = Join-Path $OutputDir "$packageName.zip"

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
if (Test-Path -LiteralPath $packageDir) { Remove-Item $packageDir -Recurse -Force }
if (Test-Path -LiteralPath $zipPath) { Remove-Item $zipPath -Force }
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

$requiredFiles = @(
  'mathparser_gui.exe',
  'console_app.exe',
  'console_core.exe',
  'WebView2Loader.dll',
  'locale_en.ini',
  'locale_pt.ini',
  'VERSION'
)
foreach ($file in $requiredFiles) {
  $src = Join-Path $binaryDir $file
  if (-not (Test-Path -LiteralPath $src)) {
    throw "Missing staged runtime file: $src"
  }
  Copy-Item -LiteralPath $src -Destination $packageDir -Force
}

foreach ($dir in @('assets','themes','extensions','help')) {
  $src = Join-Path $binaryDir $dir
  if (-not (Test-Path -LiteralPath $src)) {
    throw "Missing staged runtime directory: $src"
  }
  Copy-Item -LiteralPath $src -Destination (Join-Path $packageDir $dir) -Recurse -Force
}

# Public documentation is sourced only from this public repository.
foreach ($doc in @('README.md','MANUAL.md','ROADMAP.md')) {
  $src = Join-Path $publicRepoRoot $doc
  if (-not (Test-Path -LiteralPath $src)) { throw "Public document missing: $src" }
  Copy-Item -LiteralPath $src -Destination (Join-Path $packageDir $doc) -Force
}

# The runtime already carries the third-party license notices beside KaTeX/Plotly.
foreach ($license in @('assets\katex\LICENSE','assets\plotly\LICENSE')) {
  $src = Join-Path $packageDir $license
  if (-not (Test-Path -LiteralPath $src)) { throw "Third-party license missing: $src" }
}

$forbiddenExtensions = @(
  '.pas','.pp','.inc','.lpi','.lpr','.lfm','.lpk','.py','.pyc',
  '.zip','.7z','.rar','.tar','.gz'
)

# Public native examples from the sealed workspace. The public profile excludes
# Python-bridge examples and internal Integration regression artifacts.
$examplesSrc = Join-Path $Root 'examples'
if (-not (Test-Path -LiteralPath $examplesSrc)) {
  throw "Examples directory missing: $examplesSrc"
}
$examplesDst = Join-Path $packageDir 'examples'
New-Item -ItemType Directory -Path $examplesDst -Force | Out-Null

Get-ChildItem -LiteralPath $examplesSrc -Recurse -File | ForEach-Object {
  $relative = $_.FullName.Substring($examplesSrc.Length).TrimStart('\','/')
  $parts = $relative -split '[\\/]'
  $name = $_.Name.ToLowerInvariant()

  if ($parts[0] -in @('python_bridge','Integration')) { return }
  if ($name -in @('python_demo.py','python_demo.mps','python_demo.mpproj')) { return }
  if ($_.Extension.ToLowerInvariant() -in $forbiddenExtensions) { return }
  if ($relative -eq 'README.md') { return }

  $destination = Join-Path $examplesDst $relative
  New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
  Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
}

$examplesReadme = @'
# MathParser — Examples

This directory contains native examples shipped with MathParser 2.0.7.139.

Open any `.mps` file directly in `mathparser_gui.exe`, or execute it with:

    console_app.exe examples\notebook_demo.mps

The `lib/`, `groups/`, `imageLib/` and `extension_packages/` directories contain support files used by some examples.

Python-bridge examples are intentionally not included in this binary-only public distribution.
'@
Set-Content -LiteralPath (Join-Path $examplesDst 'README.md') -Value $examplesReadme -Encoding utf8

# Public profile intentionally excludes Python bridge/source scripts and all
# development/source files or nested archives.
$forbidden = Get-ChildItem -LiteralPath $packageDir -Recurse -File | Where-Object {
  $_.Extension.ToLowerInvariant() -in $forbiddenExtensions
}
if ($forbidden) {
  $names = ($forbidden | ForEach-Object { $_.FullName }) -join [Environment]::NewLine
  throw "Public package contains forbidden source/development files:`n$names"
}

$packagedVersion = (Get-Content -LiteralPath (Join-Path $packageDir 'VERSION') -Raw).Trim()
if ($packagedVersion -ne $version) {
  throw "Packaged runtime VERSION mismatch: $packagedVersion != $version"
}

Compress-Archive -LiteralPath $packageDir -DestinationPath $zipPath -CompressionLevel Optimal
$hash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
$hashFile = Join-Path $OutputDir 'SHA256SUMS.txt'
"$hash  $([System.IO.Path]::GetFileName($zipPath))" | Set-Content -LiteralPath $hashFile -Encoding ascii

Write-Host "Public portable package created:"
Write-Host "  $zipPath"
Write-Host "SHA256:"
Write-Host "  $hash"
Write-Host "Checksums:"
Write-Host "  $hashFile"
