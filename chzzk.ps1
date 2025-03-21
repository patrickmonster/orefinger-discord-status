
# 제작자 : patrickmonster
# 제작일 : 2025-03-18
# 참조코드 : https://github.com/discordjs/RPC/blob/master/src/transports/ipc.js

$global:version = @{
    "제작자" = "patrickmonster"
    "제작일" = "2025-03-18"
    "참조코드" = "https://github.com/discordjs/RPC/blob/master/src/transports/ipc.js"
    "버전" = "1.0.0"

    "테스트 버전" = "PowerShell 7.5.0 (MacOS)"
    "현재 실행중인 버전" = $PSVersionTable.PSVersion.ToString()
}

Write-Host "방송알리미 $($global:version | ConvertTo-Json -Depth 10)"

# ipc 

$CLIENT_ID = "826484552029175808"

# use the connection to the IPC
$global:working = @{
    full = ''
    op = $null
}

# ////////////////////////////////////////////////////////////////////////

# Check if the OS is Windows
function Get-IPCPath {
    param ($id = 0)
    
    if ($($IsWindows -eq $true) -or $($IsWindows -eq $null)) {
        return "discord-ipc-$id"
    }

    $prefix = $env:XDG_RUNTIME_DIR
    if (-not $prefix) {
        $prefix = $env:TMPDIR
    }
    if (-not $prefix) {
        $prefix = $env:TMP
    }
    if (-not $prefix) {
        $prefix = $env:TEMP
    }
    if (-not $prefix) {
        $prefix = '/tmp'
    }
    $prefix = $prefix.TrimEnd('/')
    return "$prefix\/discord-ipc-$id"
}

# 메세지 전송 id 생성
function Generate-UUID {
    $UUID = [guid]::NewGuid().ToString()
    Write-Host "Generated UUID: $UUID"
    return $UUID
}
# 시간 변환
function Convert-ToUnixDate ($PSdate) {
   $epoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
   (New-TimeSpan -Start $epoch -End $PSdate).TotalSeconds
}

# ////////////////////////////////////////////////////////////////////////
function Get-State {
    param (
        [string]$channel_id
    )
    Write-Host "Getting state for channel ID: $channel_id"

    $request = @{
        Uri =  "https://api.chzzk.naver.com/service/v2/channels/$channel_id/live-detail"
        ContentType = 'application/json; charset=UTF-8'
        Method = "GET"
        Headers = @{
            'User-Agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36'
        }
    }
    
    $response = Invoke-RestMethod @request

    $content = $response.content

    
    $status = $content.status
    $liveTitle = $content.liveTitle 
    $liveCategoryValue = $content.liveCategoryValue
    $concurrentUserCount = $content.concurrentUserCount
    $channel = $content.channel
    $openDate = [Datetime]::ParseExact($content.openDate , 'yyyy-MM-dd HH:mm:ss', $null)
    # 2025-03-18 11:35:59

    
    $assets = @{
        large_text = "$($channel.channelName) - $($concurrentUserCount.ToString('N0'))명 시청 중"
        small_image = 'https://ssl.pstatic.net/static/nng/glive/icon/favicon.png'
    }
    if ( $content.liveImageUrl -ne $null ) { 
        $assets.large_image = $content.liveImageUrl.Replace('{type}', '1080')
    }

    if ( $status -eq "CLOSE" ) {
        Write-Host "방송이 종료됨 - 방송이 시작되기 까지 대기중...."
        return $null
    }

    $button = @{
        label = '보기'
        url = "https://chzzk.naver.com/live/$channel_id"
    }


    $out = @{
        details = $liveTitle
        state = "$liveCategoryValue 하는 중"
        timestamps = @{
            start = $(Convert-ToUnixDate $openDate)
        }
        buttons = @( $button )
        assets = $assets
        instance = $false
    }

    return $out
}

# 전송을 위한 인코더
function Encode-Message {
    param (
        [int]$op,
        [hashtable]$data
    )
    $dataJson = $data | ConvertTo-Json -Depth 10
    $len = [System.Text.Encoding]::UTF8.GetByteCount($dataJson)
    $packet = New-Object byte[] (8 + $len)
    [BitConverter]::GetBytes($op).CopyTo($packet, 0)
    [BitConverter]::GetBytes($len).CopyTo($packet, 4)
    [System.Text.Encoding]::UTF8.GetBytes($dataJson).CopyTo($packet, 8)
    return $packet
}

# Decode the message - https://discord.com/developers/docs/topics/rpc#payloads
function Decode-Message {
    param (
        [System.IO.Pipes.NamedPipeClientStream]$pipeServer,
        [scriptblock]$callback
    )
    $buffer = New-Object byte[] 1024
    $bytesRead = $pipeServer.Read($buffer, 0, $buffer.Length)
    if ($bytesRead -eq 0) {
        return
    }

    $op = $global:working.op
    $raw = $null

    if ($global:working.full -eq '') {
        $op = $global:working.op = [BitConverter]::ToInt32($buffer, 0)
        $len = [BitConverter]::ToInt32($buffer, 4)
        $raw = [System.Text.Encoding]::UTF8.GetString($buffer, 8, $len)
    } else {
        $raw = [System.Text.Encoding]::UTF8.GetString($buffer)
    }

    try {
        $data = $global:working.full + $raw | ConvertFrom-Json -Depth 10
        & $callback @{
            op = $op
            data = $data
        }
        $global:working.full = ''
        $global:working.op = $null

        return;
    } catch {
        $global:working.full += $raw
    }

    Decode-Message -pipeServer $pipeServer -callback $callback
}

# Send a message to the IPC
function Send-Message {
    param (
        [System.IO.Pipes.NamedPipeClientStream]$pipeServer,
        [hashtable]$message,
        [int]$op = 1 # FRAME
    )
    $messageBytes = Encode-Message -op $op -data $message
    $pipeServer.Write($messageBytes, 0, $messageBytes.Length)
    Write-Host "Sent message: $($message | ConvertTo-Json -Depth 3)"
}

# Find the IPC endpoint - https://discord.com/developers/docs/topics/rpc#finding-the-ipc-endpoint
function Get-Connect-IPC {
    param ( [string]$id = 0 )
    Try {
        $pipeName = Get-IPCPath($id)
        Write-Host "Connecting to IPC #$pipeName"
        $pipeClient = New-Object System.IO.Pipes.NamedPipeClientStream(".", $pipeName, [System.IO.Pipes.PipeDirection]::InOut)
        $pipeClient.Connect()
        return $pipeClient
    } catch {
        Write-Host "Error: $_"
        if ( $id -eq 10 ) {
            throw "Failed to connect to IPC"
        }
        return Get-Connect-IPC -id $id + 1
    }
}
# ////////////////////////////////////////////////////////////////////////

# Update PowerShell if necessary
if ($PSVersionTable.PSVersion -lt [Version]"7.0") {
    Write-Host "Updating PowerShell..."
    $installerUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/PowerShell-7.0.0-win-x64.msi"
    $installerPath = "$env:TEMP\PowerShell-7.0.0-win-x64.msi"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    Start-Process msiexec.exe -ArgumentList "/i", $installerPath, "/quiet", "/norestart" -Wait
    Write-Host "파워쉘 업데이트를 완료햇습니다. 다시 실행해주세요."
    exit
} else {
    Write-Host "PowerShell is up to date."
}

function Set-Activity {
    param (
        [System.IO.Pipes.NamedPipeClientStream]$pipeServer,
        [hashtable]$data
    )
    $nonce = Generate-UUID
    $message = @{
        cmd = 'SET_ACTIVITY'
        args = @{
            pid = $PID
            activity = $data
        }
        evt = $null
        nonce = $nonce
    }
    Send-Message -pipeServer $pipeServer -message $message
}

function Recive-Discord-Message {
    param (
        [hashtable]$message
    )
    $op = $message.op
    $data = $message.data
    Write-Host "Received message: $($message | ConvertTo-Json -Depth 10)"

    switch ($op) {
        1 { # FRAME
            if ($data -and $data.cmd -eq 'AUTHORIZE' -and $data.evt -ne 'ERROR') {
                try {
                    $endpoint = Find-Endpoint
                    $client.request.endpoint = $endpoint
                } catch {
                    $client.emit('error', $_)
                }
            }
        }
        2 { # PING
            Send-Message -pipeServer $pipeServer -op 2 -message $data
        }
        3 { # CLOSE
            Write-Host "Connection closed: $data"
            break
        }
        default {
            Write-Host "Unknown opcode: $op"
        }
    }
}
# Prompt user for channel ID
Write-Host "방송알리미 - 라이브 활동 공유"
if ( -not $args[0]) {
    $channelId = Read-Host "Enter the Chzzk channel ID"
}else {
    $channelId = $args[0]
}

# Validate the channel ID
if (-not $channelId) {
    Write-Host "Channel ID is required."
    exit
}

$channelId = $channelId.Trim()

# Install the PowerShell Discord IPC module
Try {
    $pipeServer = Get-Connect-IPC
    Write-Host "SUCCESS :: $([DateTime]::Now)"
    Send-Message -pipeServer $pipeServer -op 0 -message @{
        v = 1
        client_id = $CLIENT_ID
    }

    while ($true) {
        # Check for job output
        Decode-Message -pipeServer $pipeServer -callback {
            param (
                [hashtable]$message
            )

            Recive-Discord-Message -message $message
        }

        $data = Get-State($channelId)

        Set-Activity -pipeServer $pipeServer -data $data
        Start-Sleep -Seconds 30 # 30초
    }
} Finally {
    # Close the pipe server
    if ($pipeServer) {
        $pipeServer.Dispose()
    }
}
