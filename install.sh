#!/bin/bash

# IPA Details Viewer Installation Script
# Made by x7mii
# This script installs the IPA Details app and registers it with macOS

set -e

APP_NAME="IPA Details"
APP_PATH="/Applications/${APP_NAME}.app"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing IPA Details Viewer..."
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Error: This script only runs on macOS"
    exit 1
fi

# Create the app structure
echo "📦 Creating application bundle..."
mkdir -p "${APP_PATH}/Contents/MacOS"
mkdir -p "${APP_PATH}/Contents/Resources"

# Copy the main scripts
echo "📋 Copying scripts..."
cp "${SCRIPT_DIR}/ipa-preview" "${APP_PATH}/Contents/MacOS/"
cp "${SCRIPT_DIR}/provision-preview.sh" "${APP_PATH}/Contents/MacOS/"
chmod +x "${APP_PATH}/Contents/MacOS/ipa-preview"
chmod +x "${APP_PATH}/Contents/MacOS/provision-preview.sh"

# Create Info.plist
echo "⚙️  Configuring application..."
cat > "${APP_PATH}/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>applet</string>
    <key>CFBundleIconFile</key>
    <string>applet</string>
    <key>CFBundleIdentifier</key>
    <string>com.ipadetails.viewer</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>IPA Details</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
                <string>ipa</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>iOS Application Archive</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Alternate</string>
        </dict>
        <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
                <string>mobileprovision</string>
                <string>provisionprofile</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>Provisioning Profile</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Alternate</string>
        </dict>
        <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
                <string>app</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>iOS Application Bundle</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Alternate</string>
        </dict>
    </array>
</dict>
</plist>
EOF

# Create the AppleScript launcher
echo "🔧 Creating launcher..."
cat > "/tmp/ipa_details_script.applescript" << 'EOF'
on open theFiles
    repeat with aFile in theFiles
        set filePath to POSIX path of aFile
        set fileExtension to ""
        
        try
            do shell script "echo " & quoted form of filePath & " | grep -o '\\.[^.]*$' | tr -d '.'"
            set fileExtension to result
        end try
        
        if fileExtension is in {"ipa", "mobileprovision", "provisionprofile", "app"} then
            set scriptPath to POSIX path of (path to me)
            set appPath to do shell script "dirname " & quoted form of scriptPath
            set previewScript to appPath & "/ipa-preview"
            
            do shell script quoted form of previewScript & " " & quoted form of filePath & " > /dev/null 2>&1 &"
        end if
    end repeat
end open
EOF

# Compile the AppleScript
osacompile -o "${APP_PATH}/Contents/MacOS/applet" "/tmp/ipa_details_script.applescript"
rm "/tmp/ipa_details_script.applescript"

# Set executable permission
chmod +x "${APP_PATH}/Contents/MacOS/applet"

# Register the app with LaunchServices
echo "📝 Registering with system..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "${APP_PATH}"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📖 Usage:"
echo "   1. Right-click any .ipa, .mobileprovision, or .app file"
echo "   2. Choose 'Open With' → 'IPA Details'"
echo "   3. Preview opens in your browser"
echo ""
echo "💡 To set as default viewer:"
echo "   Right-click → Get Info → Open with: IPA Details → Change All..."
echo ""
echo "Made by x7mii 🚀"
echo ""
