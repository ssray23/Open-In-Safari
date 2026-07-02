#!/bin/bash

# Compile the Swift host
echo "Compiling the Swift Native Host..."
swiftc Host/main.swift -o Host/OpenInSafariHost

# Get absolute path to Host executable
HOST_PATH="$(pwd)/Host/OpenInSafariHost"

EXT_ID=$1

if [ -z "$EXT_ID" ]; then
    echo "==========================================="
    echo "Please load the Extension in Chrome/Edge:"
    echo "1. Go to chrome://extensions/ (or edge://extensions/)"
    echo "2. Enable 'Developer mode'"
    echo "3. Click 'Load unpacked' and select the 'Extension' folder inside 'Open in Safari'"
    echo "4. Copy the ID of the loaded extension."
    echo "==========================================="
    echo ""
    echo "Usage: ./install.sh <EXTENSION_ID>"
    exit 1
fi

# Create Native Messaging JSON for Chrome
cat << EOF > Host/com.user.openinsafari.json
{
  "name": "com.user.openinsafari",
  "description": "Open In Safari Native Host",
  "path": "${HOST_PATH}",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://${EXT_ID}/"
  ]
}
EOF

# Install for Chrome
CHROME_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
mkdir -p "$CHROME_DIR"
cp Host/com.user.openinsafari.json "$CHROME_DIR/"

# Install for Edge
EDGE_DIR="$HOME/Library/Application Support/Microsoft Edge/NativeMessagingHosts"
mkdir -p "$EDGE_DIR"
cp Host/com.user.openinsafari.json "$EDGE_DIR/"

echo "Successfully installed!"
echo "You can now right-click any link in Chrome or Edge and select 'Open in Safari'!"
