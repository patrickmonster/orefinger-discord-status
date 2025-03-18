@echo off
set "local=%AppData%\..\Local\Microsoft\powershell"

echo Created by: Patrickmonster
echo Creation date: 2025-03-18
echo Creator's GitHub: https://github.com/patrickmonster
echo.
echo This program uses PowerShell version 7.1.3.
echo Commercial sharing is prohibited.
echo - 746bb654450b871d35c226c277170d3c6b2ad8bbff6a1afe157a8b27542f97aa
echo.
echo.

%local%\pwsh -Command "Write-Output 'PowerShell ( %local%\pwsh )'"
if %errorlevel% neq 0 (


    echo PowerShell is not installed. Installing PowerShell...

    @REM powershell -Command "Start-Process msiexec.exe -ArgumentList '/i https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/PowerShell-7.1.3-win-x64.msi /quiet /norestart' -NoNewWindow -Wait"
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/install-powershell.ps1', 'install-powershell.ps1')"
    echo Installing PowerShell...

    powershell -File install-powershell.ps1
    
    if %errorlevel% neq 0 (
        echo Failed to install PowerShell. Exiting...
        pause
        exit /b %errorlevel%
    )
    echo PowerShell is installed!

)



echo Enter the desired action.
echo 1 : Chzzk
echo 2 : SOOP
echo 3 : exit

set /p choice=
if %choice%==1 goto :chzzk
if %choice%==2 goto :SOOP
if %choice%==3 goto :exit

:chzzk
echo "start Chzzk."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/chzzk.ps1', 'start.ps1')"
goto :Running

:SOOP
echo "start SOOP."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/soop.ps1', 'start.ps1')"
goto :Running

:Running
%local%\pwsh -File start.ps1
goto :EOF

:exit
echo "exit"
goto :EOF

