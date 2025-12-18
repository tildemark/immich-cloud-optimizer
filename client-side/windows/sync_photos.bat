@echo off
TITLE Immich Smart Sync
COLOR 0A

echo.
echo ==================================================
echo      STEP 1: SMART CONVERSION
echo ==================================================
:: Runs the smart PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -File "mirror_convert.ps1"

echo.
echo ==================================================
echo      STEP 2: UPLOADING CHANGES
echo ==================================================
:: Replace KEY with your actual API Key
immich-go.exe ^
  upload from-folder ^
  "E:\WebP_Export" ^
  --server https://photos.sanchez.ph ^
  --concurrent-tasks 5 ^
  --api-key YOUR_API_KEY_HERE ^
  --folder-as-album=FOLDER ^
  --on-errors=continue ^
  --overwrite ^
  --recursive ^

echo.
echo ==================================================
echo      ALL DONE.
echo ==================================================
pause
