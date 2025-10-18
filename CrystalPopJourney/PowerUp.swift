import SpriteKit

class PowerUp: SKNode {
    enum PowerUpType {
        case extraMoves
        case bombClear
        case doublePoints
        case timeExtension

        var displayText: String {
            switch self {
            case .extraMoves: return "+5"
            case .bombClear: return "💣"
            case .doublePoints: return "×2"
            case .timeExtension: return "⏰"
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .extraMoves: return .systemGreen
            case .bombClear: return .systemRed
            case .doublePoints: return .systemPurple
            case .timeExtension: return .systemBlue
            }
        }

        var description: String {
            switch self {
            case .extraMoves: return "+5 Moves"
            case .bombClear: return "Clear Area"
            case .doublePoints: return "2× Points"
            case .timeExtension: return "+10 Seconds"
            }
        }
    }

    let type: PowerUpType
    var row: Int = 0
    var column: Int = 0

    init(type: PowerUpType) {
        self.type = type
        super.init()
        setupAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        // Create power-up background
        let background = SKShapeNode(circleOfRadius: 25)
        background.fillColor = type.backgroundColor
        background.strokeColor = .white
        background.lineWidth = 3
        background.glowWidth = 5
        addChild(background)

        // Add icon/text
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = type.displayText
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        addChild(label)

        // Add pulsing animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        run(SKAction.repeatForever(pulse))

        // Add glow effect
        let glow = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.7, duration: 0.5),
            SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        ])
        background.run(SKAction.repeatForever(glow))
    }

    func animateCollection(completion: @escaping () -> Void) {
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleUp, fadeOut])

        run(group) {
            self.removeFromParent()
            completion()
        }
    }
}
