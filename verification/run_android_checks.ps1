param([string]$DeviceId = 'emulator-5554')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$scratchRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('registry-check-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $scratchRoot -Force | Out-Null
& robocopy $projectRoot $scratchRoot /E /NFL /NDL /NJH /NJS /XD build .dart_tool .gradle .git .idea .kotlin .cxx /XF local.properties GeneratedPluginRegistrant.java '*.apk' | Out-Null
if ($LASTEXITCODE -ge 8) { throw 'Could not prepare the Android verification copy.' }
$pubspecPath = Join-Path $scratchRoot 'pubspec.yaml'
$pubspec = [System.IO.File]::ReadAllText($pubspecPath)
$pubspec = $pubspec.Replace('dev_dependencies:', "dev_dependencies:`n  integration_test:`n    sdk: flutter")
[System.IO.File]::WriteAllText($pubspecPath, $pubspec)
New-Item -ItemType Directory -Path (Join-Path $scratchRoot 'integration_test'),(Join-Path $scratchRoot 'test_driver') -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'android_flow.dart.txt') -Destination (Join-Path $scratchRoot 'integration_test/app_test.dart')
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'driver.dart.txt') -Destination (Join-Path $scratchRoot 'test_driver/integration_test.dart')
Push-Location $scratchRoot
try {
  & flutter pub get
  if ($LASTEXITCODE -ne 0) { throw 'Verification dependencies failed to resolve.' }
  & flutter drive --driver test_driver/integration_test.dart --target integration_test/app_test.dart -d $DeviceId --no-pub
  if ($LASTEXITCODE -ne 0) { throw 'Android integration test failed.' }
  $evidenceTarget = Join-Path $projectRoot 'evidence/emulator'
  New-Item -ItemType Directory -Path $evidenceTarget -Force | Out-Null
  Copy-Item -Path (Join-Path $scratchRoot 'evidence/emulator/*.png') -Destination $evidenceTarget -Force
  Write-Host "Android checks passed. Screenshots: $evidenceTarget"
} finally {
  Pop-Location
}
