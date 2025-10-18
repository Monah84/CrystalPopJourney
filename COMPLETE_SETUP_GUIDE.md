# 📱 Complete Setup Guide - Crystal Pop Journey
## For Complete Beginners (No Xcode Experience Needed!)

---

## 🎯 STEP 1: Create Your Missing AdMob Ad Units (10 minutes)

You already have:
- ✅ App ID: `ca-app-pub-9779930258622875~1132662037`
- ✅ Banner Ad: `ca-app-pub-9779930258622875/1383943470`

You need to create 2 more:

### A. Create Interstitial Ad Unit:
1. Open Safari and go to: **https://admob.google.com**
2. Click on **"Crystal Pop Journey"** (your app name)
3. Click **"Ad units"** tab at the top
4. Click blue **"ADD AD UNIT"** button
5. Click **"Interstitial"** (full-screen ad)
6. Name it: **"Crystal Pop Interstitial"**
7. Click **"CREATE AD UNIT"**
8. **COPY THE ID** that appears (looks like: `ca-app-pub-9779930258622875/XXXXXXXXXX`)
9. **SAVE THIS ID** - you'll need it in Step 3

### B. Create Rewarded Ad Unit:
1. Click **"ADD AD UNIT"** button again
2. Click **"Rewarded"** (user watches for reward)
3. Name it: **"Crystal Pop Rewarded"**
4. Click **"CREATE AD UNIT"**
5. **COPY THE ID** that appears
6. **SAVE THIS ID** - you'll need it in Step 3

---

## 🔧 STEP 2: Install Google Mobile Ads SDK (5 minutes)

### Option A: Automated (Easiest)
1. Open **Terminal** app (press ⌘+Space, type "Terminal", press Enter)
2. Copy and paste this command:
```bash
cd /Users/monah/projects/CrystalPopJourney && ./setup.sh
```
3. Press Enter
4. If asked for password, type your Mac password and press Enter

### Option B: Manual
1. Open **Terminal**
2. Run these commands one by one:
```bash
cd /Users/monah/projects/CrystalPopJourney
sudo gem install cocoapods
pod install
```
3. When done, you'll see "Pod installation complete!"

---

## 📝 STEP 3: Update Your Ad IDs in Code (2 minutes)

1. In **Finder**, navigate to:
   `/Users/monah/projects/CrystalPopJourney/CrystalPopJourney/`

2. Right-click **MonetizationManager.swift**

3. Choose **"Open With" → "TextEdit"** (or any text editor)

4. Find lines 20-22 (they look like this):
```swift
private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
```

5. Replace with YOUR IDs from Step 1:
```swift
private let interstitialAdUnitID = "ca-app-pub-9779930258622875/YOUR_INTERSTITIAL_ID"
private let rewardedAdUnitID = "ca-app-pub-9779930258622875/YOUR_REWARDED_ID"
```

6. Save the file (⌘+S)

---

## 🚀 STEP 4: Test on Your iPhone (10 minutes)

### A. Connect Your iPhone:
1. Plug your iPhone into your Mac with USB cable
2. On iPhone: **Trust This Computer** if asked
3. Enter your iPhone passcode

### B. Open Project in Xcode:
1. In **Finder**, go to: `/Users/monah/projects/CrystalPopJourney/`
2. **Double-click**: `CrystalPopJourney.xcworkspace`
   - ⚠️ **IMPORTANT**: Open `.xcworkspace` NOT `.xcodeproj`!
3. Xcode will open

### C. Select Your iPhone:
1. At the top of Xcode, you'll see a device dropdown
2. It might say "iPhone 15 Pro" or similar
3. Click it and select **"Monah's iPhone"** (your actual device name)

### D. Set Up Code Signing (First Time Only):
1. Click **"CrystalPopJourney"** in the left sidebar (blue icon)
2. Make sure **"CrystalPopJourney"** target is selected
3. Click **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** from dropdown
   - If no team: Click "Add Account..." and sign in with your Apple ID
6. A green checkmark will appear when ready

### E. Build and Run:
1. Click the **▶️ (Play)** button at top-left
2. Xcode will build the app (this takes 2-5 minutes first time)
3. App will install and launch on your iPhone!

### F. If You See an Error:
**"Untrusted Developer"** on iPhone:
1. On iPhone: Go to **Settings → General → VPN & Device Management**
2. Tap your Apple ID under **Developer App**
3. Tap **"Trust"**
4. Go back to Xcode and press ▶️ again

---

## 🎨 STEP 5: Create App Icons (5 minutes)

### A. Generate Icons:
1. Open **Terminal**
2. Check if you have Pillow installed:
```bash
python3 -c "import PIL" 2>&1 && echo "✓ Ready!" || echo "Installing..." && pip3 install Pillow
```
3. Run the icon generator:
```bash
cd /Users/monah/projects/CrystalPopJourney
python3 create_icons.py
```
4. Icons will be created in `AppIcons` folder

### B. Add Icons to Xcode:
1. In Xcode, click **Assets.xcassets** in left sidebar
2. Click **AppIcon**
3. Open **Finder** → Navigate to `AppIcons` folder
4. Drag each icon to its matching size slot in Xcode
   - **Icon-40.png** → 20pt @2x slot
   - **Icon-60.png** → 20pt @3x slot
   - **Icon-58.png** → 29pt @2x slot
   - **Icon-87.png** → 29pt @3x slot
   - **Icon-80.png** → 40pt @2x slot
   - **Icon-120.png** → 40pt @3x and 60pt @2x slots
   - **Icon-180.png** → 60pt @3x slot
   - **Icon-1024.png** → App Store slot

Or just drag all icons and Xcode will auto-place them!

---

## 📲 STEP 6: Test Everything!

On your iPhone, test these features:

1. **Main Menu**: ✓ Play, High Scores, Settings, Shop buttons
2. **Game Modes**: ✓ Classic, Timed, Arcade, Challenge
3. **High Scores**: ✓ View scores for each mode
4. **Settings**: ✓ Sound toggle, music toggle, reset progress
5. **Power-ups**: ✓ Play until you see floating power-ups
6. **Ads**: ✓ Game over shows ad, shop shows rewarded ad

---

## 🏪 STEP 7: Prepare for App Store (Before Publishing)

### A. Update App Information:
1. In Xcode, click **CrystalPopJourney** (blue icon) in sidebar
2. Under **"General"** tab, update:
   - **Display Name**: Crystal Pop Journey
   - **Bundle Identifier**: com.yourcompany.crystalpopjourney
   - **Version**: 1.0
   - **Build**: 1

### B. Create Screenshots:
1. While app runs on your iPhone, take 5-6 screenshots:
   - Main menu
   - Gameplay
   - High scores
   - Settings
   - Game modes selection
2. You'll upload these to App Store Connect

### C. Privacy Policy (Required!):
Create a simple privacy policy at: **https://app-privacy-policy-generator.firebaseapp.com/**
1. Answer the questions
2. Generate policy
3. Host it somewhere (your website, GitHub, Medium, etc.)
4. You'll need the URL for App Store

### D. App Store Connect:
1. Go to: **https://appstoreconnect.apple.com**
2. Click **"My Apps"** → **"+"** → **"New App"**
3. Fill in:
   - **Platform**: iOS
   - **Name**: Crystal Pop Journey
   - **Primary Language**: English
   - **Bundle ID**: Select the one from Xcode
   - **SKU**: CRYSTALPOP001
4. Click **"Create"**
5. Fill in all required information:
   - Description
   - Keywords
   - Screenshots
   - Privacy Policy URL
   - Support URL
   - Category: Games

### E. Submit for Review:
1. In Xcode: **Product** → **Archive**
2. Wait for archive to complete
3. Click **"Distribute App"**
4. Choose **"App Store Connect"**
5. Follow prompts to upload
6. In App Store Connect, click **"Submit for Review"**

---

## ❓ Troubleshooting

### "Build Failed" in Xcode:
- Press ⌘⇧K to clean
- Press ⌘B to build again

### "No Development Team":
- Xcode → Preferences → Accounts
- Add your Apple ID
- Select team in Signing & Capabilities

### "App Won't Install on iPhone":
- Check iPhone is unlocked
- Check USB cable is connected
- Try different USB port
- Restart iPhone

### "Ads Not Showing":
- Wait 30-60 seconds after app launch
- Check internet connection
- Check Xcode console for error messages
- Make sure you updated the Ad Unit IDs

### "Icons Not Showing":
- Make sure all icon sizes are added
- Clean build (⌘⇧K) and rebuild (⌘B)

---

## 📞 Need Help?

If you get stuck:
1. Check the error message in Xcode console (bottom panel)
2. Google the error message
3. Check Apple Developer Forums
4. Ask me for help!

---

## 🎉 You're Done!

Once you complete all steps:
- ✅ App runs on your iPhone
- ✅ Ads are working
- ✅ Icons look great
- ✅ Ready to test with real users
- ✅ Ready to submit to App Store!

**Good luck with your app! 🚀💰**
