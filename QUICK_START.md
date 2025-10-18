# 🚀 Quick Start - AdMob Integration

## Your AdMob IDs

```
✅ App ID: ca-app-pub-9779930258622875~1132662037
✅ Banner Ad: ca-app-pub-9779930258622875/1383943470
❌ Interstitial: CREATE IN ADMOB (Step 2 below)
❌ Rewarded: CREATE IN ADMOB (Step 2 below)
```

## 3 Steps to Complete Setup

### Step 1: Install CocoaPods (2 minutes)

Open Terminal and run:
```bash
cd /Users/monah/projects/CrystalPopJourney
pod install
```

### Step 2: Create Missing Ad Units (5 minutes)

1. Go to: https://admob.google.com
2. Click your app: "Crystal Pop Journey"
3. Click "Ad Units" → "Add Ad Unit"
4. Create **Interstitial** ad unit → Copy the ID
5. Create **Rewarded** ad unit → Copy the ID

### Step 3: Update Code (2 minutes)

Open `MonetizationManager.swift` and replace (lines 20-22):
```swift
private let interstitialAdUnitID = "YOUR_INTERSTITIAL_ID_HERE"
private let rewardedAdUnitID = "YOUR_REWARDED_ID_HERE"
```

## ✅ Then Build!

1. Close `.xcodeproj` if open
2. Open `CrystalPopJourney.xcworkspace`
3. Press ⌘R to run

## 📝 Testing

- Test ads will show automatically
- Check Xcode console for ad loading messages
- Interstitial ad shows on game over
- Rewarded ad shows in shop

## Need Help?

See: `COMPLETE_ADMOB_INTEGRATION.md` for detailed guide

---

**That's it! You're ready to monetize! 💰**
