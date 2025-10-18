# Google AdMob Registration & Setup Guide

## Step 1: Register for Google AdMob

### 1.1 Create an AdMob Account
1. Go to [https://admob.google.com](https://admob.google.com)
2. Click **"Get Started"** or **"Sign In"**
3. Sign in with your Google account (or create one if you don't have one)
4. Accept the AdMob Terms of Service
5. Select your country/region and timezone

### 1.2 Complete Your Profile
1. Enter your business information:
   - **Name**: Your name or business name
   - **Country**: Your location
   - **Currency**: Your preferred currency for payments
2. Review and accept the AdMob program policies

## Step 2: Add Your iOS App to AdMob

### 2.1 Register Your App
1. In the AdMob dashboard, click **"Apps"** in the left sidebar
2. Click **"Add App"**
3. Select **"iOS"** as the platform
4. Choose:
   - **"No"** if your app is not published on the App Store yet
   - **"Yes"** if it's already published, then search for it
5. Enter your app details:
   - **App name**: Crystal Pop Journey
   - **Bundle ID**: `com.yourcompany.crystalpopjourney` (should match your Xcode project)
6. Click **"Add App"**

### 2.2 Get Your App ID
After adding your app, you'll receive an **App ID** that looks like:
```
ca-app-pub-1234567890123456~0987654321
```
**IMPORTANT**: Save this App ID! You'll need it later.

## Step 3: Create Ad Units

You need to create ad units for different ad types:

### 3.1 Create Banner Ad Unit
1. In your app's page, click **"Ad Units"** tab
2. Click **"Get Started"** or **"Add Ad Unit"**
3. Select **"Banner"**
4. Enter ad unit name: "Crystal Pop Banner"
5. Click **"Create Ad Unit"**
6. **Save the Ad Unit ID** (looks like: `ca-app-pub-1234567890123456/1234567890`)

### 3.2 Create Interstitial Ad Unit
1. Click **"Add Ad Unit"** again
2. Select **"Interstitial"**
3. Enter ad unit name: "Crystal Pop Interstitial"
4. Click **"Create Ad Unit"**
5. **Save the Ad Unit ID**

### 3.3 Create Rewarded Ad Unit
1. Click **"Add Ad Unit"** again
2. Select **"Rewarded"**
3. Enter ad unit name: "Crystal Pop Rewarded"
4. Click **"Create Ad Unit"**
5. **Save the Ad Unit ID**

## Step 4: Install Google Mobile Ads SDK

### 4.1 Add SDK via CocoaPods

1. **Install CocoaPods** (if not already installed):
   ```bash
   sudo gem install cocoapods
   ```

2. **Create a Podfile** in your project directory:
   ```bash
   cd /Users/monah/projects/CrystalPopJourney
   pod init
   ```

3. **Edit the Podfile**:
   ```ruby
   # Uncomment the next line to define a global platform for your project
   platform :ios, '12.0'

   target 'CrystalPopJourney' do
     # Comment the next line if you don't want to use dynamic frameworks
     use_frameworks!

     # Google Mobile Ads SDK
     pod 'Google-Mobile-Ads-SDK'

   end
   ```

4. **Install the pods**:
   ```bash
   pod install
   ```

5. **From now on, use the `.xcworkspace` file instead of `.xcodeproj`**:
   ```bash
   open CrystalPopJourney.xcworkspace
   ```

### 4.2 Update Info.plist

1. Open `Info.plist` in Xcode
2. Add a new row with:
   - **Key**: `GADApplicationIdentifier`
   - **Type**: String
   - **Value**: Your App ID from Step 2.2 (e.g., `ca-app-pub-1234567890123456~0987654321`)

3. Add App Transport Security settings (required for ads):
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
       <key>NSAllowsArbitraryLoadsForMedia</key>
       <true/>
       <key>NSAllowsArbitraryLoadsInWebContent</key>
       <true/>
   </dict>
   ```

## Step 5: Update MonetizationManager.swift

Once you have your Ad Unit IDs, update the `MonetizationManager.swift` file:

```swift
import GoogleMobileAds

class MonetizationManager {
    static let shared = MonetizationManager()

    // REPLACE THESE WITH YOUR ACTUAL AD UNIT IDs
    private let bannerAdUnitID = "ca-app-pub-1234567890123456/1234567890"  // Your Banner Ad Unit ID
    private let interstitialAdUnitID = "ca-app-pub-1234567890123456/0987654321"  // Your Interstitial Ad Unit ID
    private let rewardedAdUnitID = "ca-app-pub-1234567890123456/1122334455"  // Your Rewarded Ad Unit ID

    private var interstitialAd: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?

    private init() {
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    // Implement your ad loading and showing logic here
}
```

## Step 6: Testing Your Ads

### 6.1 Use Test Ad Units During Development

**IMPORTANT**: Never use real ad units during development! Use these test IDs:

```swift
// Test Ad Unit IDs (use during development)
private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"  // Test Banner
private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"  // Test Interstitial
private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"  // Test Rewarded
```

### 6.2 Enable Test Devices

In your AppDelegate or initial view controller:

```swift
import GoogleMobileAds

// In application(_:didFinishLaunchingWithOptions:)
GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["YOUR_DEVICE_ID"]
```

To find your device ID, check Xcode console for a message like:
```
To get test ads on this device, set: GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = @[ @"33BE2250B43518CCDA68C967D73AD***" ];
```

## Step 7: Payment Information

### 7.1 Set Up Payment
1. In AdMob dashboard, go to **"Payments"**
2. Click **"How you'll get paid"**
3. Enter:
   - Name and address
   - Tax information (W-9 for US, tax forms for other countries)
   - Payment method (bank account or wire transfer)

### 7.2 Payment Threshold
- AdMob pays when you reach **$100 USD** (or equivalent)
- Payments are made monthly (around the 21st)
- First payment may take 1-2 months after reaching threshold

## Step 8: App Review & Privacy

### 8.1 Privacy Policy
You **MUST** have a privacy policy that mentions:
- Data collection by AdMob
- Use of advertising identifiers
- Third-party ad networks

### 8.2 App Store Submission
When submitting to App Store, you must:
1. Include privacy policy URL
2. Declare ad tracking usage
3. Add `NSUserTrackingUsageDescription` to Info.plist:
   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>This app uses your data to show personalized ads and improve your experience.</string>
   ```

## Step 9: Monitor Performance

### 9.1 AdMob Dashboard
- Check daily revenue
- View ad performance metrics
- Monitor fill rates
- Analyze user engagement

### 9.2 Optimize Ad Placement
- Don't show ads too frequently (users will get annoyed)
- Show rewarded ads for valuable in-game rewards
- Place banners in non-intrusive locations
- Show interstitials at natural break points (game over, level complete)

## Important Notes & Best Practices

### ✅ DO:
- Use test ads during development
- Follow AdMob policies strictly
- Provide value in exchange for rewarded ads
- Monitor ad performance regularly
- Keep ads non-intrusive
- Include proper privacy disclosures

### ❌ DON'T:
- Click your own ads (instant ban!)
- Ask users to click ads
- Show ads too frequently
- Place ads in misleading locations
- Violate user privacy
- Use real ad units in development

## Support & Resources

- **AdMob Help Center**: https://support.google.com/admob
- **iOS SDK Documentation**: https://developers.google.com/admob/ios
- **Policy Center**: https://support.google.com/admob/answer/6128543
- **Community Forum**: https://groups.google.com/forum/#!forum/google-admob-ads-sdk

## Quick Reference: Your IDs

Keep these in a safe place:

```
App ID: ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY
Banner Ad Unit: ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ
Interstitial Ad Unit: ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA
Rewarded Ad Unit: ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB
```

---

**Need Help?** If you encounter issues:
1. Check AdMob Help Center
2. Review SDK documentation
3. Check Xcode console for error messages
4. Verify all IDs are correct
5. Ensure Info.plist is configured properly

Good luck with your app monetization! 🚀
