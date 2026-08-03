param(
  [string]$Target = (Get-Location).Path,
  [string]$Ref = $(if ($env:FLUTTER_ENGINE_REF) { $env:FLUTTER_ENGINE_REF } else { "main" })
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw "Git is required."
}
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
  throw "Dart is required through the Flutter SDK."
}

$temporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) (
  "flutter-engine-" + [System.Guid]::NewGuid().ToString("N")
)

try {
  git clone --depth 1 --branch $Ref --quiet `
    "https://github.com/AdelMohsen/flutter-workflow.git" `
    $temporaryDirectory
  if ($LASTEXITCODE -ne 0) { throw "Could not download Flutter Engine." }

  dart run (Join-Path $temporaryDirectory "install.dart") --target $Target
  if ($LASTEXITCODE -ne 0) { throw "Flutter Engine installation failed." }
}
finally {
  if (Test-Path $temporaryDirectory) {
    Remove-Item -LiteralPath $temporaryDirectory -Recurse -Force
  }
}
