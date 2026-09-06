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
  'eval1.exe',
  'mathparser_gui.exe',
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

# Public project presentation comes from the public distribution repository,
# never from internal/private engineering documents.
$publicReadme = Join-Path $publicRepoRoot 'README.md'
if (-not (Test-Path -LiteralPath $publicReadme)) { throw "Public README missing: $publicReadme" }
Copy-Item -LiteralPath $publicReadme -Destination (Join-Path $packageDir 'README.md') -Force

# Keep the established release contract: ROADMAP accompanies binary packages.
$roadmap = Join-Path $Root 'ROADMAP.md'
if (-not (Test-Path -LiteralPath $roadmap)) { throw "ROADMAP missing: $roadmap" }
Copy-Item -LiteralPath $roadmap -Destination (Join-Path $packageDir 'ROADMAP.md') -Force

# User manual entry + full offline PT/EN Help.
$manual = Join-Path $Root 'docs\MANUAL.md'
if (-not (Test-Path -LiteralPath $manual)) { throw "Manual missing: $manual" }
Copy-Item -LiteralPath $manual -Destination (Join-Path $packageDir 'MANUAL.md') -Force

# Third-party notices shipped with renderer assets.
$licensesDir = Join-Path $packageDir 'licenses'
New-Item -ItemType Directory -Path $licensesDir -Force | Out-Null
$thirdPartyLicenses = @(
  @{ Source = (Join-Path $binaryDir 'assets\katex\LICENSE'); Target = 'KaTeX-LICENSE.txt' },
  @{ Source = (Join-Path $binaryDir 'assets\plotly\LICENSE'); Target = 'Plotly-LICENSE.txt' }
)
foreach ($item in $thirdPartyLicenses) {
  if (-not (Test-Path -LiteralPath $item.Source)) { throw "Third-party license missing: $($item.Source)" }
  Copy-Item -LiteralPath $item.Source -Destination (Join-Path $licensesDir $item.Target) -Force
}

# Public profile intentionally excludes the Python bridge/source scripts.
# User-facing examples may be copied, but source/development extensions and
# nested archives are rejected.
$forbiddenExtensions = @(
  '.pas','.pp','.inc','.lpi','.lpr','.lfm','.lpk','.py',
  '.zip','.7z','.rar','.tar','.gz'
)
$examples = Join-Path $Root 'examples'
if (Test-Path -LiteralPath $examples) {
  $publicExamples = Join-Path $packageDir 'examples'
  New-Item -ItemType Directory -Path $publicExamples -Force | Out-Null
  Get-ChildItem -LiteralPath $examples -Recurse -File | ForEach-Object {
    if ($_.Extension.ToLowerInvariant() -notin $forbiddenExtensions) {
      $relative = $_.FullName.Substring($examples.Length).TrimStart('\','/')
      $destination = Join-Path $publicExamples $relative
      New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
      Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
    }
  }
}

$forbidden = Get-ChildItem -LiteralPath $packageDir -Recurse -File | Where-Object {
  $_.Extension.ToLowerInvariant() -in $forbiddenExtensions
}
if ($forbidden) {
  $names = ($forbidden | ForEach-Object { $_.FullName }) -join [Environment]::NewLine
  throw "Public package contains forbidden source/development files:`n$names"
}

# Runtime metadata must still be 2.0.7.139 after copying.
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
