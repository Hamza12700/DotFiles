#!/bin/bash

# Capture the screenshot and save it to a temporary file
screenshot_file=$(mktemp)
grim -g "$(slurp)" "$screenshot_file"

# Copy the screenshot to the clipboard
wl-copy < "$screenshot_file"

# Delete the temporary screenshot file
rm "$screenshot_file"

echo "Screenshot captured and copied to clipboard."
