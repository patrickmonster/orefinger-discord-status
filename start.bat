@echo off
set "local=%AppData%\..\Local\Microsoft\powershell"



echo 제작자 : Patrickmonster
echo 제작일 : 2025-03-18
echo 제작자 깃 : https://github.com/patrickmonster
echo.
echo 해당 프로그램은 PowerShell 7.1.3 버전을 사용합니다.
echo 상업적 공유를 금지합니다.
echo - 746bb654450b871d35c226c277170d3c6b2ad8bbff6a1afe157a8b27542f97aa
echo.
echo.

%local%\pwsh -Command "Write-Output 'PowerShell 설치됨( %local%\pwsh )'"
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
    echo PowerShell is installed. Restarting...

    @REM start "" "%~dpnx0"
    
    set /p c=
    exit /b %errorlevel%
)



echo 원하시는 작업을 입력하세요.
echo 1 : 치지직
echo 2 : SOOP
echo 3 : 종료

set /p choice=
if %choice%==1 goto :chzzk
if %choice%==2 goto :SOOP
if %choice%==3 goto :exit

:chzzk
echo "치지직을 실행합니다."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/chzzk.ps1', 'start.ps1')"
goto :Running

:SOOP
echo "SOOP을 실행합니다."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/soop.ps1', 'start.ps1')"
goto :Running

:Running
%local%\pwsh -File start.ps1
goto :EOF

:exit
echo "프로그램을 종료합니다."
goto :EOF

