@echo off
setlocal enabledelayedexpansion

:: ======= Prompt for input =======
set /p NETBIOS_DOMAIN=Enter NetBIOS domain name (e.g., CONTOSO): 
set /p FQDN_DOMAIN=Enter full domain name (e.g., contoso.local): 

:: ======= Scan local Administrators group =======
echo.
echo Scanning local Administrators group for domain accounts from %NETBIOS_DOMAIN%...
for /f "tokens=* delims=" %%a in ('net localgroup Administrators ^| findstr /I "%NETBIOS_DOMAIN%\\"') do (
    set "USER_TO_REMOVE=%%a"
    call :PromptRemove "!USER_TO_REMOVE!"
)

:: ======= Confirm before proceeding =======
echo.
echo ==========================================
echo Ready to UNJOIN from domain: %FQDN_DOMAIN%
echo This will move the PC to WORKGROUP and REBOOT the system.
echo ==========================================
set /p PROCEED=Do you want to continue? (Y/N): 
if /I NOT "%PROCEED%"=="Y" (
    echo Operation cancelled.
    exit /b
)

:: ======= Create temporary PowerShell script =======
set TEMP_PS=%TEMP%\unjoin_domain.ps1
echo $cred = Get-Credential -UserName "%FQDN_DOMAIN%\administrator" -Message "Enter domain admin credentials to unjoin from %FQDN_DOMAIN%" > "%TEMP_PS%"
echo try { >> "%TEMP_PS%"
echo     Remove-Computer -UnjoinDomainCredential $cred -WorkgroupName "WORKGROUP" -PassThru -Verbose -ErrorAction Stop >> "%TEMP_PS%"
echo     Write-Host "[PASS] Successfully unjoined the domain. Rebooting..." -ForegroundColor Green >> "%TEMP_PS%"
echo     Start-Sleep -Seconds 5 >> "%TEMP_PS%"
echo     Restart-Computer -Force >> "%TEMP_PS%"
echo } catch { >> "%TEMP_PS%"
echo     Write-Host "[FAIL] ERROR: $_.Exception.Message" -ForegroundColor Red >> "%TEMP_PS%"
echo     pause >> "%TEMP_PS%"
echo } >> "%TEMP_PS%"

:: ======= Run PowerShell script =======
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS%"

:: ======= Clean up (will not run if reboot succeeds) =======
del "%TEMP_PS%"
goto :eof

:: ======= Subroutine to remove local admin =======
:PromptRemove
set "ACCOUNT=%~1"
echo.
echo Found domain admin: %ACCOUNT%
set /p CONFIRM=Remove this user from local Administrators? (Y/N): 
if /I "%CONFIRM%"=="Y" (
    echo Removing %ACCOUNT% ...
    net localgroup Administrators "%ACCOUNT%" /delete
    if errorlevel 1 (
        echo [FAIL] Could not remove %ACCOUNT%
    ) else (
        echo [PASS] Removed %ACCOUNT%
    )
) else (
    echo Skipped %ACCOUNT%
)
goto :eof
