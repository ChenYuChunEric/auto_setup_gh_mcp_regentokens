@echo off
:: GitHub Token Secure Setup Helper (Batch version)

:menu
cls
echo ==============================================
echo        GitHub Token Secure Setup Helper
echo ==============================================
echo [A] Check gh CLI installation and login status
echo [B] Securely update GitHub Token
echo [Q] Quit
echo ==============================================
set /p choice=Enter your choice (A/B/Q): 

if /I "%choice%"=="A" goto check_gh
if /I "%choice%"=="B" goto update_token
if /I "%choice%"=="Q" goto end
goto menu

:check_gh
echo.
echo Checking gh CLI...
where gh >nul 2>&1
if errorlevel 1 (
    echo gh CLI not found. Attempting installation via winget...
    winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
) else (
    echo gh CLI is installed.
    gh --version
)

echo.
echo Checking login status...
gh auth status

pause
goto menu

:update_token
echo.
echo For security, the token input will not be stored in any project file.
echo NOTE: Batch cannot hide input; ensure your screen is private.
set /p token=Paste your GitHub Token (will be visible on screen): 

if "%token%"=="" (
    echo No token provided. Returning to main menu.
    pause
    goto menu
)

echo Verifying token...
echo %token% | gh auth login --with-token
if errorlevel 0 (
    echo Token updated successfully! Current logged in user:
    gh api user --jq .login
) else (
    echo Token verification failed. Please check the token.
)

set token=
pause
goto menu

:end
exit /b
