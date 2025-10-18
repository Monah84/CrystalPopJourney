import SpriteKit

class AboutDMDScene: SKScene {

    override func didMove(to view: SKView) {
        setupBackground()
        setupContent()
    }

    private func setupBackground() {
        let gradient = SKShapeNode(rect: frame)
        gradient.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0)
        gradient.strokeColor = .clear
        addChild(gradient)
    }

    private func setupContent() {
        // Title
        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "About DMD"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 80)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        // Heart emoji
        let heartLabel = SKLabelNode(text: "❤️")
        heartLabel.fontSize = 40
        heartLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 130)
        heartLabel.zPosition = 10
        addChild(heartLabel)

        // Content area - more concise text that fits above buttons
        let contentY = frame.maxY - 180
        let lineHeight: CGFloat = 28
        var currentY = contentY

        // What is DMD section
        let sections = [
            ("What is DMD?", 24, UIColor.yellow),
            ("Duchenne Muscular Dystrophy (DMD) is", 16, UIColor.white),
            ("a genetic disorder causing progressive", 16, UIColor.white),
            ("muscle weakness. It primarily affects boys", 16, UIColor.white),
            ("and appears in early childhood.", 16, UIColor.white),
            ("", 8, UIColor.clear),

            ("About Elevidys", 24, UIColor.yellow),
            ("Elevidys is a gene therapy treatment", 16, UIColor.white),
            ("that can help slow DMD progression,", 16, UIColor.white),
            ("offering hope for affected children.", 16, UIColor.white),
            ("", 8, UIColor.clear),

            ("Why This App?", 24, UIColor.yellow),
            ("This game raises awareness and support", 16, UIColor.white),
            ("for my son's DMD treatment. Every", 16, UIColor.white),
            ("donation brings us closer to accessing", 16, UIColor.white),
            ("Elevidys therapy.", 16, UIColor.white),
        ]

        for (text, fontSize, color) in sections {
            // Stop rendering text above button area (y=180)
            if currentY < 200 { break }

            let label = SKLabelNode(fontNamed: fontSize > 20 ? "Arial-Bold" : "Arial")
            label.text = text
            label.fontSize = CGFloat(fontSize)
            label.fontColor = color
            label.position = CGPoint(x: frame.midX, y: currentY)
            label.zPosition = 10
            label.preferredMaxLayoutWidth = frame.width - 60
            label.numberOfLines = 0
            label.verticalAlignmentMode = .top
            addChild(label)

            currentY -= (fontSize > 20) ? lineHeight * 1.3 : lineHeight
        }

        // Learn More button
        let learnMoreButton = createButton(
            text: "Learn More Online",
            position: CGPoint(x: frame.midX, y: 150)
        )
        learnMoreButton.name = "learnMoreButton"
        addChild(learnMoreButton)

        // Donate button
        let donateButton = createButton(
            text: "💝 Donate Now",
            position: CGPoint(x: frame.midX, y: 95)
        )
        donateButton.name = "donateButton"
        donateButton.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
        addChild(donateButton)

        // Back button
        let backButton = createButton(
            text: "Back to Menu",
            position: CGPoint(x: frame.midX, y: 40)
        )
        backButton.name = "backButton"
        addChild(backButton)
    }

    private func createButton(text: String, position: CGPoint) -> SKShapeNode {
        // Create shadow/background layer to block text behind
        let shadow = SKShapeNode(rect: CGRect(x: -145, y: -25, width: 290, height: 50), cornerRadius: 20)
        shadow.fillColor = UIColor.black.withAlphaComponent(0.7)
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: position.x + 2, y: position.y - 2)
        shadow.zPosition = 99
        addChild(shadow)

        // Create main button
        let button = SKShapeNode(rect: CGRect(x: -140, y: -20, width: 280, height: 40), cornerRadius: 20)
        button.fillColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        button.strokeColor = UIColor.white
        button.lineWidth = 2
        button.position = position
        button.zPosition = 100

        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = text
        label.fontSize = 18
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)

        return button
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        let nodeName = touchedNode.name ?? touchedNode.parent?.name ?? ""

        switch nodeName {
        case "backButton":
            SoundManager.shared.playSound(.buttonTap)
            returnToMenu()
        case "donateButton":
            SoundManager.shared.playSound(.buttonTap)
            showDonationOptions()
        case "learnMoreButton":
            SoundManager.shared.playSound(.buttonTap)
            showLearnMoreInfo()
        default:
            break
        }
    }

    private func returnToMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showDonationOptions() {
        // Navigate to settings where donations are handled
        let settingsScene = SettingsScene(size: size)
        settingsScene.scaleMode = scaleMode
        view?.presentScene(settingsScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showLearnMoreInfo() {
        // Show information about DMD resources
        let infoLabel = SKLabelNode(fontNamed: "Arial")
        infoLabel.text = "Visit your web browser to learn more about"
        infoLabel.fontSize = 16
        infoLabel.fontColor = .white
        infoLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        infoLabel.zPosition = 150
        infoLabel.alpha = 0

        let infoLabel2 = SKLabelNode(fontNamed: "Arial-Bold")
        infoLabel2.text = "Duchenne Muscular Dystrophy and Elevidys"
        infoLabel2.fontSize = 16
        infoLabel2.fontColor = .yellow
        infoLabel2.position = CGPoint(x: frame.midX, y: frame.midY - 25)
        infoLabel2.zPosition = 150
        infoLabel2.alpha = 0

        addChild(infoLabel)
        addChild(infoLabel2)

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 3.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        infoLabel.run(sequence)
        infoLabel2.run(sequence)
    }
}
