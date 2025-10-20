# Quick Reference - Common Commands

## 🚀 Daily Development

### Open Project
```bash
cd ~/Projects/CrystalPopJourney
open CrystalPopJourney.xcworkspace  # ⚠️ Use .xcworkspace NOT .xcodeproj!
```

### Update Dependencies
```bash
pod install
pod update
```

## 🔨 Building

### Quick Build Check
```bash
xcodebuild -scheme CrystalPopJourney -destination "generic/platform=iOS" clean build
```

### Full Archive for App Store
```bash
# 1. Increment build number
agvtool next-version -all

# 2. Create archive
xcodebuild archive \
  -scheme CrystalPopJourney \
  -archivePath ~/Desktop/CrystalPopJourney.xcarchive \
  -destination "generic/platform=iOS" \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  DEVELOPMENT_TEAM=8S568WN2TR \
  PROVISIONING_PROFILE_SPECIFIER="Crystal Pop App Store"

# 3. Export and upload
xcodebuild -exportArchive \
  -archivePath ~/Desktop/CrystalPopJourney.xcarchive \
  -exportOptionsPlist ~/Desktop/ExportOptions.plist \
  -exportPath ~/Desktop/ \
  -allowProvisioningUpdates
```

## 📱 Version Management

```bash
# Check current version
agvtool what-version
agvtool what-marketing-version

# Increment build number
agvtool next-version -all

# Set specific build number
agvtool new-version 5
```

## 🎨 Screenshot Resizing

```bash
# iPhone to iPad (2048x2732)
cd ~/Desktop/AppStoreAssets
for img in iPhone*.png; do
  sips -z 2732 2048 "$img" --out "iPad_${img}"
done

# Resize to specific dimensions
sips -z HEIGHT WIDTH input.png --out output.png
```

## 🐛 Troubleshooting

### Clean Everything
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean CocoaPods
pod deintegrate
pod install

# In Xcode: Product > Clean Build Folder (Cmd+Shift+K)
```

### Fix Build Issues
```bash
# If archive fails, try command-line instead of Xcode UI
xcodebuild archive ...

# If pods not found, reinstall
pod install
```

## 📝 Git Workflow

```bash
# Check what changed
git status
git diff

# Commit changes
git add -A
git commit -m "Your message

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
git push origin main
```

## 🔑 Key Information

### Project IDs
- **Bundle ID:** `com.monah.CrystalPopJourney`
- **Team ID:** `8S568WN2TR`
- **Leaderboard ID:** `com.monah.crystalpop.highscores`
- **Banner Ad ID:** `ca-app-pub-9779930258622875/1383943470`

### Important Files
- **Main Game:** `CrystalPopJourney/GameBoard.swift`
- **Arcade Missions:** `CrystalPopJourney/ArcadeMission.swift`
- **Monetization:** `CrystalPopJourney/MonetizationManager.swift`
- **Game Center:** `CrystalPopJourney/GameCenterManager.swift`

### Important URLs
- **GitHub:** https://github.com/Monah84/CrystalPopJourney
- **App Store Connect:** https://appstoreconnect.apple.com
- **AdMob:** https://admob.google.com

## 🎯 Next Development Session Checklist

- [ ] Read `DEVELOPER_GUIDE.md` for full context
- [ ] Open `.xcworkspace` (not `.xcodeproj`)
- [ ] Run `pod install` if needed
- [ ] Check `git status` for uncommitted changes
- [ ] Review current build number with `agvtool what-version`
- [ ] Understand the feature request
- [ ] Identify affected files
- [ ] Make changes
- [ ] Test thoroughly
- [ ] Commit and push

---

📖 **For detailed information, see `DEVELOPER_GUIDE.md`**
