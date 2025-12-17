#!/bin/bash

SOURCE_DIR="/mnt/data/Photos"
DEST_DIR="/mnt/data/WebP_Export"
API_KEY="YOUR_API_KEY_HERE"
SERVER="https://photos.sanchez.ph"

# Step 1: Run the conversion logic
./mirror_convert.sh

echo ">> Step 2: Uploading to Immich..."
./immich-go upload from-folder "$DEST_DIR" \
  --server "$SERVER" \
  --key "$API_KEY" \
  --recursive \
  --create-albums

echo ">> DONE."