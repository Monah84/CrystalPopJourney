# Crystal Pop Journey - Developer Guide

## 📱 Project Overview

**Crystal Pop Journey** is an iOS match-3 puzzle game built with SpriteKit to raise awareness about Duchenne Muscular Dystrophy (DMD). The game features multiple game modes, Game Center integration, and AdMob monetization.

- **Bundle ID:** `com.monah.CrystalPopJourney`
- **Team ID:** `8S568WN2TR`
- **Developer:** Monah Bou Hatoum
- **Minimum iOS Version:** 12.0
- **Current Version:** 1.0
- **Current Build:** 3

## 🏗️ Technical Stack

### Frameworks & Technologies
- **SpriteKit** - 2D game engine
- **Swift 5** - Programming language
- **GameKit** - Game Center integration
- **StoreKit** - In-app purchases
- **Google AdMob** - Ad monetization (via CocoaPods)
- **UIKit** - View controller management

### Dependencies (CocoaPods)
```ruby
pod 'Google-Mobile-Ads-SDK'
```

## 📁 Project Structure

```
CrystalPopJourney/
├── CrystalPopJourney/
│   ├── Core Game Files
│   │   ├── GameScene.swift          # Main gameplay scene
│   │   ├── GameBoard.swift          # Game board logic & crystal matching
│   │   ├── Crystal.swift            # Crystal model & animations
│   │   ├── PowerUp.swift            # Power-up system
│   │   └── LevelManager.swift       # Level progression
│   │
│   ├── Game Modes
│   │   ├── GameMode.swift           # Game mode definitions
│   │   ├── ArcadeMission.swift      # Arcade mission system
│   │   └── GameModeManager.swift    # Mode selection & high scores
│   │
│   ├── UI Scenes
│   │   ├── MenuScene.swift          # Main menu
│   │   ├── ModeSelectionScene.swift # Game mode selection
│   │   ├── SettingsScene.swift      # Settings screen
│   │   ├── ScoresScene.swift        # High scores display
│   │   └── AboutDMDScene.swift      # DMD awareness information
│   │
│   ├── Managers
│   │   ├── GameCenterManager.swift  # Leaderboards & achievements
│   │   ├── MonetizationManager.swift # Ads & IAP
│   │   ├── SoundManager.swift       # Audio & haptics
│   │   └── FontManager.swift        # Font management
│   │
│   ├── View Controllers
│   │   ├── GameViewController.swift # Root view controller
│   │   └── AppDelegate.swift        # App lifecycle
│   │
│   ├── Resources
│   │   ├── Assets.xcassets/         # Images, icons, colors
│   │   ├── Base.lproj/             # Storyboards
│   │   └── Info.plist              # App configuration
│   │
│   └── Configuration
│       └── CrystalPopJourney.entitlements # Game Center entitlement
│
├── Frameworks/                       # GoogleMobileAds.xcframework
├── Podfile                          # CocoaPods dependencies
└── README.md                        # Public project documentation
```

## 🎮 Game Modes

### 1. Classic Mode (🎯)
- **Starting Moves:** 30
- **Objective:** Get highest score with limited moves
- **Features:** Standard match-3 gameplay

### 2. Timed Mode (⏱️)
- **Starting Time:** 60 seconds
- **Objective:** Race against the clock
- **Features:** Time extensions via power-ups

### 3. Arcade Mode (🎪)
- **Starting Moves:** 50
- **Objective:** Complete progressive missions
- **Features:**
  - Mission-based progression
  - Bonus moves for completing missions
  - Progress saved across sessions
  - Ends when moves run out

### 4. Challenge Mode (🏆)
- **Starting Moves:** 25
- **Objective:** Complete levels with specific goals
- **Features:** Progressive difficulty

## 🔑 Key Components

### GameBoard.swift
The heart of the game logic:
- **Board Size:** 8x8 grid
- **Crystal Size:** 40x40 pixels (fixed)
- **Crystal Spacing:** 42px (2px gap)
- **Match Detection:** Horizontal & vertical 3+ matches
- **Special Features:**
  - Force fill safety mechanism
  - Board scrambling when no moves
  - Power-up spawning
  - Mission tracking for arcade mode

### ArcadeMission.swift
Mission system for arcade mode:
- Progressive difficulty (10+ mission types)
- Objectives track crystal destruction by type
- Progress persistence via UserDefaults
- Automatic save/load on app launch

### GameCenterManager.swift
Game Center integration:
- **Leaderboard ID:** `com.monah.crystalpop.highscores`
- Authentication handling
- Score submission
- Leaderboard display

### MonetizationManager.swift
Ad monetization via AdMob:
- **Banner Ad Unit ID:** `ca-app-pub-9779930258622875/1383943470`
- Interstitial ads (test ID currently)
- Rewarded ads (test ID currently)
- In-app purchase support
- Ad frequency: Every 2 games
- Banner positioned at bottom (50px height)

## 🔧 Development Setup

### Prerequisites
1. **Xcode 12.0+** installed
2. **CocoaPods** installed: `sudo gem install cocoapods`
3. **Apple Developer Account** with Team ID: 8S568WN2TR
4. **Git** configured with GitHub access

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/Monah84/CrystalPopJourney.git
cd CrystalPopJourney

# Install dependencies
pod install

# Open workspace (NOT .xcodeproj!)
open CrystalPopJourney.xcworkspace
```

### Important: Always use .xcworkspace
After running `pod install`, **ALWAYS** open `CrystalPopJourney.xcworkspace` instead of `CrystalPopJourney.xcodeproj` to ensure CocoaPods dependencies are included.

## 📝 Code Signing Configuration

### Manual Signing (for App Store)
- **Code Sign Identity:** Apple Distribution
- **Provisioning Profile:** "Crystal Pop App Store"
- **Team ID:** 8S568WN2TR
- **Entitlements:** Game Center capability required

### Provisioning Profile Location
Created manually in Apple Developer portal with Game Center enabled.

## 🚀 Build & Deploy Workflow

### 1. Local Testing
```bash
# Build for device
xcodebuild -scheme CrystalPopJourney \
  -destination "generic/platform=iOS" \
  clean build
```

### 2. Increment Build Number
```bash
# Auto-increment
agvtool next-version -all

# Or set specific version
agvtool new-version 4
```

### 3. Create Archive
```bash
xcodebuild archive \
  -scheme CrystalPopJourney \
  -archivePath ~/Desktop/CrystalPopJourney.xcarchive \
  -destination "generic/platform=iOS" \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  DEVELOPMENT_TEAM=8S568WN2TR \
  PROVISIONING_PROFILE_SPECIFIER="Crystal Pop App Store"
```

### 4. Export & Upload to App Store
```bash
xcodebuild -exportArchive \
  -archivePath ~/Desktop/CrystalPopJourney.xcarchive \
  -exportOptionsPlist ~/Desktop/ExportOptions.plist \
  -exportPath ~/Desktop/ \
  -allowProvisioningUpdates
```

**ExportOptions.plist:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>destination</key>
    <string>upload</string>
    <key>method</key>
    <string>app-store</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.monah.CrystalPopJourney</key>
        <string>Crystal Pop App Store</string>
    </dict>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>teamID</key>
    <string>8S568WN2TR</string>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
```

### 5. Git Workflow
```bash
# Check status
git status

# Stage all changes
git add -A

# Commit with co-author
git commit -m "Your message

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
git push origin main
```

## 🎨 App Store Assets

### Icon Sizes Required
Located in `Assets.xcassets/AppIcon.appiconset/`:
- 1024x1024 (App Store)
- 180x180 (iPhone @3x)
- 120x120 (iPhone @2x)
- 167x167 (iPad Pro @2x)
- 152x152 (iPad @2x)
- 76x76 (iPad @1x)
- And various notification/spotlight icons

### Screenshots
Located in `/Users/monah/Desktop/AppStoreAssets/`:
- **iPhone:** 1290x2796 (iPhone 15 Pro Max)
- **iPad:** 2048x2732 (12.9" iPad Pro)

Use `sips` to resize:
```bash
sips -z 2732 2048 input.png --out output.png
```

## ⚙️ App Store Connect Configuration

### App Information
- **App Name:** Crystal Pop Journey
- **Bundle ID:** com.monah.CrystalPopJourney
- **Primary Category:** Games > Puzzle
- **Price:** Free (with ads)

### Game Center Setup
1. Navigate to: Services > Game Center
2. **Leaderboard ID:** `com.monah.crystalpop.highscores`
3. **⚠️ CRITICAL:** Score Sort Order must be **"High to Low"** (not Low to High)
4. **Score Format:** Integer
5. **Score Range:** 0 - 999999999

### App Privacy
- **Tracking:** No tracking (user can opt out)
- **Data Collection:**
  - Device ID (for advertising)
  - Advertising Data (third-party ads via AdMob)
- **Third-Party Advertising:** Yes (selected)
- **Analytics:** No
- **Product Personalization:** No

### Content Rights
- Age Rating: 4+
- Export Compliance: No encryption
- Content Rights: Owns all rights

## 🐛 Common Issues & Solutions

### Issue: "GoogleMobileAds not found"
**Solution:**
```bash
pod install
# Then open .xcworkspace (not .xcodeproj)
```

### Issue: Archive fails at step 76/89
**Solution:** Use command-line instead of Xcode UI:
```bash
xcodebuild archive ... # (full command above)
```

### Issue: "Provisioning profile doesn't support Game Center"
**Solution:**
1. Delete old provisioning profile
2. Create new one in Apple Developer portal
3. Enable Game Center capability
4. Download and install

### Issue: Xcode shows phantom build errors
**Solution:**
1. Clean build folder: `Product > Clean Build Folder`
2. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Use command-line build instead

### Issue: File not in build target
**Solution:** Manually edit `project.pbxproj`:
1. Add file reference in `PBXFileReference` section
2. Add to `PBXBuildFile` section
3. Add to `PBXSourcesBuildPhase` section

### Issue: Leaderboard scores not updating
**Solution:** Check leaderboard sort order in App Store Connect. Must be "High to Low" for highest-score-wins games.

### Issue: Banner ads not showing
**Solution:**
1. Verify `pod install` was run
2. Check `MonetizationManager.areAdsRemoved()` returns false
3. Verify banner view was added to view hierarchy with constraints
4. Check AdMob dashboard for ad unit status

## 📊 AdMob Configuration

### Production Ad Units (To Be Created)
When ready for production, create these in [AdMob Console](https://admob.google.com):

1. **Banner Ad** (already created)
   - ID: `ca-app-pub-9779930258622875/1383943470`
   - Type: Banner
   - Size: 320x50

2. **Interstitial Ad** (TODO: Create and replace test ID)
   - Current: Test ID `ca-app-pub-3940256099942544/4411468910`
   - Location: Game over screen
   - Frequency: Every 2 games

3. **Rewarded Ad** (TODO: Create and replace test ID)
   - Current: Test ID `ca-app-pub-3940256099942544/1712485313`
   - Reward: 50 coins or bonus moves
   - User-initiated

**Where to update IDs:** `MonetizationManager.swift` lines 23-24

## 🔐 Security & Sensitive Data

### Never Commit:
- ✅ AuthKey_*.p8 files (API keys)
- ✅ Provisioning profiles with embedded certificates
- ✅ Private keys
- ✅ App Store Connect passwords

### Safe to Commit:
- ✅ Team ID (8S568WN2TR)
- ✅ Bundle ID (com.monah.CrystalPopJourney)
- ✅ App-specific password references
- ✅ AdMob ad unit IDs (public)
- ✅ Leaderboard IDs

## 🎯 Feature Development Checklist

When adding new features:

1. **Plan**
   - [ ] Define feature requirements
   - [ ] Identify affected files
   - [ ] Check for breaking changes

2. **Develop**
   - [ ] Write code following existing patterns
   - [ ] Use Swift naming conventions
   - [ ] Add print statements for debugging

3. **Test**
   - [ ] Test on different device sizes
   - [ ] Test all game modes
   - [ ] Verify no gaps on game board
   - [ ] Check memory leaks

4. **Build**
   - [ ] Increment build number
   - [ ] Clean build folder
   - [ ] Archive successfully
   - [ ] No compiler warnings

5. **Deploy**
   - [ ] Commit changes with descriptive message
   - [ ] Push to GitHub
   - [ ] Upload to App Store Connect
   - [ ] Test in TestFlight

## 📖 Code Style Guide

### Swift Conventions
```swift
// Class names: PascalCase
class GameBoard {}

// Function names: camelCase
func createRandomCrystal() {}

// Constants: camelCase
private let crystalSize: CGFloat = 40

// Enums: PascalCase
enum CrystalType: Int, CaseIterable {
    case red = 0, blue, green
}
```

### Comments
```swift
// MARK: - Section Headers for organization

// Single-line comments for brief explanations

/// Documentation comments for public APIs
func submitScore(_ score: Int) {}

// DEBUG comments for temporary debugging
print("DEBUG: Board state: \(crystals.count)")

// SAFETY comments for critical safety checks
forceFillAnyMissingTiles() // SAFETY: Prevent gaps
```

## 🔄 State Management

### UserDefaults Keys
- `HighScore` - Legacy high score (deprecated)
- `SoundEnabled` - Sound effects toggle
- `MusicEnabled` - Background music toggle
- `ClassicHighScore` - Classic mode high score
- `TimedHighScore` - Timed mode high score
- `ArcadeHighScore` - Arcade mode high score
- `ChallengeHighScore` - Challenge mode high score
- `ArcadeMissionNumber` - Current arcade mission
- `ArcadeObjectiveTypes` - Mission objective types (Int array)
- `ArcadeObjectiveTargets` - Mission objective targets (Int array)
- `ArcadeObjectiveCurrents` - Mission objective progress (Int array)
- `AdsRemoved` - Whether ads are disabled
- `PlayerCoins` - Virtual currency balance
- `GamesPlayed` - Counter for ad frequency

## 🎮 Game Mechanics

### Crystal Matching
- Minimum match: 3 crystals
- Match detection: Horizontal + Vertical
- Board refill: Top to bottom gravity
- Scramble: Triggered when no moves available

### Power-Ups
1. **Extra Moves** (+5 moves)
2. **Double Points** (2x current score)
3. **Bomb Clear** (5x5 area clear)
4. **Time Extension** (+10 seconds, timed mode only)

**Spawn Rate:** 30% chance every 3 matches

### Scoring System
- Base score: `matches × 10 × level`
- Bomb clear: `crystals × 20 × level`
- Mission bonus: `100 × mission_number`

## 📞 Support & Resources

### Documentation
- [SpriteKit Documentation](https://developer.apple.com/documentation/spritekit)
- [Game Center Guide](https://developer.apple.com/game-center/)
- [AdMob iOS Guide](https://developers.google.com/admob/ios/quick-start)
- [App Store Connect Help](https://developer.apple.com/app-store-connect/)

### Important URLs
- **GitHub Repository:** https://github.com/Monah84/CrystalPopJourney
- **App Store Connect:** https://appstoreconnect.apple.com
- **Apple Developer Portal:** https://developer.apple.com/account
- **AdMob Console:** https://admob.google.com

### DMD Awareness
This game raises awareness for **Duchenne Muscular Dystrophy (DMD)**. Resources:
- [Parent Project Muscular Dystrophy](https://www.parentprojectmd.org/)
- [Duchenne UK](https://www.duchenneuk.org/)
- [CureDuchenne](https://www.cureduchenne.org/)

## 🎊 Credits

**Developer:** Monah Bou Hatoum
**AI Assistant:** Claude Code by Anthropic
**Purpose:** DMD Awareness & Fundraising
**License:** Proprietary

---

**Last Updated:** October 2025
**Document Version:** 1.0
**For:** Future development sessions
