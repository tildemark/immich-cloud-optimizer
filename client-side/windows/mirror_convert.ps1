# Configuration
$SourceRoot = "D:\Photos"
$DestRoot = "D:\WebP_Export"

Write-Host "Scanning source directory..." -ForegroundColor Gray
$images = Get-ChildItem -Path $SourceRoot -Recurse -Include *.jpg, *.jpeg, *.png
$total = $images.Count
$count = 0

Write-Host "Starting conversion with Metadata Preservation (-metadata all)..." -ForegroundColor Green

ForEach ($img in $images) {
    $count++
    
    $relativePath = $img.FullName.Substring($SourceRoot.Length)
    $destFile = Join-Path $DestRoot $relativePath
    $destFile = [IO.Path]::ChangeExtension($destFile, ".webp")
    $destFolder = [IO.Path]::GetDirectoryName($destFile)

    if (-not (Test-Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
    }

    $shouldConvert = $false
    $statusMsg = ""
    $statusColor = "White"

    if (-not (Test-Path $destFile)) {
        $shouldConvert = $true
        $statusMsg = "Creating"
        $statusColor = "Cyan"
    }
    else {
        $destInfo = Get-Item $destFile
        # Check if source is newer to trigger an update/re-conversion
        if ($img.LastWriteTime -gt $destInfo.LastWriteTime) {
            $shouldConvert = $true
            $statusMsg = "Updating (Source is newer)"
            $statusColor = "Yellow"
        }
    }

    if ($shouldConvert) {
        Write-Host "[$count / $total] $statusMsg : $($img.Name)" -ForegroundColor $statusColor
        
        # 1. Try Standard Conversion with Metadata (EXIF/GPS)
        # -metadata all: ensures GPS and Camera data are preserved
        # -mt: multi-threading for speed
        cwebp -q 80 "$($img.FullName)" -o "$destFile" -metadata all -mt -quiet 2>$null
        
        # 2. Check for Failure (PARTITION0_OVERFLOW)
        if ($LASTEXITCODE -ne 0) {
            Write-Host "    [!] Standard conversion failed (likely Overflow). Retrying with Safe Mode..." -ForegroundColor Red
            
            # Retry with Safe Mode settings + Metadata
            cwebp -q 75 "$($img.FullName)" -o "$destFile" -metadata all -mt -quiet -segments 1 -partition_limit 50
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "    [X] FATAL: Could not convert $($img.Name). Skipping." -ForegroundColor Magenta
                continue
            }
            else {
                Write-Host "    [V] Safe Mode success (Metadata preserved)." -ForegroundColor Green
            }
        }

        # 3. Synchronize File Timestamps
        # This helps Immich and Windows
