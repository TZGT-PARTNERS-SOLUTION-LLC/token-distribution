#!/usr/bin/env pwsh
Write-Host "🚀 TOKEN DISTRIBUTION WIZARD" -ForegroundColor Magenta
Write-Host "Enter token address: " -NoNewline -ForegroundColor Cyan
$token = Read-Host
Write-Host "Enter decimals [18]: " -NoNewline -ForegroundColor Cyan
$decimals = Read-Host
$decimals = if ([string]::IsNullOrEmpty($decimals)) { "18" } else { $decimals }
Write-Host ""
Write-Host "✅ Token: $token" -ForegroundColor Green
Write-Host "✅ Decimals: $decimals" -ForegroundColor Green
