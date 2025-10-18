# 📱 Xcode Guide for Complete Beginners

## What is Xcode?
Xcode is Apple's app for making iPhone apps. Think of it like Microsoft Word, but for code!

---

## Opening Your Project

### The RIGHT Way:
1. Open **Finder**
2. Navigate to: `/Users/monah/projects/CrystalPopJourney/`
3. **Double-click**: `CrystalPopJourney.xcworkspace`
   - Look for the WHITE icon with "workspace" in the name

### The WRONG Way (Don't Do This!):
- ❌ Don't click `CrystalPopJourney.xcodeproj` (blue icon)
- After installing CocoaPods, always use `.xcworkspace`!

---

## Understanding the Xcode Window

```
┌────────────────────────────────────────────────────────────┐
│  ▶️ Stop  [Device Dropdown ▼]  [Scheme Dropdown ▼]       │ ← Top Bar
├──────────┬────────────────────────────────────┬────────────┤
│          │                                    │            │
│  Files   │     Code Editor                    │ Inspector  │
│  (Left   │     (Main area where              │ (Right     │
│  Panel)  │      you see code)                │  Panel)    │
│          │                                    │            │
│          │                                    │            │
│          │                                    │            │
├──────────┴────────────────────────────────────┴────────────┤
│  Console / Debug Area                                      │ ← Bottom
│  (Error messages appear here)                              │   Panel
└────────────────────────────────────────────────────────────┘
```

---

## Important Buttons & What They Do

### 🔴 Top-Left Corner:
- **▶️ (Play Button)**: Builds and runs your app
- **⏹ (Stop Button)**: Stops the app
- Press **▶️** to test your app on iPhone!

### 📱 Device Dropdown (Next to Play Button):
- Shows where your app will run
- Click it to select:
  - **"Any iOS Device"** = Won't work (need real device)
  - **"iPhone 15 Pro"** = Simulator (fake iPhone on Mac)
  - **"Monah's iPhone"** = Your real iPhone (BEST!)

### 📂 Left Panel (Navigator):
- **📱 Blue Icon** = Your project settings
- **📄 Swift files** = Your app's code
- **🎨 Assets.xcassets** = Icons and images
- **📋 Info.plist** = App configuration

---

## How to Build & Run Your App

### Step 1: Connect iPhone
1. Plug iPhone into Mac with USB cable
2. Unlock your iPhone
3. Tap **"Trust This Computer"** if it asks

### Step 2: Select Your iPhone
1. Look at top of Xcode window
2. Find dropdown that says something like "iPhone 15 Pro"
3. Click it
4. Select your iPhone name (e.g., "Monah's iPhone")

### Step 3: Set Up Signing (First Time Only)
1. Click the **blue icon** in left panel (CrystalPopJourney)
2. Click **"Signing & Capabilities"** tab at top
3. Check ✅ **"Automatically manage signing"**
4. From **"Team"** dropdown, select your Apple ID
   - If no team available: Click **"Add Account..."**
   - Sign in with your Apple ID
   - Come back and select it

### Step 4: Build!
1. Click **▶️ (Play)** button
2. Wait 2-5 minutes (first time is slow)
3. Watch bottom panel for progress
4. App will appear on your iPhone!

---

## Common Screens You'll See

### 1. **Code Editor**:
- Shows your Swift code
- Don't worry if you don't understand it!
- Only edit if you need to change Ad IDs

### 2. **Assets.xcassets → AppIcon**:
- This is where you drag app icons
- You'll see empty squares for different sizes
- Drag icons from Finder into these squares

### 3. **Signing & Capabilities**:
- Where you set up your Apple ID
- Needed to run app on real iPhone
- Just check "Automatically manage signing"

---

## Helpful Keyboard Shortcuts

| Keys | Action |
|------|--------|
| ⌘ + R | Build and Run |
| ⌘ + . | Stop Running App |
| ⌘ + B | Build (compile) |
| ⌘ + ⇧ + K | Clean Build |
| ⌘ + 0 | Hide/Show Left Panel |
| ⌘ + ⇧ + Y | Hide/Show Bottom Panel |

---

## Reading Error Messages

### Where Errors Appear:
1. **Left Panel**: Red icons next to files
2. **Bottom Panel**: Detailed error messages
3. **Code Editor**: Red underlines in code

### Common Errors & Fixes:

#### "No Development Team"
- **Fix**: Go to Signing & Capabilities → Select your Apple ID

#### "Untrusted Developer" (on iPhone)
- **Fix**: Settings → General → VPN & Device Management → Trust

#### "Build Failed"
- **Fix**: Press ⌘⇧K (Clean), then ⌘B (Build Again)

#### "Could not find module GoogleMobileAds"
- **Fix**: Make sure you opened `.xcworkspace` not `.xcodeproj`

---

## Panels You Can Hide/Show

### If Screen Feels Cluttered:
- **Hide Left Panel**: Click button at top-left (looks like ⚏)
- **Hide Right Panel**: Click button at top-right (looks like ⚏)
- **Hide Bottom Panel**: Click button at bottom-right (looks like ⚏)
- Press the same buttons to show them again!

---

## Where Everything Is Located

### Your Project Files (in Finder):
```
CrystalPopJourney/
├── CrystalPopJourney.xcworkspace  ← Open this!
├── CrystalPopJourney.xcodeproj    ← Don't open this
├── Podfile                        ← CocoaPods config
├── CrystalPopJourney/             ← Your app code
│   ├── GameScene.swift
│   ├── MenuScene.swift
│   ├── MonetizationManager.swift  ← Edit Ad IDs here
│   ├── Info.plist                 ← App settings
│   └── Assets.xcassets/           ← Icons & images
└── Pods/                          ← Google Ads library
```

---

## Quick Tips

### ✅ DO:
- Always open `.xcworkspace` file
- Keep iPhone unlocked during build
- Wait for build to finish (2-5 minutes)
- Read error messages in bottom panel
- Save your work (⌘S) before building

### ❌ DON'T:
- Don't close Xcode during build
- Don't unplug iPhone during build
- Don't edit code if you don't understand it
- Don't ignore red error messages

---

## Testing Your App

### When App Runs on iPhone:
1. **Main Menu** should appear
2. Tap **"Play"** to see game modes
3. Tap **"High Scores"** to see leaderboard
4. Tap **"Settings"** to change sound
5. Try playing a game!

### What to Check:
- ✅ All buttons work
- ✅ Sound plays
- ✅ Game modes selectable
- ✅ High scores save
- ✅ Ads show (after game over)

---

## Getting App on Other iPhones

### For Testing (Free):
1. Plug in another iPhone
2. Select it in Xcode
3. Click ▶️
4. App installs!
5. **Note**: App expires after 7 days (need to reinstall)

### For Real Distribution (Paid):
1. Need Apple Developer account ($99/year)
2. Submit to App Store
3. Anyone can download!

---

## Need More Help?

### Resources:
- **Apple's Xcode Help**: Help menu → Xcode Help
- **Xcode Shortcuts**: Help menu → Keyboard Shortcuts
- **Apple Developer Forums**: developer.apple.com/forums

### If You Get Stuck:
1. Look at error message in bottom panel
2. Google the error message
3. Ask for help!

---

**You've got this! Xcode looks scary at first, but you only need to know these basics! 💪**
