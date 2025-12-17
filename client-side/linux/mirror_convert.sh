#!/bin/bash

# Configuration
SOURCE_DIR="/mnt/data/Photos"
DEST_DIR="/mnt/data/WebP_Export"

echo ">> Scanning source directory: $SOURCE_DIR"

# Find source images
find "$SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read FILE; do
    # Calculate paths
    REL_PATH="${FILE#$SOURCE_DIR}"
    DEST_FILE="$DEST_DIR${REL_PATH%.*}.webp"
    DEST_FOLDER=$(dirname "$DEST_FILE")

    # Flag to determine if we convert
    DO_CONVERT=0

    # Case A: Destination doesn't exist
    if [ ! -f "$DEST_FILE" ]; then
        mkdir -p "$DEST_FOLDER"
        echo "[NEW] $REL_PATH"
        DO_CONVERT=1
    # Case B: Source is newer than Destination (Edited file)
    elif [ "$FILE" -nt "$DEST_FILE" ]; then
        echo "[UPDATE] $REL_PATH"
        DO_CONVERT=1
    fi

    # Execute Conversion
    if [ $DO_CONVERT -eq 1 ]; then
        cwebp -q 80 "$FILE" -o "$DEST_FILE" -mt -quiet
    fi
done

echo ">> Mirror Sync Complete."