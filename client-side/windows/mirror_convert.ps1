# Configuration
$SourceRoot = "D:\Photos"         # Your Master Archive
$DestRoot   = "D:\WebP_Export"    # The new lightweight mirror

# Gather all source images
Write-Host "Scanning source directory..." -ForegroundColor Gray
$images = Get-ChildItem -Path $SourceRoot -Recurse -Include *.jpg, *.jpeg, *.png
$total = $images.Count
$count = 0

ForEach ($img in $images) {
    $count++
    
    # 1. Calculate Destination Paths
    $relativePath = $img.FullName.Substring($SourceRoot.Length)
    $destFile = Join-Path $DestRoot $relativePath
    $destFile = [IO.Path]::ChangeExtension($destFile, ".webp")
    $destFolder = [IO.Path]::GetDirectoryName($destFile)

    # 2. Ensure Folder Exists
    if (-not (Test-Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
    }

    # 3. Determine if we need to convert
    $shouldConvert = $false
    $statusMsg = ""
    $statusColor = "White"

    if (-not (Test-Path $destFile)) {
        # Case A: File doesn't exist
        $shouldConvert = $true
        $statusMsg = "Creating"
        $statusColor = "Cyan"
    }
    else {
        # Case B: File exists, check timestamps
        $destInfo = Get-Item $destFile
        if ($img.LastWriteTime -gt $destInfo.LastWriteTime) {
            $shouldConvert = $true
            $statusMsg = "Updating (Source is newer)"
            $statusColor = "Yellow"
        }
    }

    # 4. Execute Conversion
    if ($shouldConvert) {
        Write-Host "[$count / $total] $statusMsg : $($img.Name)" -ForegroundColor $statusColor
        # Added -quiet so it doesn't spam the console
        cwebp -q 80 "$($img.FullName)" -o "$destFile" -mt -quiet
    }
}

Write-Host "Sync Complete!" -ForegroundColor Green