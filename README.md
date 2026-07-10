# Open in Safari

A Chrome, Edge, and Firefox browser extension that adds a native "Open in Safari" right-click option for any link or page on the web. This extension bridges the gap between Chromium browsers and macOS, allowing you to easily send links or your current page to Safari with a single click.

## How It Works

The project consists of two parts working together:
1. **The Browser Extension**: A lightweight background script that adds a context menu option to your browser. When you right-click a link or anywhere on a page and select "Open in Safari", it captures the underlying URL (even if it's hidden behind a Google Search result or obscured text) and securely passes it to the Native Messaging Host.
2. **The Swift Native Host**: A native macOS command-line executable written in Swift. It acts as a bridge, listening for JSON messages from the browser via standard input (`stdio`). When it receives a URL, it uses the native `NSWorkspace` macOS API to command Safari to open the link. 

## Installation Guide

### Prerequisites
- A Mac running macOS.
- Xcode Command Line Tools installed (for the Swift compiler).

### Step 1: Clone the Repository
Clone this repository to your local machine:
```bash
git clone https://github.com/ssray23/Open-In-Safari.git
cd Open-In-Safari
```

### Step 2: Load the Browser Extension
Before installing the host, you need to load the extension to generate its unique ID:
1. Open Chrome or Edge and navigate to `chrome://extensions/` (or `edge://extensions/`).
2. Toggle on **Developer mode** in the top right corner.
3. Click the **Load unpacked** button.
4. Select the `Extension` folder located inside the cloned directory.
5. Once loaded, copy the **Extension ID** generated for "Open in Safari" (e.g., `abcdefghijklmnopqrstuvwxyz`).

### Step 3: Install the Native Host
Run the installation script, providing the Extension ID you just copied as an argument:
```bash
./install.sh <YOUR_EXTENSION_ID>
```
The script will automatically:
- Compile the `Host/main.swift` code into a native macOS binary.
- Generate the Native Messaging manifest (`com.user.openinsafari.json`) configured explicitly for your Extension ID.
- Install the manifest into the required `NativeMessagingHosts` directories for Chrome and Edge.

## Usage
Simply right-click on any hyperlink or anywhere on a webpage, and click **Open in Safari**. The link or page will instantly open in your Safari browser!

*(Note: If it does not work on the first try after installation, simply click the Refresh icon on the extension page in Chrome to reload its permissions).*
