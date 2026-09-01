$ip = [System.Net.IPAddress]::Any
$listener = New-Object System.Net.Sockets.TcpListener($ip, 8080)
$listener.Start()
Write-Host "TCP HTTP Server active on http://10.142.177.55:8080/Riverside-Residence-Release.apk"

$apkPath = "C:\Users\Hp\.gemini\antigravity\scratch\riverside_flutter_app\Riverside-Residence-Release.apk"
$apkBytes = [System.IO.File]::ReadAllBytes($apkPath)

while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        
        $headerStr = "HTTP/1.1 200 OK`r`nContent-Type: application/vnd.android.package-archive`r`nContent-Length: " + $apkBytes.Length + "`r`nContent-Disposition: attachment; filename=Riverside-Residence-Release.apk`r`nConnection: close`r`n`r`n"
        $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($headerStr)
        
        $stream.Write($headerBytes, 0, $headerBytes.Length)
        $stream.Write($apkBytes, 0, $apkBytes.Length)
        $stream.Flush()
        $client.Close()
    } catch {
        Write-Host $_.Exception.Message
    }
}
