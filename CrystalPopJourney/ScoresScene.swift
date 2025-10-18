import SpriteKit

class ScoresScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }

    private func setupBackground() {
        // Animated gradient background
        let gradient = SKShapeNode(rect: frame)
        gradient.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.35, alpha: 1.0)
        gradient.strokeColor = .clear
        addChild(gradient)

        // Floating particles
        createFloatingParticles()
    }

    private func createFloatingParticles() {
        for _ in 0..<20 {
            let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...4))
            particle.fillColor = UIColor.crystalGold.withAlphaComponent(0.3)
            particle.strokeColor = .clear
            particle.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            particle.zPosition = -1

            let floatAction = SKAction.sequence([
                SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: 20...40), duration: Double.random(in: 3...5)),
                SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: -40...(-20)), duration: Double.random(in: 3...5))
            ])
            particle.run(SKAction.repeatForever(floatAction))
            addChild(particle)
        }
    }

    private func setupUI() {
        // Title with glow effect
        let titleContainer = FontManager.shared.createLabelWithShadow(
            text: "🏆 High Scores",
            font: .title,
            color: .crystalGold,
            shadowColor: UIColor.orange,
            shadowOffset: CGPoint(x: 3, y: -3)
        )
        titleContainer.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        titleContainer.zPosition = 10
        addChild(titleContainer)

        // Scores panel
        let panelHeight: CGFloat = 520
        let panelY = frame.midY - panelHeight/2 + 20

        let panel = SKShapeNode(rect: CGRect(
            x: frame.midX - 180,
            y: panelY,
            width: 360,
            height: panelHeight
        ), cornerRadius: 25)
        panel.fillColor = UIColor.black.withAlphaComponent(0.7)
        panel.strokeColor = UIColor.crystalGold.withAlphaComponent(0.5)
        panel.lineWidth = 3
        panel.zPosition = 5
        addChild(panel)

        // Add decorative corners
        addCornerDecoration(panel)

        // Display scores for each mode
        let modes: [GameMode] = [.classic, .timed, .arcade, .challenge]
        let startY = panelY + panelHeight - 60

        for (index, mode) in modes.enumerated() {
            let yPosition = startY - CGFloat(index) * 110
            createScoreCard(mode: mode, yPosition: yPosition)
        }

        // Total stats section
        createTotalStats(yPosition: panelY + 30)

        // Back button
        let backButton = createBackButton()
        backButton.position = CGPoint(x: frame.midX, y: 80)
        backButton.name = "backButton"
        addChild(backButton)
    }

    private func addCornerDecoration(_ panel: SKShapeNode) {
        let cornerSize: CGFloat = 15

        // Top-left corner
        let topLeft = SKShapeNode(rect: CGRect(x: -5, y: -5, width: cornerSize, height: cornerSize))
        topLeft.fillColor = .crystalGold
        topLeft.strokeColor = .clear
        topLeft.position = CGPoint(x: panel.frame.minX, y: panel.frame.maxY)
        topLeft.zPosition = 6
        addChild(topLeft)

        // Top-right corner
        let topRight = SKShapeNode(rect: CGRect(x: -cornerSize + 5, y: -5, width: cornerSize, height: cornerSize))
        topRight.fillColor = .crystalGold
        topRight.strokeColor = .clear
        topRight.position = CGPoint(x: panel.frame.maxX, y: panel.frame.maxY)
        topRight.zPosition = 6
        addChild(topRight)

        // Bottom-left corner
        let bottomLeft = SKShapeNode(rect: CGRect(x: -5, y: -cornerSize + 5, width: cornerSize, height: cornerSize))
        bottomLeft.fillColor = .crystalGold
        bottomLeft.strokeColor = .clear
        bottomLeft.position = CGPoint(x: panel.frame.minX, y: panel.frame.minY)
        bottomLeft.zPosition = 6
        addChild(bottomLeft)

        // Bottom-right corner
        let bottomRight = SKShapeNode(rect: CGRect(x: -cornerSize + 5, y: -cornerSize + 5, width: cornerSize, height: cornerSize))
        bottomRight.fillColor = .crystalGold
        bottomRight.strokeColor = .clear
        bottomRight.position = CGPoint(x: panel.frame.maxX, y: panel.frame.minY)
        bottomRight.zPosition = 6
        addChild(bottomRight)
    }

    private func createScoreCard(mode: GameMode, yPosition: CGFloat) {
        // Card background
        let card = SKShapeNode(rect: CGRect(
            x: frame.midX - 160,
            y: yPosition - 35,
            width: 320,
            height: 70
        ), cornerRadius: 15)

        let cardColor: UIColor
        switch mode {
        case .classic: cardColor = UIColor.crystalPurple
        case .timed: cardColor = UIColor.crystalBlue
        case .arcade: cardColor = UIColor.crystalPink
        case .challenge: cardColor = UIColor.crystalGreen
        }

        card.fillColor = cardColor.withAlphaComponent(0.3)
        card.strokeColor = cardColor
        card.lineWidth = 2
        card.zPosition = 10
        addChild(card)

        // Mode icon and name
        let iconLabel = SKLabelNode(text: mode.icon)
        iconLabel.fontSize = 36
        iconLabel.position = CGPoint(x: frame.midX - 130, y: yPosition - 6)
        iconLabel.verticalAlignmentMode = .center
        iconLabel.zPosition = 11
        addChild(iconLabel)

        let nameLabel = FontManager.shared.createLabel(
            text: mode.displayName,
            font: .headline,
            color: .white
        )
        nameLabel.position = CGPoint(x: frame.midX - 70, y: yPosition + 8)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.zPosition = 11
        addChild(nameLabel)

        // Mode description
        let descLabel = FontManager.shared.createLabel(
            text: mode.description,
            font: .caption,
            color: UIColor.lightGray
        )
        descLabel.position = CGPoint(x: frame.midX - 70, y: yPosition - 12)
        descLabel.horizontalAlignmentMode = .left
        descLabel.zPosition = 11
        addChild(descLabel)

        // High score display
        let highScore = GameModeManager.shared.getHighScore(for: mode)
        let scoreText = highScore > 0 ? "\(highScore)" : "---"

        let scoreContainer = SKNode()
        scoreContainer.position = CGPoint(x: frame.midX + 110, y: yPosition)

        let scoreLabel = FontManager.shared.createLabel(
            text: scoreText,
            font: .score,
            color: .crystalGold
        )
        scoreLabel.fontSize = 28
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = 11
        scoreContainer.addChild(scoreLabel)

        // Add glow to score
        if highScore > 0 {
            let glow = SKShapeNode(circleOfRadius: 40)
            glow.fillColor = .clear
            glow.strokeColor = .crystalGold
            glow.lineWidth = 2
            glow.alpha = 0.3
            glow.zPosition = 10

            let pulse = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.1, duration: 1.0),
                SKAction.fadeAlpha(to: 0.3, duration: 1.0)
            ])
            glow.run(SKAction.repeatForever(pulse))
            scoreContainer.addChild(glow)
        }

        addChild(scoreContainer)

        // Rank badge for top scores
        if highScore > 1000 {
            let badge = createRankBadge(score: highScore)
            badge.position = CGPoint(x: frame.midX + 140, y: yPosition + 20)
            badge.zPosition = 12
            addChild(badge)
        }
    }

    private func createRankBadge(score: Int) -> SKNode {
        let container = SKNode()

        let badge = SKShapeNode(circleOfRadius: 12)
        let rank: String
        let color: UIColor

        if score > 10000 {
            rank = "S"
            color = .crystalGold
        } else if score > 5000 {
            rank = "A"
            color = .systemYellow
        } else if score > 2000 {
            rank = "B"
            color = .systemOrange
        } else {
            rank = "C"
            color = .systemGray
        }

        badge.fillColor = color
        badge.strokeColor = .white
        badge.lineWidth = 1
        container.addChild(badge)

        let rankLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        rankLabel.text = rank
        rankLabel.fontSize = 14
        rankLabel.fontColor = .white
        rankLabel.verticalAlignmentMode = .center
        container.addChild(rankLabel)

        return container
    }

    private func createTotalStats(yPosition: CGFloat) {
        let divider = SKShapeNode(rect: CGRect(
            x: frame.midX - 140,
            y: yPosition + 35,
            width: 280,
            height: 2
        ))
        divider.fillColor = UIColor.white.withAlphaComponent(0.3)
        divider.strokeColor = .clear
        divider.zPosition = 10
        addChild(divider)

        // Calculate total high score
        var totalScore = 0
        for mode in [GameMode.classic, .timed, .arcade, .challenge] {
            totalScore += GameModeManager.shared.getHighScore(for: mode)
        }

        let totalLabel = FontManager.shared.createLabel(
            text: "Total Score",
            font: .headline,
            color: UIColor.lightGray
        )
        totalLabel.position = CGPoint(x: frame.midX - 60, y: yPosition + 8)
        totalLabel.horizontalAlignmentMode = .left
        totalLabel.zPosition = 11
        addChild(totalLabel)

        let totalScoreLabel = FontManager.shared.createLabel(
            text: "\(totalScore)",
            font: .score,
            color: .crystalGold
        )
        totalScoreLabel.fontSize = 24
        totalScoreLabel.position = CGPoint(x: frame.midX + 110, y: yPosition + 8)
        totalScoreLabel.verticalAlignmentMode = .center
        totalScoreLabel.zPosition = 11
        addChild(totalScoreLabel)
    }

    private func createBackButton() -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -120, y: -30, width: 240, height: 60),
            cornerRadius: 30
        )
        button.fillColor = UIColor.crystalPurple
        button.strokeColor = .white
        button.lineWidth = 3
        button.zPosition = 10

        // Glow effect
        let glow = SKShapeNode(
            rect: CGRect(x: -120, y: -30, width: 240, height: 60),
            cornerRadius: 30
        )
        glow.fillColor = .clear
        glow.strokeColor = .crystalPurple
        glow.lineWidth = 6
        glow.alpha = 0.5
        glow.zPosition = -1

        let glowPulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.2, duration: 1.0),
            SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        ])
        glow.run(SKAction.repeatForever(glowPulse))
        button.addChild(glow)

        let label = FontManager.shared.createLabel(
            text: "← Back to Menu",
            font: .button,
            color: .white
        )
        label.verticalAlignmentMode = .center
        button.addChild(label)

        return button
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" || touchedNode.parent?.name == "backButton" {
            returnToMenu()
        }
    }

    private func returnToMenu() {
        SoundManager.shared.playSound(.buttonTap)
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
