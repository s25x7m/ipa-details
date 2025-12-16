# Quick Reference - GitHub Publishing

## Repository Structure
```
ipa-details/
├── README.md              # Main documentation (English, with Arabic link)
├── README_AR.md           # Arabic documentation
├── LICENSE                # MIT License
├── .gitignore            # Git ignore rules
├── install.sh            # Installation script
├── ipa-preview           # Main preview script
├── provision-preview.sh  # Provisioning profile handler
└── docs/
    ├── INSTALL_EN.md     # English installation guide
    ├── INSTALL_AR.md     # Arabic installation guide
    └── images/
        └── README.md     # Screenshot placeholder
```

## Next Steps to Publish

### 1. Configure Git Identity (Optional)
```bash
git config user.name "x7mii"
git config user.email "your-email@example.com"
```

### 2. Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `ipa-details` (or `IPAQuickLook`)
3. Description: "IPA and Provisioning Profile Viewer for Apple Silicon Macs"
4. Public repository
5. Don't initialize with README (we already have one)
6. Click "Create repository"

### 3. Push to GitHub
```bash
cd /Users/x7mii/Desktop/IPAQuickLook

# Add remote (replace x7mii with your GitHub username if different)
git remote add origin https://github.com/x7mii/ipa-details.git

# Push to GitHub
git push -u origin main
```

### 4. Add Screenshots (Optional but Recommended)
```bash
# Take screenshots of the preview in your browser
# Save them to docs/images/
# Example:
# - docs/images/ipa-preview.png
# - docs/images/profile-preview.png

# Then commit:
git add docs/images/*.png
git commit -m "Add preview screenshots"
git push
```

### 5. Create a Release (Optional)
1. Go to your repository on GitHub
2. Click "Releases" → "Create a new release"
3. Tag: `v1.0.0`
4. Title: "IPA Details Viewer v1.0"
5. Description: First stable release
6. Click "Publish release"

## What's Included

✅ **Documentation**
- Main README in English with Arabic link
- Complete Arabic README
- Detailed installation guides in both languages
- MIT License

✅ **Credits**
- "Made by x7mii 🚀" in README
- Credits in installation script output
- Author section in README with GitHub link

✅ **Code**
- Clean, documented scripts
- No personal data
- Dynamic paths (no hardcoded directories)
- Proper error handling

✅ **Structure**
- Organized docs/ folder
- Separate installation guides
- Screenshot placeholders
- Git ignore for temp files

## Repository URLs

After publishing, your project will be at:
- Main: `https://github.com/x7mii/ipa-details`
- Clone: `git clone https://github.com/x7mii/ipa-details.git`

## Testing Installation from GitHub

After publishing, test that users can install:

```bash
# Clone
git clone https://github.com/x7mii/ipa-details.git
cd ipa-details

# Install
chmod +x install.sh
./install.sh
```

## Updating the Repository

When you make changes:

```bash
# Stage changes
git add .

# Commit
git commit -m "Description of changes"

# Push
git push
```

---

**Made by x7mii** 🚀
