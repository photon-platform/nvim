#!/bin/bash

# Script to download and install the FiraCode Nerd Font for the current user.

# --- Configuration ---
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
FONT_ZIP_NAME="FiraCode.zip"
# User-specific font directory
FONT_DIR="$HOME/.local/share/fonts"
# Temporary download location (using current directory)
DOWNLOAD_PATH="./$FONT_ZIP_NAME"

# --- Helper Functions ---
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Main Script ---
echo "Starting FiraCode Nerd Font installation..."

# 1. Check Prerequisites
echo "Checking for required tools (wget, unzip, fc-cache)..."
if ! command_exists wget && ! command_exists curl; then
  echo "Error: Neither 'wget' nor 'curl' found. Please install one (e.g., sudo apt install wget)." >&2
  exit 1
fi
if ! command_exists unzip; then
  echo "Error: 'unzip' not found. Please install it (e.g., sudo apt install unzip)." >&2
  exit 1
fi
if ! command_exists fc-cache; then
  echo "Error: 'fc-cache' not found. Please install fontconfig (e.g., sudo apt install fontconfig)." >&2
  exit 1
fi
echo "Prerequisites met."

# 2. Download the Font Archive
echo "Downloading FiraCode Nerd Font from $FONT_URL..."
if command_exists wget; then
  wget -q --show-progress -O "$DOWNLOAD_PATH" "$FONT_URL"
else
  curl -Lso "$DOWNLOAD_PATH" "$FONT_URL"
fi

# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to download font archive from $FONT_URL." >&2
  # Clean up partial download if it exists
  [ -f "$DOWNLOAD_PATH" ] && rm "$DOWNLOAD_PATH"
  exit 1
fi
echo "Download complete: $DOWNLOAD_PATH"

# 3. Create the User Font Directory
echo "Ensuring font directory exists: $FONT_DIR"
mkdir -p "$FONT_DIR"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create font directory $FONT_DIR." >&2
  # Clean up downloaded file
  rm "$DOWNLOAD_PATH"
  exit 1
fi

# 4. Extract the Font Files
echo "Extracting fonts to $FONT_DIR..."
unzip -o "$DOWNLOAD_PATH" -d "$FONT_DIR" # -o overwrites existing files without prompting
if [ $? -ne 0 ]; then
  echo "Error: Failed to extract font archive $DOWNLOAD_PATH to $FONT_DIR." >&2
  # Clean up downloaded file
  rm "$DOWNLOAD_PATH"
  exit 1
fi
echo "Extraction complete."

# 5. Update the Font Cache
echo "Updating font cache (this may take a moment)..."
fc-cache -f -v
if [ $? -ne 0 ]; then
  echo "Warning: fc-cache command finished with errors, but installation might still be okay." >&2
  # Continue despite potential fc-cache warnings/errors
fi
echo "Font cache updated."

# 6. Clean Up
echo "Cleaning up downloaded archive..."
rm "$DOWNLOAD_PATH"
echo "Cleanup complete."

echo ""
echo "-----------------------------------------------------"
echo " FiraCode Nerd Font installation finished successfully! "
echo "-----------------------------------------------------"
echo "You may need to restart applications (like your terminal or text editor) for the font to appear in their settings."

exit 0

