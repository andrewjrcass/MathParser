param(
  [string]$Root = '',
  [string]$OutputDir = ''
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Root)) {
  $Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
} else {
  $Root = (Resolve-Path $Root).Path
}

$versionFile = Join-Path $Root 'VERSION'
if (-not (Test-Path -LiteralPath $versionFile)) {
  throw "VERSION not found under MathParser root: $Root"
}

$version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
$binaryDir = Join-Path $Root 'build\bin'

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

# Public profile: do NOT copy build/bin/scripts because it contains the
# external Python bridge source file. Python integration is intentionally
# unavailable in this first public portable profile.

$examples = Join-Path $Root 'examples'
if (Test-Path -LiteralPath $examples) {
  Copy-Item -LiteralPath $examples -Destination (Join-Path $packageDir 'examples') -Recurse -Force
}

# Fail closed if development/source files accidentally enter the package.
$forbidden = Get-ChildItem -LiteralPath $packageDir -Recurse -File | Where-Object {
  $_.Extension.ToLowerInvariant() -in @('.pas','.pp','.inc','.lpi','.lpr','.lfm','.lpk','.py')
}
if ($forbidden) {
  $names = ($forbidden | ForEach-Object { $_.FullName }) -join [Environment]::NewLine
  throw "Public package contains forbidden source/development files:`n$names"
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
