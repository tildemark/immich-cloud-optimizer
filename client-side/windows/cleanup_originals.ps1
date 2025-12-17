# WARNING: This deletes files. Make sure you have a backup!
$Source = "D:\Photos"

Get-ChildItem -Path $Source -Recurse -Include *.jpg, *.jpeg, *.png | ForEach-Object {
    $webpVersion = [IO.Path]::ChangeExtension($_.FullName, ".webp")
    # You might need to adjust logic here if WebP is in a different mirror folder
    
    # Only delete the JPG if the WebP version actually exists
    if (Test-Path $webpVersion) {
        Write-Host "Deleting original: $($_.Name)" -ForegroundColor Red
        Remove-Item -Path $_.FullName -Force
    }
    else {
        Write-Host "Keeping original (WebP missing): $($_.Name)" -ForegroundColor Yellow
    }
}