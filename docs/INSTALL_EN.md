# Installation Guide - IPA Details Viewer

Complete installation instructions for IPA Details Viewer on macOS.

## Prerequisites

- macOS 11.0 or later
- Apple Silicon (M1/M2/M3/M4) or Intel Mac
- Terminal access

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/x7mii/ipa-details.git
cd ipa-details
```

### 2. Run the Installation Script

```bash
chmod +x install.sh
./install.sh
```

### 3. What the Installer Does

The installation script will automatically:

- ✅ Create "IPA Details.app" in `/Applications`
- ✅ Copy the preview scripts to the app bundle
- ✅ Configure file type associations for `.ipa`, `.mobileprovision`, `.provisionprofile`, and `.app` files
- ✅ Register the application with macOS Launch Services
- ✅ Set proper permissions

### 4. Verify Installation

After installation completes, you should see:

```
✅ Installation complete!

📖 Usage:
   1. Right-click any .ipa, .mobileprovision, or .app file
   2. Choose 'Open With' → 'IPA Details'
   3. Preview opens in your browser

💡 To set as default viewer:
   Right-click → Get Info → Open with: IPA Details → Change All...
```

## Usage Methods

### Method 1: Right-Click Menu (Recommended)

1. Navigate to any `.ipa`, `.mobileprovision`, or `.app` file in Finder
2. Right-click (or Control+click) on the file
3. Select **Open With** → **IPA Details**
4. The preview will open in your default web browser

### Method 2: Set as Default Viewer

To make IPA Details the default application for IPA files:

1. Right-click any `.ipa` file
2. Choose **Get Info** (⌘+I)
3. In the "Open with:" section, select **IPA Details**
4. Click **Change All...** to apply to all IPA files
5. Confirm the change

### Method 3: Double-Click

Once set as the default viewer, simply double-click any supported file to open it with IPA Details.

## Troubleshooting

### Application Not Appearing in "Open With" Menu

If IPA Details doesn't appear in the "Open With" menu:

```bash
# Re-register the application
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/IPA Details.app"

# Restart Finder
killall Finder
```

### Preview Not Opening

If the preview doesn't open in your browser:

1. Check that the scripts have execute permissions:
```bash
ls -la "/Applications/IPA Details.app/Contents/MacOS/"
```

2. Re-run the installation script:
```bash
./install.sh
```

### Permission Denied Errors

If you encounter permission errors during installation:

```bash
# Add sudo to the installation command
sudo ./install.sh
```

### Script Not Found Errors

Ensure you're running the installation from the correct directory:

```bash
# Navigate to the project directory
cd /path/to/ipa-details

# Verify files exist
ls -la install.sh ipa-preview provision-preview.sh

# Run installation
./install.sh
```

## Uninstallation

To completely remove IPA Details from your system:

```bash
# Remove the application
sudo rm -rf "/Applications/IPA Details.app"

# Unregister from Launch Services
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "/Applications/IPA Details.app"

# Restart Finder
killall Finder
```

## Manual Installation (Advanced)

If you prefer to install manually:

1. Create the application bundle:
```bash
mkdir -p "/Applications/IPA Details.app/Contents/MacOS"
mkdir -p "/Applications/IPA Details.app/Contents/Resources"
```

2. Copy the scripts:
```bash
cp ipa-preview "/Applications/IPA Details.app/Contents/MacOS/"
cp provision-preview.sh "/Applications/IPA Details.app/Contents/MacOS/"
chmod +x "/Applications/IPA Details.app/Contents/MacOS/ipa-preview"
chmod +x "/Applications/IPA Details.app/Contents/MacOS/provision-preview.sh"
```

3. Create the Info.plist (see install.sh for the complete plist content)

4. Create and compile the AppleScript launcher (see install.sh for details)

5. Register with Launch Services:
```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/IPA Details.app"
```

## System Requirements

- **Operating System**: macOS 11.0 (Big Sur) or later
- **Architecture**: Apple Silicon or Intel (Universal)
- **Disk Space**: ~50 KB for the application
- **Dependencies**: All required tools are built into macOS:
  - `security` - For CMS decoding and certificate parsing
  - `defaults` / `PlistBuddy` - For plist parsing
  - `openssl` - For certificate details
  - `python3` - For JSON formatting
  - `unzip` - For IPA extraction

## Security & Privacy

- **No Network Access**: All processing is done locally
- **No Data Collection**: Your files are never uploaded or shared
- **Read-Only**: The application only reads files, never modifies them
- **SIP Compatible**: Works without disabling System Integrity Protection
- **Sandboxed Execution**: Scripts run in isolated temporary directories

## Support

For issues, bugs, or feature requests:
- Open an issue on [GitHub](https://github.com/x7mii/ipa-details/issues)
- Check existing issues for solutions
- Provide detailed error messages and system information

---

**Made by x7mii** 🚀
