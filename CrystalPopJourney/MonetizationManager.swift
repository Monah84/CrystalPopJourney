import StoreKit
import UIKit
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

class MonetizationManager: NSObject {
    static let shared = MonetizationManager()

    // MARK: - AdMob Ad Unit IDs
    // PRODUCTION IDs - Your actual AdMob IDs
    private let bannerAdUnitID = "ca-app-pub-9779930258622875/1383943470"

    // TODO: Create these ad units in AdMob dashboard:
    // 1. Go to https://admob.google.com
    // 2. Select your app "Crystal Pop Journey"
    // 3. Click "Ad Units" → "Add Ad Unit"
    // 4. Create "Interstitial" ad unit (for game over screen)
    // 5. Create "Rewarded" ad unit (for bonus rewards)
    // 6. Replace the test IDs below with your real IDs

    // TEST IDs - Use during development
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"  // Test Interstitial
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"  // Test Rewarded

    // MARK: - In-App Purchase IDs
    private let removeAdsProductID = "com.monah.CrystalPopJourney.removeads"
    private let donate3ID = "com.monah.CrystalPopJourney.donate3"
    private let donate5ID = "com.monah.CrystalPopJourney.donate5"
    private let donate10ID = "com.monah.CrystalPopJourney.donate10"
    private let donate15ID = "com.monah.CrystalPopJourney.donate15"
    private let donate20ID = "com.monah.CrystalPopJourney.donate20"
    private let donate25ID = "com.monah.CrystalPopJourney.donate25"
    private let donate50ID = "com.monah.CrystalPopJourney.donate50"
    private let donate75ID = "com.monah.CrystalPopJourney.donate75"
    private let donate100ID = "com.monah.CrystalPopJourney.donate100"
    private let donate200ID = "com.monah.CrystalPopJourney.donate200"

    private var products: [SKProduct] = []
    private var purchaseCompletion: ((Bool) -> Void)?
    private var adCompletion: ((Bool) -> Void)?

    #if canImport(GoogleMobileAds)
    private var interstitialAd: GoogleMobileAds.InterstitialAd?
    private var rewardedAd: GoogleMobileAds.RewardedAd?
    #endif

    private var adsRemoved: Bool {
        get { UserDefaults.standard.bool(forKey: "AdsRemoved") }
        set { UserDefaults.standard.set(newValue, forKey: "AdsRemoved") }
    }

    private var coins: Int {
        get { UserDefaults.standard.integer(forKey: "PlayerCoins") }
        set { UserDefaults.standard.set(newValue, forKey: "PlayerCoins") }
    }

    private var gamesPlayed: Int {
        get { UserDefaults.standard.integer(forKey: "GamesPlayed") }
        set { UserDefaults.standard.set(newValue, forKey: "GamesPlayed") }
    }

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadProducts()

        #if canImport(GoogleMobileAds)
        GoogleMobileAds.MobileAds.shared.start(completionHandler: nil)
        loadInterstitialAd()
        loadRewardedAd()
        print("✅ MonetizationManager: Google Ads SDK enabled")
        #else
        print("⚠️ MonetizationManager: Google Ads SDK not available. Run 'pod install' to enable ads.")
        #endif
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    private func loadProducts() {
        let productIdentifiers: Set<String> = [
            removeAdsProductID,
            donate3ID,
            donate5ID,
            donate10ID,
            donate15ID,
            donate20ID,
            donate25ID,
            donate50ID,
            donate75ID,
            donate100ID,
            donate200ID
        ]

        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func purchaseRemoveAds(completion: @escaping (Bool) -> Void) {
        guard !adsRemoved else {
            completion(true)
            return
        }

        guard let product = products.first(where: { $0.productIdentifier == removeAdsProductID }) else {
            completion(false)
            return
        }

        purchaseCompletion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func purchaseCoins(_ amount: Int, completion: @escaping (Bool) -> Void) {
        let productID: String
        switch amount {
        case 3: productID = donate3ID
        case 5: productID = donate5ID
        case 10: productID = donate10ID
        case 15: productID = donate15ID
        case 20: productID = donate20ID
        case 25: productID = donate25ID
        case 50: productID = donate50ID
        case 75: productID = donate75ID
        case 100: productID = donate100ID
        case 200: productID = donate200ID
        default:
            print("⚠️ Unsupported donation amount: $\(amount)")
            completion(false)
            return
        }

        guard let product = products.first(where: { $0.productIdentifier == productID }) else {
            print("⚠️ Product not found for $\(amount) donation")
            completion(false)
            return
        }

        purchaseCompletion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // MARK: - Banner Ads
    func createBannerView(in viewController: UIViewController) -> UIView {
        #if canImport(GoogleMobileAds)
        guard !adsRemoved else {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            return placeholder
        }

        let bannerView = GoogleMobileAds.BannerView(adSize: GoogleMobileAds.AdSizeBanner)
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = viewController
        bannerView.load(GoogleMobileAds.Request())
        return bannerView
        #else
        print("⚠️ Banner ads disabled. Run 'pod install' to enable Google Ads.")
        let placeholder = UIView()
        placeholder.backgroundColor = .clear
        return placeholder
        #endif
    }

    // MARK: - Interstitial Ads
    #if canImport(GoogleMobileAds)
    private func loadInterstitialAd() {
        guard !adsRemoved else { return }

        let request = GoogleMobileAds.Request()
        GoogleMobileAds.InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    #endif

    func showInterstitialAd() {
        #if canImport(GoogleMobileAds)
        guard !adsRemoved else { return }

        // Increment game counter
        gamesPlayed += 1

        // Show ad every 2 games for better monetization
        guard gamesPlayed % 2 == 0 else {
            print("📊 Games played: \(gamesPlayed) - waiting for next ad interval")
            return
        }

        guard let interstitialAd = interstitialAd else {
            print("Interstitial ad not ready, loading...")
            loadInterstitialAd()
            return
        }

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            print("📺 Showing interstitial ad after \(gamesPlayed) games")
            interstitialAd.present(from: rootViewController)
        }
        #else
        print("⚠️ Interstitial ads disabled. Run 'pod install' to enable Google Ads.")
        #endif
    }

    func resetGameCounter() {
        gamesPlayed = 0
        print("📊 Game counter reset")
    }

    // MARK: - Rewarded Ads
    #if canImport(GoogleMobileAds)
    private func loadRewardedAd() {
        guard !adsRemoved else { return }

        let request = GoogleMobileAds.Request()
        GoogleMobileAds.RewardedAd.load(with: rewardedAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    #endif

    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        #if canImport(GoogleMobileAds)
        guard let rewardedAd = rewardedAd else {
            print("Rewarded ad not ready")
            loadRewardedAd()
            completion(false)
            return
        }

        adCompletion = completion

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rewardedAd.present(from: rootViewController, userDidEarnRewardHandler: { [weak self] in
                let reward = rewardedAd.adReward
                print("User earned reward: \(reward.amount) \(reward.type)")
                self?.awardCoins(50)
                self?.adCompletion?(true)
                self?.adCompletion = nil
            })
        }
        #else
        print("⚠️ Rewarded ads disabled. Run 'pod install' to enable Google Ads.")
        // For testing purposes, award the reward anyway
        awardCoins(50)
        completion(true)
        #endif
    }

    func awardCoins(_ amount: Int) {
        coins += amount
        NotificationCenter.default.post(name: NSNotification.Name("CoinsUpdated"), object: nil)
    }

    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        NotificationCenter.default.post(name: NSNotification.Name("CoinsUpdated"), object: nil)
        return true
    }

    func getCoins() -> Int {
        return coins
    }

    func areAdsRemoved() -> Bool {
        return adsRemoved
    }

    func toggleAdsRemoved() {
        adsRemoved = !adsRemoved
        print("✅ Ads \(adsRemoved ? "disabled" : "enabled")")

        // Reload ads if re-enabled
        if !adsRemoved {
            #if canImport(GoogleMobileAds)
            loadInterstitialAd()
            loadRewardedAd()
            #endif
        }
    }

    func setAdsRemoved(_ removed: Bool) {
        adsRemoved = removed
        print("✅ Ads \(adsRemoved ? "disabled" : "enabled")")

        // Reload ads if enabled
        if !adsRemoved {
            #if canImport(GoogleMobileAds)
            loadInterstitialAd()
            loadRewardedAd()
            #endif
        }
    }

    func restorePurchases(completion: @escaping (Bool) -> Void) {
        purchaseCompletion = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case removeAdsProductID:
            adsRemoved = true
            purchaseCompletion?(true)

        case donate3ID, donate5ID, donate10ID, donate15ID, donate20ID,
             donate25ID, donate50ID, donate75ID, donate100ID, donate200ID:
            // Donation complete - thank you!
            print("✅ Donation received! Thank you for helping my son fight DMD!")
            purchaseCompletion?(true)

        default:
            print("⚠️ Unknown product: \(transaction.payment.productIdentifier)")
            purchaseCompletion?(false)
        }

        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion = nil
    }

    private func failTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion?(false)
        purchaseCompletion = nil
    }
}

extension MonetizationManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products

        for product in products {
            print("Product: \(product.localizedTitle) - \(product.priceLocale.currencySymbol ?? "")\(product.price)")
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Products request failed: \(error.localizedDescription)")
    }
}

extension MonetizationManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .failed:
                failTransaction(transaction)
            case .restored:
                completeTransaction(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseCompletion?(true)
        purchaseCompletion = nil
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        purchaseCompletion?(false)
        purchaseCompletion = nil
    }
}

#if canImport(GoogleMobileAds)
extension MonetizationManager: GoogleMobileAds.FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: any GoogleMobileAds.FullScreenPresentingAd) {
        if ad is GoogleMobileAds.InterstitialAd {
            loadInterstitialAd()
        } else if ad is GoogleMobileAds.RewardedAd {
            loadRewardedAd()
        }
    }

    func ad(_ ad: any GoogleMobileAds.FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present: \(error.localizedDescription)")
        if ad is GoogleMobileAds.InterstitialAd {
            loadInterstitialAd()
        } else if ad is GoogleMobileAds.RewardedAd {
            loadRewardedAd()
            adCompletion?(false)
            adCompletion = nil
        }
    }
}
#endif
