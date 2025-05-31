@echo off
setlocal enabledelayedexpansion

:: =====================================================
:: Join Windows computer to a domain + add domain user to local admins
:: Compatible with Windows 10/11
:: =====================================================

:: === CONFIGURATION ===
set /p DOMAIN_FQDN=Enter full domain name (e.g., example.local): 
set /p DOMAIN_NETBIOS=Enter short domain name (NetBIOS, e.g., EXAMPLE): 
set /p DOMAIN_ADMIN=Enter domain admin username (e.g., administrator): 
set /p NEW_ADMIN=Enter domain username to add as local admin (e.g., jsmith): 

echo.
echo ==========================================
echo You will now be prompted to enter credentials
echo for: %DOMAIN_FQDN%\%DOMAIN_ADMIN%
echo ==========================================
echo.

:: === Join domain via PowerShell ===
powershell -NoProfile -Command ^
  "$cred = Get-Credential -UserName '%DOMAIN_FQDN%\%DOMAIN_ADMIN%' -Message 'Enter domain admin password';" ^
  "Add-Computer -DomainName '%DOMAIN_FQDN%' -Credential $cred -Force -ErrorAction Stop"

if errorlevel 1 (
    echo [FAIL] Failed to join domain. Exiting...
    pause
    exit /b 1
)

:: === Add domain user to local Administrators group ===
echo.
echo [ADD] Adding %DOMAIN_NETBIOS%\%NEW_ADMIN% to local Administrators group...
net localgroup Administrators "%DOMAIN_NETBIOS%\%NEW_ADMIN%" /add

:: === Verify result ===
echo.
echo [CHECK] Verifying if %DOMAIN_NETBIOS%\%NEW_ADMIN% is now a local admin...
net localgroup Administrators | find /i "%DOMAIN_NETBIOS%\%NEW_ADMIN%" >nul

if %errorlevel%==0 (
    echo [OK] Successfully added %DOMAIN_NETBIOS%\%NEW_ADMIN% to local Administrators.
) else (
    echo [FAIL] Failed to add %DOMAIN_NETBIOS%\%NEW_ADMIN% to local Administrators.
    pause
    exit /b 1
)

:: === Restart ===
echo.
echo [RESTART] Restarting computer in 10 seconds to apply changes...
timeout /t 10
shutdown /r /t 0
