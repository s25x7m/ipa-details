# IPA Details Viewer

<div align="center">

![IPA Details](https://img.shields.io/badge/macOS-11.0+-blue.svg)
![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-Ready-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

**[العربية](README.md)** | **[English](README_EN.md)**

A fast, lightweight macOS application to view details of iOS application packages (`.ipa` files) and provisioning profiles on Apple Silicon Macs.

</div>

---

## ✨ Features

- 📱 **IPA File Analysis** - View comprehensive details about iOS applications
- 🔐 **Provisioning Profile Viewer** - Examine `.mobileprovision` and `.provisionprofile` files
- 📦 **App Bundle Support** - Inspect `.app` bundles directly
- ⚡ **Fast Performance** - Optimized extraction, only reads necessary files
- 🎨 **Clean Interface** - Modern HTML-based preview in your default browser
- 🔍 **Certificate Details** - Full certificate information including SHA-1 fingerprints
- 📋 **Entitlements Display** - Properly formatted app entitlements
- 🎯 **Device UDIDs** - Complete list of provisioned devices

## 📸 Screenshots

<div align="center">

### IPA File Preview
![IPA Preview](docs/images/test1.png)
*Comprehensive app information including frameworks, entitlements, and certificates*

### Provisioning Profile Preview
![Profile Preview](docs/images/test2.png)
*Complete provisioning profile details with device UDIDs and certificates*

</div>

## 🚀 Quick Start

### Installation

See detailed installation guides:
- **[English Installation Guide](docs/INSTALL_EN.md)**
- **[دليل التثبيت بالعربية](docs/INSTALL_AR.md)**

Quick install:
```bash
git clone https://github.com/x7mii/ipa-details.git
cd ipa-details
chmod +x install.sh
./install.sh
```

### Usage

1. Right-click any `.ipa`, `.mobileprovision`, or `.app` file
2. Choose **Open With** → **IPA Details**
3. Preview opens in your browser



## How It Works

Unlike traditional QuickLook plugins (which no longer work on modern macOS due to security restrictions), IPA Details Viewer:

1. Uses an AppleScript-based app wrapper to handle file opening
2. Extracts only necessary files from IPA archives (not the entire package)
3. Parses provisioning profiles and certificates using native macOS tools
4. Generates a styled HTML preview
5. Opens the preview in your default browser

This approach works reliably on Apple Silicon Macs without requiring System Integrity Protection (SIP) to be disabled.

## Technical Details

- **No QuickLook Plugin**: Traditional `.qlgenerator` plugins don't work on modern macOS
- **Fast Extraction**: Only extracts `Info.plist`, `embedded.mobileprovision`, and one icon file
- **Native Tools**: Uses `security`, `defaults`, `openssl`, and `PlistBuddy` for parsing
- **Certificate Parsing**: Extracts full certificate information including SHA-1 fingerprints
- **Entitlements Display**: Properly formats all app entitlements
- **Background Processing**: Keeps temp files until browser is closed

## Uninstallation

```bash
sudo rm -rf "/Applications/IPA Details.app"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "/Applications/IPA Details.app"
```

## 💡 Inspiration

This project was inspired by [ProvisionQL](https://github.com/ealeksandrov/ProvisionQL), which provided QuickLook preview for provisioning profiles and IPA files. Since QuickLook plugins no longer work on Apple Silicon Macs, this project provides an alternative solution.

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 👨‍💻 Author

**Made by x7mii** 🚀

- GitHub: [@x7mii](https://github.com/x7mii)

## 🙏 Acknowledgments

- Based on the functionality of [ProvisionQL](https://github.com/ealeksandrov/ProvisionQL)
- Uses native macOS command-line tools for parsing

---

<div align="center">

**If you find this useful, please give it a ⭐️**

</div>
3. Test the plugin manually:
   ```bash
   qlmanage -p /path/to/your/file.ipa
   ```

4. Check if the plugin is registered:
   ```bash
   qlmanage -m
   ```

## License

MIT License - Feel free to use and modify as needed.

## Credits

Inspired by [ProvisionQL](https://github.com/ealeksandrov/ProvisionQL) with updates for modern macOS and Apple Silicon support.
