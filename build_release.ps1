<#
.SYNOPSIS
Builds a release APK for G&B Care Clinic with obfuscation enabled.

.DESCRIPTION
This script runs the flutter build apk command with --release flag.
It also enables code obfuscation to protect the source code against reverse engineering
and saves the debug symbols in a separate folder for crash reporting (e.g., Crashlytics).
#>

Write-Host "Menyiapkan Build Release untuk G&B Care Clinic..." -ForegroundColor Cyan
Write-Host "Mengaktifkan Obfuscation untuk melindungi source code..." -ForegroundColor Yellow

$symbolsDir = "./build/app/outputs/symbols"

# Hapus folder symbols lama jika ada agar bersih
if (Test-Path $symbolsDir) {
    Remove-Item -Recurse -Force $symbolsDir
}
New-Item -ItemType Directory -Force -Path $symbolsDir | Out-Null

flutter build apk --release --obfuscate --split-debug-info=$symbolsDir

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build APK berhasil!" -ForegroundColor Green
    Write-Host "APK tersimpan di: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Green
    Write-Host "File symbol untuk de-obfuscate log error tersimpan di: $symbolsDir" -ForegroundColor Cyan
} else {
    Write-Host "❌ Gagal membuat APK. Silakan periksa pesan error di atas." -ForegroundColor Red
}
