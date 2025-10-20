import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private var bannerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill

            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false

            // Add banner ad at the bottom
            setupBannerAd()
        }
    }

    private func setupBannerAd() {
        // Create banner ad
        bannerView = MonetizationManager.shared.createBannerView(in: self)

        guard let bannerView = bannerView else { return }

        // Position banner at the bottom of the screen
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)

        // Constrain banner to bottom of screen
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])

        print("✅ Banner ad added to view")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}