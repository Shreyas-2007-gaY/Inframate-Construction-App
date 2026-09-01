$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;

public class AppIconGenerator {
    public static void GenerateIcon(string path, int size, bool isRound) {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        using (Bitmap bmp = new Bitmap(size, size))
        using (Graphics g = Graphics.FromImage(bmp)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.PixelOffsetMode = PixelOffsetMode.HighQuality;

            if (isRound) {
                using (GraphicsPath clipPath = new GraphicsPath()) {
                    clipPath.AddEllipse(0, 0, size, size);
                    g.SetClip(clipPath);
                }
            }

            // Dark navy blueprint background
            using (SolidBrush bgBrush = new SolidBrush(Color.FromArgb(22, 34, 50))) {
                g.FillRectangle(bgBrush, 0, 0, size, size);
            }

            // Grid pattern
            using (Pen gridPen = new Pen(Color.FromArgb(35, 52, 75), Math.Max(1.0f, size / 96.0f))) {
                float gridStep = size / 8.0f;
                for (float i = 0; i <= size; i += gridStep) {
                    g.DrawLine(gridPen, i, 0, i, size);
                    g.DrawLine(gridPen, 0, i, size, i);
                }
            }

            // Scaled coordinates
            float s = size / 100.0f;

            // Roof
            PointF[] roof = new PointF[] {
                new PointF(50.0f * s, 15.0f * s),
                new PointF(15.0f * s, 42.0f * s),
                new PointF(85.0f * s, 42.0f * s)
            };

            using (GraphicsPath path2 = new GraphicsPath()) {
                path2.FillMode = FillMode.Alternate;

                // Outer house shape
                path2.AddPolygon(roof);
                path2.AddRectangle(new RectangleF(19.0f * s, 42.0f * s, 62.0f * s, 36.0f * s));

                // Interior cutouts (windows & door)
                path2.AddRectangle(new RectangleF(32.0f * s, 51.0f * s, 11.0f * s, 11.0f * s));
                path2.AddRectangle(new RectangleF(57.0f * s, 51.0f * s, 11.0f * s, 11.0f * s));
                path2.AddRectangle(new RectangleF(42.0f * s, 68.0f * s, 16.0f * s, 10.0f * s));

                using (SolidBrush houseBrush = new SolidBrush(Color.FromArgb(240, 113, 25))) {
                    g.FillPath(houseBrush, path2);
                }
            }

            bmp.Save(path, System.Drawing.Imaging.ImageFormat.Png);
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing;

$baseDir = "C:\Users\Hp\.gemini\antigravity\scratch\riverside_flutter_app\android\app\src\main\res"

$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($entry in $sizes.GetEnumerator()) {
    $dir = Join-Path $baseDir $entry.Key
    $size = $entry.Value
    
    $squarePath = Join-Path $dir "ic_launcher.png"
    $roundPath = Join-Path $dir "ic_launcher_round.png"
    
    [AppIconGenerator]::GenerateIcon($squarePath, $size, $false)
    [AppIconGenerator]::GenerateIcon($roundPath, $size, $true)
    
    Write-Host "Generated $squarePath ($size x $size)"
}
