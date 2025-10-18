import UIKit
import SpriteKit

class FontManager {
    static let shared = FontManager()

    private init() {}

    // MARK: - Font Names
    enum Font {
        case title
        case subtitle
        case headline
        case body
        case caption
        case score
        case button

        var name: String {
            switch self {
            case .title:
                return "AvenirNext-Heavy"
            case .subtitle:
                return "AvenirNext-DemiBold"
            case .headline:
                return "AvenirNext-Bold"
            case .body:
                return "AvenirNext-Regular"
            case .caption:
                return "AvenirNext-Medium"
            case .score:
                return "AvenirNext-Heavy"
            case .button:
                return "AvenirNext-DemiBold"
            }
        }

        var size: CGFloat {
            switch self {
            case .title:
                return 64
            case .subtitle:
                return 28
            case .headline:
                return 24
            case .body:
                return 18
            case .caption:
                return 14
            case .score:
                return 36
            case .button:
                return 22
            }
        }
    }

    // MARK: - Create Labels
    func createLabel(text: String, font: Font, color: UIColor = .white) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: font.name)
        label.text = text
        label.fontSize = font.size
        label.fontColor = color
        return label
    }

    func createLabelWithShadow(text: String, font: Font, color: UIColor = .white, shadowColor: UIColor = .black, shadowOffset: CGPoint = CGPoint(x: 2, y: -2)) -> SKNode {
        let container = SKNode()

        // Shadow
        let shadow = SKLabelNode(fontNamed: font.name)
        shadow.text = text
        shadow.fontSize = font.size
        shadow.fontColor = shadowColor
        shadow.alpha = 0.5
        shadow.position = shadowOffset
        shadow.zPosition = -1
        container.addChild(shadow)

        // Main label
        let label = SKLabelNode(fontNamed: font.name)
        label.text = text
        label.fontSize = font.size
        label.fontColor = color
        container.addChild(label)

        return container
    }

    func createGradientLabel(text: String, font: Font, topColor: UIColor, bottomColor: UIColor) -> SKNode {
        let container = SKNode()

        let label = SKLabelNode(fontNamed: font.name)
        label.text = text
        label.fontSize = font.size
        label.fontColor = topColor

        // Add glow effect
        let glow = SKLabelNode(fontNamed: font.name)
        glow.text = text
        glow.fontSize = font.size
        glow.fontColor = bottomColor
        glow.alpha = 0.6
        glow.zPosition = -1

        container.addChild(glow)
        container.addChild(label)

        // Pulsing animation for emphasis
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 1.0),
            SKAction.scale(to: 1.0, duration: 1.0)
        ])
        container.run(SKAction.repeatForever(pulse))

        return container
    }
}

// MARK: - UI Colors Extension
extension UIColor {
    static let crystalPurple = UIColor(red: 0.51, green: 0.27, blue: 0.85, alpha: 1.0)
    static let crystalBlue = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)
    static let crystalGold = UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.0)
    static let crystalPink = UIColor(red: 1.00, green: 0.41, blue: 0.71, alpha: 1.0)
    static let crystalGreen = UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.0)
}
