$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/")
$listener.Start()
Write-Host "HTTP Server running on http://10.142.177.55:8080/Riverside-Residence-Release.apk"

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $apkPath = "C:\Users\Hp\.gemini\antigravity\scratch\riverside_flutter_app\Riverside-Residence-Release.apk"
        if (Test-Path $apkPath) {
            $bytes = [System.IO.File]::ReadAllBytes($apkPath)
            $response.ContentType = "application/vnd.android.package-archive"
            $response.ContentLength64 = $bytes.Length
            $response.AddHeader("Content-Disposition", "attachment; filename=Riverside-Residence-Release.apk")
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.Close()
    } catch {
        Write-Host $_.Exception.Message
    }
}
