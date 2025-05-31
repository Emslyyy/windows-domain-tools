@echo off
setlocal enabledelayedexpansion

:: =============================================
:: Verify if computer is joined to domain
:: and if user is a local administrator
:: =============================================

:: === INPUT ===
set /p DOMAIN=Enter domain NETBIOS name (e.g., CONTOSO): 
set /p USERNAME=Enter domain username to verify (e.g., jdoe): 

echo.
echo [CHECK] Detecting current domain...
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Domain"') do (
    set "COMPUTER_DOMAIN=%%a"
)
:: Trim leading space
set "COMPUTER_DOMAIN=%COMPUTER_DOMAIN:~1%"

echo Detected domain: %COMPUTER_DOMAIN%

echo %COMPUTER_DOMAIN% | findstr /I /C:"%DOMAIN%" >nul
if errorlevel 1 (
    echo [FAIL] Computer is NOT joined to domain "%DOMAIN%"
) else (
    echo [PASS] Computer IS joined to domain "%DOMAIN%"
)

echo.
echo [CHECK] Checking if "%DOMAIN%\%USERNAME%" is a local administrator...
net localgroup Administrators | findstr /I /C:"%DOMAIN%\%USERNAME%" >nul

if errorlevel 1 (
    echo [FAIL] User "%DOMAIN%\%USERNAME%" is NOT a local administrator.
) else (
    echo [PASS] User "%DOMAIN%\%USERNAME%" IS a local administrator.
)

echo.
pause
