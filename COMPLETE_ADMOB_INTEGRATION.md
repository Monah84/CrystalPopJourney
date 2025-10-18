# Complete AdMob Integration Guide

## ✅ What's Already Done

I've completed these steps for you:

1. ✅ Created `Podfile` with Google Mobile Ads SDK
2. ✅ Updated `Info.plist` with your App ID: `ca-app-pub-9779930258622875~1132662037`
3. ✅ Added user tracking permission
4. ✅ Added App Transport Security settings
5. ✅ Updated `MonetizationManager.swift` with real Google Ads implementation
6. ✅ Added your Banner Ad Unit ID: `ca-app-pub-9779930258622875/1383943470`

## 🔧 Step 1: Install CocoaPods Dependencies

Open Terminal and run:

```bash
cd /Users/monah/projects/CrystalPopJourney
pod install
```

**If you get an error**, run:
```bash
sudo gem install cocoapods
cd /Users/monah/projects/CrystalPopJourney
pod install
```

After installation, you'll see a message saying to use the `.xcworkspace` file from now on.

## 📱 Step 2: Create Missing Ad Units in AdMob

You need to create **Interstitial** and **Rewarded** ad units:

### Create Interstitial Ad Unit:
1. Go to [https://admob.google.com](https://admob.google.com)
2. Click on your app: **"Crystal Pop Journey"**
3. Click **"Ad Units"** tab
4. Click **"Add Ad Unit"**
5. Select **"Interstitial"**
6. Name it: **"Crystal Pop Interstitial"**
7. Click **"Create Ad Unit"**
8. **Copy the Ad Unit ID** (looks like: `ca-app-pub-9779930258622875/XXXXXXXXXX`)

### Create Rewarded Ad Unit:
1. Click **"Add Ad Unit"** again
2. Select **"Rewarded"**
3. Name it: **"Crystal Pop Rewarded"**
4. Click **"Create Ad Unit"**
5. **Copy the Ad Unit ID**

## 📝 Step 3: Update Ad Unit IDs

Once you have your Interstitial and Rewarded Ad Unit IDs, update `MonetizationManager.swift`:

Find these lines (around line 20-22):
```swift
// TEST IDs - Use during development
private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"  // Test Interstitial
private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"  // Test Rewarded
```

Replace with your real IDs:
```swift
// PRODUCTION IDs - Your actual AdMob IDs
private let interstitialAdUnitID = "ca-app-pub-9779930258622875/YOUR_INTERSTITIAL_ID"
private let rewardedAdUnitID = "ca-app-pub-9779930258622875/YOUR_REWARDED_ID"
```

## 🚀 Step 4: Build and Run

1. **Close the .xcodeproj if it's open**
2. **Open**: `/Users/monah/projects/CrystalPopJourney/CrystalPopJourney.xcworkspace`
3. Select your device or simulator
4. Press ⌘R to build and run

## 🧪 Testing Your Ads

### During Development (Using Test Ads):
- Test ads will show immediately
- You can click them without worry
- No risk of policy violations

### Before Publishing (Using Real Ads):
1. Replace test IDs with real IDs
2. Test on a physical device
3. **DO NOT click your own ads** (this will get you banned!)

## 📊 Where Ads Appear

Your ads are already integrated in:

1. **Banner Ads**: Can be added to any view controller
   ```swift
   let bannerView = MonetizationManager.shared.createBannerView(in: self)
   view.addSubview(bannerView)
   ```

2. **Interstitial Ads**: Shows on game over
   - File: `GameScene.swift` line 362
   - Automatically triggered when game ends

3. **Rewarded Ads**: Shows in shop for bonus coins
   - File: `MenuScene.swift` line 367
   - User watches ad to get 50 coins

## 🔍 Troubleshooting

### Problem: "pod: command not found"
**Solution:**
```bash
sudo gem install cocoapods
```

### Problem: Ads not showing
**Check:**
1. Are you using test IDs during development?
2. Is your internet connection working?
3. Check Xcode console for error messages
4. Wait 30-60 seconds for first ad to load

### Problem: Build errors after pod install
**Solution:**
1. Clean build folder: ⌘⇧K
2. Close Xcode
3. Delete `DerivedData`:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen `.xcworkspace`
5. Build again

### Problem: "GoogleMobileAds module not found"
**Solution:**
- Make sure you're opening `.xcworkspace` NOT `.xcodeproj`
- Run `pod install` again
- Clean and rebuild

## 📈 Monitoring Your Earnings

1. Go to [https://admob.google.com](https://admob.google.com)
2. Click **"Dashboard"**
3. View:
   - **Estimated earnings**
   - **Ad requests**
   - **Match rate**
   - **Click-through rate (CTR)**
   - **eCPM** (earnings per thousand impressions)

## 💰 Getting Paid

### Requirements:
- Minimum $100 USD to receive payment
- Valid tax information submitted
- Payment method set up (bank account)

### Payment Schedule:
- Payments issued monthly (around 21st)
- For earnings in previous month
- First payment may take 1-2 months after threshold

## ⚠️ Important Policies

### DO:
- Follow AdMob policies
- Show ads naturally in gameplay
- Provide value for rewarded ads
- Keep user experience smooth
- Monitor ad performance

### DON'T:
- Click your own ads (INSTANT BAN)
- Ask users to click ads
- Show ads too frequently
- Hide close buttons
- Place ads over gameplay

## 🎯 Next Steps

1. [ ] Install CocoaPods dependencies
2. [ ] Create Interstitial ad unit in AdMob
3. [ ] Create Rewarded ad unit in AdMob
4. [ ] Update ad unit IDs in code
5. [ ] Open .xcworkspace file
6. [ ] Build and test
7. [ ] Monitor ad performance
8. [ ] Submit to App Store

## 📞 Support

If you need help:
- **AdMob Support**: https://support.google.com/admob
- **SDK Documentation**: https://developers.google.com/admob/ios
- **Community**: https://groups.google.com/g/google-admob-ads-sdk

---

## Quick Command Reference

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install dependencies
cd /Users/monah/projects/CrystalPopJourney
pod install

# Open workspace
open CrystalPopJourney.xcworkspace

# Clean build
rm -rf ~/Library/Developer/Xcode/DerivedData
```

Good luck! 🚀💰
