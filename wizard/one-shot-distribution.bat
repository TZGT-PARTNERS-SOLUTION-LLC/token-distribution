@echo off
echo 🚀 TOKEN DISTRIBUTION WIZARD
set /p token="Enter token address: "
set /p decimals="Enter decimals [18]: "
if "%decimals%"=="" set decimals=18
echo.
echo ✅ Token: %token%
echo ✅ Decimals: %decimals%
