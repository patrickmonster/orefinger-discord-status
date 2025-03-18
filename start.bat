@echo off
set "local=%AppData%\..\Local\Microsoft\powershell"



echo ������ : Patrickmonster
echo ������ : 2025-03-18
echo ������ �� : https://github.com/patrickmonster
echo.
echo �ش� ���α׷��� PowerShell 7.1.3 ������ ����մϴ�.
echo ����� ������ �����մϴ�.
echo - 746bb654450b871d35c226c277170d3c6b2ad8bbff6a1afe157a8b27542f97aa
echo.
echo.

%local%\pwsh -Command "Write-Output 'PowerShell ��ġ��( %local%\pwsh )'"
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



echo ���Ͻô� �۾��� �Է��ϼ���.
echo 1 : ġ����
echo 2 : SOOP
echo 3 : ����

set /p choice=
if %choice%==1 goto :chzzk
if %choice%==2 goto :SOOP
if %choice%==3 goto :exit

:chzzk
echo "ġ������ �����մϴ�."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/chzzk.ps1', 'start.ps1')"
goto :Running

:SOOP
echo "SOOP�� �����մϴ�."
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://patrickmonster.github.io/orefinger-discord-status/soop.ps1', 'start.ps1')"
goto :Running

:Running
%local%\pwsh -File start.ps1
goto :EOF

:exit
echo "���α׷��� �����մϴ�."
goto :EOF

