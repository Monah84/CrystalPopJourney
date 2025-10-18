# ✅ Setup Checklist - Print This!

## 🎯 Complete These Steps in Order

---

### □ STEP 1: Create AdMob Ad Units (5 min)

**Go to**: https://admob.google.com

**Click**: "Crystal Pop Journey" → "Ad units" → "ADD AD UNIT"

**Create Interstitial Ad**:
- Click "Interstitial"
- Name: "Crystal Pop Interstitial"
- Click "CREATE AD UNIT"
- **Copy ID**: `____________________________________`

**Create Rewarded Ad**:
- Click "ADD AD UNIT" again
- Click "Rewarded"
- Name: "Crystal Pop Rewarded"
- Click "CREATE AD UNIT"
- **Copy ID**: `____________________________________`

---

### □ STEP 2: Install Dependencies (2 min)

**Open**: Terminal app (⌘+Space, type "Terminal")

**Run**:
```bash
cd /Users/monah/projects/CrystalPopJourney
./setup.sh
```

**Enter**: Your Mac password when asked

**Wait**: For "✅ Setup complete!" message

---

### □ STEP 3: Update Ad IDs (1 min)

**Open**: `CrystalPopJourney/MonetizationManager.swift` in TextEdit

**Find**: Lines 20-22

**Replace**:
```swift
private let interstitialAdUnitID = "PASTE_YOUR_INTERSTITIAL_ID_HERE"
private let rewardedAdUnitID = "PASTE_YOUR_REWARDED_ID_HERE"
```

**Save**: File (⌘+S)

---

### □ STEP 4: Create App Icons (3 min)

**In Terminal**:
```bash
cd /Users/monah/projects/CrystalPopJourney
pip3 install Pillow
python3 create_icons.py
```

**Icons created in**: `AppIcons` folder

---

### □ STEP 5: Open Project in Xcode (1 min)

**In Finder**: Go to `/Users/monah/projects/CrystalPopJourney/`

**Double-click**: `CrystalPopJourney.xcworkspace` (WHITE icon)

❌ **DON'T** click `.xcodeproj` (blue icon)

---

### □ STEP 6: Add Icons to Xcode (2 min)

**In Xcode**:
- Click `Assets.xcassets` (left panel)
- Click `AppIcon`

**In Finder**:
- Open `AppIcons` folder
- Select all icons
- Drag into Xcode AppIcon slots

---

### □ STEP 7: Connect iPhone & Setup Signing (5 min)

**Plug in iPhone** via USB

**In Xcode**:
- Top dropdown → Select your iPhone
- Click blue icon (left panel) → CrystalPopJourney
- Click "Signing & Capabilities" tab
- Check ✅ "Automatically manage signing"
- Select Team (your Apple ID)
  - If no team: Click "Add Account..." → Sign in

---

### □ STEP 8: Build & Run (5 min)

**In Xcode**: Click ▶️ (Play button)

**Wait**: 2-5 minutes for first build

**On iPhone**: App launches!

**If "Untrusted Developer"**:
- iPhone: Settings → General → VPN & Device Management
- Tap your Apple ID → Trust
- Back to Xcode → Click ▶️ again

---

### □ STEP 9: Test Everything (10 min)

**Test these**:
- [ ] Main menu appears
- [ ] Can select game modes
- [ ] Gameplay works
- [ ] Sounds play
- [ ] Power-ups appear
- [ ] High scores save
- [ ] Settings work
- [ ] Ad appears after game over
- [ ] No crashes

---

### □ STEP 10: Take Screenshots (5 min)

**While testing, capture**:
- Main menu
- Gameplay
- Different game modes
- High scores screen
- Settings screen

**How**: iPhone Side button + Volume Up

**Why**: Needed for App Store submission

---

## 🎉 Done! Your App is Ready!

### Next Steps (Optional):

- [ ] Create privacy policy
- [ ] Set up App Store Connect
- [ ] Submit for review
- [ ] Share with friends for beta testing
- [ ] Monitor AdMob earnings!

---

## 📞 Need Help?

**Read**: `COMPLETE_SETUP_GUIDE.md` for detailed instructions

**Stuck on Xcode?**: Read `XCODE_GUIDE_FOR_BEGINNERS.md`

**AdMob issues?**: Read `COMPLETE_ADMOB_INTEGRATION.md`

---

## ⏱ Total Time: ~40 minutes

You're doing great! Keep going! 💪

---

**Print this checklist and check off each step as you complete it!**
