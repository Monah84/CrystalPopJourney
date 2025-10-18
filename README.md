# 💎 Crystal Pop Journey

A beautiful match-3 puzzle game for iOS with multiple game modes, power-ups, and AdMob monetization.

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-iOS%2012%2B-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)

---

## ✨ Features

### 🎮 Game Modes
- **Classic**: Match crystals with limited moves
- **Timed**: Race against the clock (60 seconds)
- **Arcade**: Endless gameplay with increasing difficulty
- **Challenge**: Progressive levels with specific goals

### ⚡ Power-Ups
- **Extra Moves**: +5 moves to keep playing
- **Double Points**: Instantly doubles your score
- **Bomb Clear**: Clears random area on board
- **Time Extension**: +10 seconds (timed mode only)

### 🏆 Features
- High score tracking per game mode
- Beautiful animations and particle effects
- Premium AvenirNext fonts
- Sound effects with haptic feedback
- Congratulations animation for new high scores
- Settings screen with sound/music toggles
- Comprehensive high scores dashboard

### 💰 Monetization
- AdMob banner ads
- Interstitial ads (game over)
- Rewarded ads (shop bonuses)
- In-app purchases (remove ads, coin packs)

---

## 🚀 Quick Start

### For First-Time Setup:
1. **Read**: [`START_HERE.md`](START_HERE.md) - 5-step quick guide
2. **Or Read**: [`COMPLETE_SETUP_GUIDE.md`](COMPLETE_SETUP_GUIDE.md) - Detailed guide for beginners

### Already Set Up?
```bash
open CrystalPopJourney.xcworkspace
```

---

## 📋 What You Need to Do

### Before First Run:
1. ✅ Create AdMob Interstitial ad unit
2. ✅ Create AdMob Rewarded ad unit
3. ✅ Update ad IDs in `MonetizationManager.swift`
4. ✅ Run `./setup.sh` to install dependencies
5. ✅ Run `python3 create_icons.py` to generate icons

### Before App Store:
1. ✅ Test all features on device
2. ✅ Add app icons to Xcode
3. ✅ Create privacy policy
4. ✅ Take screenshots
5. ✅ Submit to App Store Connect

---

## 📁 Project Structure

```
CrystalPopJourney/
├── CrystalPopJourney.xcworkspace  ← Open this!
├── CrystalPopJourney/
│   ├── GameScene.swift            ← Main gameplay
│   ├── MenuScene.swift            ← Main menu
│   ├── SettingsScene.swift        ← Settings screen
│   ├── ScoresScene.swift          ← High scores dashboard
│   ├── GameBoard.swift            ← Game logic
│   ├── GameMode.swift             ← Game modes system
│   ├── PowerUp.swift              ← Power-ups system
│   ├── FontManager.swift          ← Typography system
│   ├── SoundManager.swift         ← Audio system
│   ├── MonetizationManager.swift  ← Ads & IAP
│   ├── LevelManager.swift         ← Level progression
│   └── Crystal.swift              ← Crystal objects
├── Podfile                        ← CocoaPods dependencies
├── setup.sh                       ← Setup script
├── create_icons.py                ← Icon generator
└── Documentation/
    ├── START_HERE.md              ← Quick start
    ├── COMPLETE_SETUP_GUIDE.md    ← Full guide
    ├── XCODE_GUIDE_FOR_BEGINNERS.md
    ├── COMPLETE_ADMOB_INTEGRATION.md
    └── PRODUCTION_READY_SUMMARY.md
```

---

## 🎨 Screenshots

(Take screenshots while testing and add them here)

---

## 🛠 Technologies Used

- **Language**: Swift 5.0
- **Framework**: SpriteKit
- **Ads**: Google Mobile Ads SDK
- **IAP**: StoreKit
- **Dependencies**: CocoaPods

---

## 📱 Requirements

- iOS 12.0+
- Xcode 12.0+
- CocoaPods
- Apple Developer Account (for App Store submission)
- AdMob Account

---

## 💰 AdMob Configuration

### Your Ad Unit IDs:
```
App ID: ca-app-pub-9779930258622875~1132662037
Banner: ca-app-pub-9779930258622875/1383943470
Interstitial: (Create in AdMob dashboard)
Rewarded: (Create in AdMob dashboard)
```

See [`COMPLETE_ADMOB_INTEGRATION.md`](COMPLETE_ADMOB_INTEGRATION.md) for setup instructions.

---

## 🎯 Testing

### On Simulator:
```bash
# In Xcode, select iPhone simulator
# Press ⌘R to run
```

### On Real Device:
```bash
# Connect iPhone via USB
# Select device in Xcode
# Press ⌘R to run
```

### What to Test:
- [ ] All 4 game modes work
- [ ] Power-ups appear and function
- [ ] High scores save correctly
- [ ] Settings persist
- [ ] Ads load and display
- [ ] Sounds play correctly
- [ ] No crashes

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [`START_HERE.md`](START_HERE.md) | Quick 5-step setup guide |
| [`COMPLETE_SETUP_GUIDE.md`](COMPLETE_SETUP_GUIDE.md) | Full beginner-friendly guide |
| [`XCODE_GUIDE_FOR_BEGINNERS.md`](XCODE_GUIDE_FOR_BEGINNERS.md) | How to use Xcode |
| [`COMPLETE_ADMOB_INTEGRATION.md`](COMPLETE_ADMOB_INTEGRATION.md) | AdMob setup |
| [`PRODUCTION_READY_SUMMARY.md`](PRODUCTION_READY_SUMMARY.md) | What's done & TODO |

---

## 🐛 Troubleshooting

### "Pod install" fails:
```bash
sudo gem install cocoapods
pod install
```

### "Module not found":
- Make sure you opened `.xcworkspace` not `.xcodeproj`

### Ads not showing:
- Check internet connection
- Wait 30-60 seconds
- Check Xcode console for errors
- Verify ad unit IDs are correct

### Build errors:
```bash
# Clean build
⌘⇧K

# Rebuild
⌘B
```

---

## 🚀 Deployment

### TestFlight (Beta Testing):
1. Archive app in Xcode
2. Upload to App Store Connect
3. Add testers in TestFlight
4. Get feedback

### App Store:
1. Complete app information in App Store Connect
2. Upload build
3. Submit for review
4. Wait 1-3 days for approval

See Step 7 in [`COMPLETE_SETUP_GUIDE.md`](COMPLETE_SETUP_GUIDE.md)

---

## 📄 License

This project is proprietary. All rights reserved.

---

## 👤 Author

**Monah**

---

## 🙏 Acknowledgments

- Apple Developer Documentation
- Google AdMob SDK
- SpriteKit Framework

---

## 📞 Support

Need help? Check the documentation files or open an issue.

---

**Ready to make your game go viral! 🚀**
