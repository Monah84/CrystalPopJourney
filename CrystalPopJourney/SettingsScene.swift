import SpriteKit

class SettingsScene: SKScene {
    private var soundToggle: SKShapeNode!
    private var musicToggle: SKShapeNode!
    private var adsToggle: SKShapeNode!
    private var soundEnabled = true
    private var musicEnabled = true
    private var adsRemoved = false

    override func didMove(to view: SKView) {
        adsRemoved = MonetizationManager.shared.areAdsRemoved()
        setupBackground()
        setupUI()
    }

    private func setupBackground() {
        let gradient = SKShapeNode(rect: frame)
        gradient.fillColor = UIColor.crystalPurple
        gradient.strokeColor = .clear
        addChild(gradient)

        createStarField()
    }

    private func createStarField() {
        for _ in 0..<40 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...3))
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            star.alpha = CGFloat.random(in: 0.2...0.8)
            star.zPosition = -1

            let twinkle = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.2, duration: Double.random(in: 1.5...3.0)),
                SKAction.fadeAlpha(to: 0.8, duration: Double.random(in: 1.5...3.0))
            ])
            star.run(SKAction.repeatForever(twinkle))
            addChild(star)
        }
    }

    private func setupUI() {
        // Title
        let titleContainer = FontManager.shared.createLabelWithShadow(
            text: "Settings",
            font: .title,
            color: .white,
            shadowColor: .crystalPurple,
            shadowOffset: CGPoint(x: 3, y: -3)
        )
        titleContainer.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        titleContainer.zPosition = 10
        addChild(titleContainer)

        var yPos: CGFloat = frame.maxY - 130

        // Sound Section
        createSettingRow(
            icon: "🔊",
            title: "Sound Effects",
            yPosition: yPos,
            toggleName: "soundToggle"
        )
        yPos -= 70

        // Music Section
        createSettingRow(
            icon: "🎵",
            title: "Background Music",
            yPosition: yPos,
            toggleName: "musicToggle"
        )
        yPos -= 70

        // FREE Remove Ads Section
        createSettingRow(
            icon: "🚫",
            title: "Remove Ads (FREE)",
            yPosition: yPos,
            toggleName: "adsToggle"
        )
        yPos -= 90

        // Donation Section Header
        let donationHeader = FontManager.shared.createLabel(
            text: "💝 Help My Son Fight DMD",
            font: .headline,
            color: .crystalGold
        )
        donationHeader.position = CGPoint(x: frame.midX, y: yPos)
        donationHeader.zPosition = 10
        addChild(donationHeader)
        yPos -= 30

        let donationSubtext = FontManager.shared.createLabel(
            text: "Every donation helps fund his Elevidys treatment",
            font: .caption,
            color: UIColor.lightGray
        )
        donationSubtext.position = CGPoint(x: frame.midX, y: yPos)
        donationSubtext.zPosition = 10
        addChild(donationSubtext)
        yPos -= 25

        // Info notice about donations
        let infoNotice = FontManager.shared.createLabel(
            text: "(Available after App Store approval)",
            font: .caption,
            color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.7)
        )
        infoNotice.fontSize = 12
        infoNotice.position = CGPoint(x: frame.midX, y: yPos)
        infoNotice.zPosition = 10
        addChild(infoNotice)
        yPos -= 35

        // Donation Buttons - Quick amounts
        let donationAmounts = [3, 5, 10]
        let buttonSpacing: CGFloat = 160

        for (index, amount) in donationAmounts.enumerated() {
            let xOffset = CGFloat(index - 1) * buttonSpacing
            let donateButton = createDonationButton(amount: amount)
            donateButton.position = CGPoint(x: frame.midX + xOffset, y: yPos)
            donateButton.name = "donate\(amount)"
            addChild(donateButton)
        }
        yPos -= 80

        // Custom Amount Button
        let customButton = createActionButton(
            text: "Custom Amount",
            icon: "💰",
            position: CGPoint(x: frame.midX, y: yPos),
            color: UIColor(red: 0.0, green: 0.5, blue: 0.8, alpha: 0.9)
        )
        customButton.name = "customDonation"
        addChild(customButton)
        yPos -= 70

        // Reset Progress Button
        let resetButton = createActionButton(
            text: "Reset Progress",
            icon: "⚠️",
            position: CGPoint(x: frame.midX, y: yPos),
            color: UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.8)
        )
        resetButton.name = "resetButton"
        addChild(resetButton)

        // Back Button
        let backButton = createBackButton()
        backButton.name = "backButton"
        backButton.position = CGPoint(x: frame.midX, y: 60)
        addChild(backButton)

        // Version Info
        let versionLabel = FontManager.shared.createLabel(
            text: "Version 1.0.0",
            font: .caption,
            color: UIColor.lightGray
        )
        versionLabel.position = CGPoint(x: frame.midX, y: 20)
        versionLabel.zPosition = 10
        addChild(versionLabel)
    }

    private func createSettingRow(icon: String, title: String, yPosition: CGFloat, toggleName: String) {
        // Icon
        let iconLabel = SKLabelNode(fontNamed: "Apple Color Emoji")
        iconLabel.text = icon
        iconLabel.fontSize = 28
        iconLabel.position = CGPoint(x: frame.midX - 140, y: yPosition - 8)
        iconLabel.zPosition = 10
        addChild(iconLabel)

        // Title
        let titleLabel = FontManager.shared.createLabel(
            text: title,
            font: .body,
            color: .white
        )
        titleLabel.position = CGPoint(x: frame.midX - 90, y: yPosition)
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.zPosition = 10
        addChild(titleLabel)

        // Toggle Switch
        let initialState: Bool
        if toggleName == "adsToggle" {
            initialState = adsRemoved
        } else {
            initialState = true
        }

        let toggle = createToggle(enabled: initialState)
        toggle.position = CGPoint(x: frame.midX + 120, y: yPosition)
        toggle.name = toggleName
        toggle.zPosition = 10
        addChild(toggle)

        if toggleName == "soundToggle" {
            soundToggle = toggle
        } else if toggleName == "musicToggle" {
            musicToggle = toggle
        } else if toggleName == "adsToggle" {
            adsToggle = toggle
        }
    }

    private func createToggle(enabled: Bool) -> SKShapeNode {
        let toggleWidth: CGFloat = 60
        let toggleHeight: CGFloat = 32

        let toggleBg = SKShapeNode(
            rect: CGRect(x: -toggleWidth/2, y: -toggleHeight/2, width: toggleWidth, height: toggleHeight),
            cornerRadius: toggleHeight/2
        )
        toggleBg.fillColor = enabled ? UIColor.crystalGreen : UIColor.darkGray
        toggleBg.strokeColor = .white
        toggleBg.lineWidth = 2

        // Knob
        let knob = SKShapeNode(circleOfRadius: toggleHeight/2 - 4)
        knob.fillColor = .white
        knob.strokeColor = .clear
        knob.position = CGPoint(
            x: enabled ? toggleWidth/2 - toggleHeight/2 : -toggleWidth/2 + toggleHeight/2,
            y: 0
        )
        knob.name = "knob"
        toggleBg.addChild(knob)

        return toggleBg
    }

    private func createDonationButton(amount: Int) -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -70, y: -25, width: 140, height: 50),
            cornerRadius: 25
        )
        button.fillColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 0.9)
        button.strokeColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
        button.lineWidth = 2
        button.zPosition = 10

        let label = FontManager.shared.createLabel(
            text: "$\(amount)",
            font: .button,
            color: .white
        )
        label.verticalAlignmentMode = .center
        button.addChild(label)

        // Sparkle effect for $100
        if amount == 100 {
            let sparkle = SKLabelNode(text: "✨")
            sparkle.fontSize = 20
            sparkle.position = CGPoint(x: -50, y: 0)
            sparkle.verticalAlignmentMode = .center
            button.addChild(sparkle)

            let sparkle2 = SKLabelNode(text: "✨")
            sparkle2.fontSize = 20
            sparkle2.position = CGPoint(x: 50, y: 0)
            sparkle2.verticalAlignmentMode = .center
            button.addChild(sparkle2)
        }

        return button
    }

    private func createActionButton(text: String, icon: String, position: CGPoint, color: UIColor) -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -140, y: -22, width: 280, height: 44),
            cornerRadius: 22
        )
        button.fillColor = color
        button.strokeColor = .white
        button.lineWidth = 2
        button.position = position
        button.zPosition = 10

        let iconLabel = SKLabelNode(text: icon)
        iconLabel.fontSize = 20
        iconLabel.position = CGPoint(x: -90, y: -8)
        iconLabel.verticalAlignmentMode = .center
        button.addChild(iconLabel)

        let label = FontManager.shared.createLabel(
            text: text,
            font: .body,
            color: .white
        )
        label.position = CGPoint(x: 0, y: 0)
        label.verticalAlignmentMode = .center
        button.addChild(label)

        return button
    }

    private func createBackButton() -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -120, y: -25, width: 240, height: 50),
            cornerRadius: 25
        )
        button.fillColor = UIColor.crystalBlue
        button.strokeColor = .white
        button.lineWidth = 3
        button.zPosition = 10

        let label = FontManager.shared.createLabel(
            text: "← Back to Menu",
            font: .button,
            color: .white
        )
        label.verticalAlignmentMode = .center
        button.addChild(label)

        return button
    }

    private func toggleSwitch(_ toggle: SKShapeNode) {
        guard let knob = toggle.childNode(withName: "knob") else { return }

        let currentEnabled = toggle.fillColor == UIColor.crystalGreen
        let newEnabled = !currentEnabled

        // Animate toggle
        let newColor = newEnabled ? UIColor.crystalGreen : UIColor.darkGray
        toggle.fillColor = newColor

        let toggleWidth: CGFloat = 60
        let toggleHeight: CGFloat = 32
        let newKnobX = newEnabled ? toggleWidth/2 - toggleHeight/2 : -toggleWidth/2 + toggleHeight/2

        let moveAction = SKAction.moveTo(x: newKnobX, duration: 0.2)
        moveAction.timingMode = .easeInEaseOut
        knob.run(moveAction)

        SoundManager.shared.playSound(.buttonTap)

        // Update settings
        if toggle == soundToggle {
            soundEnabled = newEnabled
            SoundManager.shared.setSoundEnabled(newEnabled)
        } else if toggle == musicToggle {
            musicEnabled = newEnabled
        } else if toggle == adsToggle {
            adsRemoved = newEnabled
            // Save ad removal setting (FREE!)
            UserDefaults.standard.set(newEnabled, forKey: "AdsRemoved")
            showMessage(newEnabled ? "Ads Removed! 🎉" : "Ads Enabled")
        }
    }

    private func processDonation(amount: Int) {
        SoundManager.shared.playSound(.buttonTap)

        // Use MonetizationManager to handle the IAP
        MonetizationManager.shared.purchaseCoins(amount, completion: { [weak self] success in
            if success {
                self?.showMessage("Thank you! You're helping save my son's life! ❤️")
            } else {
                // Show simple coming soon message
                self?.showMessage("Coming Soon! 💝")
            }
        })
    }

    private func showMessage(_ text: String) {
        let message = FontManager.shared.createLabel(
            text: text,
            font: .headline,
            color: .crystalGreen
        )
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        message.zPosition = 150
        message.alpha = 0
        addChild(message)

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()

        message.run(SKAction.sequence([fadeIn, wait, fadeOut, remove]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        handleTouch(touchedNode)
    }

    private func handleTouch(_ node: SKNode) {
        let nodeName = node.name ?? node.parent?.name ?? ""

        // Handle toggles
        if nodeName == "soundToggle" || nodeName == "musicToggle" || nodeName == "adsToggle" {
            if let toggle = node as? SKShapeNode {
                toggleSwitch(toggle)
            } else if let toggle = node.parent as? SKShapeNode {
                toggleSwitch(toggle)
            }
            return
        }

        // Handle donations
        if nodeName.starts(with: "donate") {
            let amountStr = nodeName.replacingOccurrences(of: "donate", with: "")
            if let amount = Int(amountStr) {
                processDonation(amount: amount)
            }
            return
        }

        // Handle custom donations
        if nodeName.starts(with: "customDonate") {
            let amountStr = nodeName.replacingOccurrences(of: "customDonate", with: "")
            if let amount = Int(amountStr) {
                hideCustomDonationDialog()
                processDonation(amount: amount)
            }
            return
        }

        // Handle close custom donation
        if nodeName == "closeCustomDonation" {
            hideCustomDonationDialog()
            return
        }

        switch nodeName {
        case "customDonation":
            showCustomDonationDialog()
        case "resetButton":
            showResetConfirmation()
        case "backButton":
            returnToMenu()
        default:
            break
        }
    }

    private func showCustomDonationDialog() {
        SoundManager.shared.playSound(.buttonTap)

        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.85)
        overlay.strokeColor = .clear
        overlay.zPosition = 100
        overlay.name = "customDonationOverlay"
        addChild(overlay)

        let panel = SKShapeNode(
            rect: CGRect(x: frame.midX - 160, y: frame.midY - 200, width: 320, height: 400),
            cornerRadius: 20
        )
        panel.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        panel.strokeColor = UIColor.crystalGold
        panel.lineWidth = 3
        panel.zPosition = 101
        panel.name = "customDonationOverlay"
        addChild(panel)

        let titleLabel = FontManager.shared.createLabel(
            text: "💝 Help My Son",
            font: .headline,
            color: .crystalGold
        )
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        titleLabel.zPosition = 102
        titleLabel.name = "customDonationOverlay"
        addChild(titleLabel)

        // More donation amounts including popular choices
        let customAmounts = [15, 20, 25, 50, 75, 100, 150, 200]
        let buttonsPerRow = 2
        let buttonWidth: CGFloat = 130
        let buttonHeight: CGFloat = 50
        let xSpacing: CGFloat = 150
        let ySpacing: CGFloat = 65

        for (index, amount) in customAmounts.enumerated() {
            let row = index / buttonsPerRow
            let col = index % buttonsPerRow
            let xPos = frame.midX + (CGFloat(col) - 0.5) * xSpacing
            let yPos = frame.midY + 100 - CGFloat(row) * ySpacing

            let button = createCustomAmountButton(amount: amount)
            button.position = CGPoint(x: xPos, y: yPos)
            button.name = "customDonate\(amount)"
            button.zPosition = 102
            addChild(button)
        }

        // Close button
        let closeButton = createSmallButton(text: "Close", color: UIColor.darkGray)
        closeButton.position = CGPoint(x: frame.midX, y: frame.midY - 160)
        closeButton.name = "closeCustomDonation"
        closeButton.zPosition = 102
        addChild(closeButton)
    }

    private func createCustomAmountButton(amount: Int) -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -60, y: -22, width: 120, height: 44),
            cornerRadius: 22
        )
        button.fillColor = UIColor(red: 0.0, green: 0.6, blue: 0.2, alpha: 0.9)
        button.strokeColor = UIColor(red: 0.0, green: 0.8, blue: 0.3, alpha: 1.0)
        button.lineWidth = 2

        let label = FontManager.shared.createLabel(
            text: "$\(amount)",
            font: .button,
            color: .white
        )
        label.verticalAlignmentMode = .center
        button.addChild(label)

        // Special sparkles for larger amounts
        if amount >= 50 {
            let sparkle = SKLabelNode(text: "✨")
            sparkle.fontSize = 16
            sparkle.position = CGPoint(x: -45, y: 0)
            sparkle.verticalAlignmentMode = .center
            button.addChild(sparkle)

            let sparkle2 = SKLabelNode(text: "✨")
            sparkle2.fontSize = 16
            sparkle2.position = CGPoint(x: 45, y: 0)
            sparkle2.verticalAlignmentMode = .center
            button.addChild(sparkle2)
        }

        return button
    }

    private func hideCustomDonationDialog() {
        enumerateChildNodes(withName: "customDonationOverlay") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "closeCustomDonation") { node, _ in
            node.removeFromParent()
        }
        // Remove custom donate buttons
        for amount in [15, 20, 25, 50, 75, 100, 150, 200] {
            childNode(withName: "customDonate\(amount)")?.removeFromParent()
        }
    }

    private func showResetConfirmation() {
        SoundManager.shared.playSound(.buttonTap)

        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.8)
        overlay.strokeColor = .clear
        overlay.zPosition = 100
        overlay.name = "confirmOverlay"
        addChild(overlay)

        let panel = SKShapeNode(
            rect: CGRect(x: frame.midX - 150, y: frame.midY - 100, width: 300, height: 200),
            cornerRadius: 20
        )
        panel.fillColor = UIColor.darkGray
        panel.strokeColor = .white
        panel.lineWidth = 3
        panel.zPosition = 101
        panel.name = "confirmOverlay"
        addChild(panel)

        let warningLabel = FontManager.shared.createLabel(
            text: "⚠️ Warning!",
            font: .headline,
            color: .crystalGold
        )
        warningLabel.position = CGPoint(x: frame.midX, y: frame.midY + 60)
        warningLabel.zPosition = 102
        warningLabel.name = "confirmOverlay"
        addChild(warningLabel)

        let messageLabel = FontManager.shared.createLabel(
            text: "Reset all progress?",
            font: .body,
            color: .white
        )
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        messageLabel.zPosition = 102
        messageLabel.name = "confirmOverlay"
        addChild(messageLabel)

        let confirmButton = createSmallButton(text: "Reset", color: UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0))
        confirmButton.position = CGPoint(x: frame.midX - 60, y: frame.midY - 40)
        confirmButton.name = "confirmReset"
        confirmButton.zPosition = 102
        addChild(confirmButton)

        let cancelButton = createSmallButton(text: "Cancel", color: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0))
        cancelButton.position = CGPoint(x: frame.midX + 60, y: frame.midY - 40)
        cancelButton.name = "cancelReset"
        cancelButton.zPosition = 102
        addChild(cancelButton)
    }

    private func createSmallButton(text: String, color: UIColor) -> SKShapeNode {
        let button = SKShapeNode(
            rect: CGRect(x: -50, y: -20, width: 100, height: 40),
            cornerRadius: 20
        )
        button.fillColor = color
        button.strokeColor = .white
        button.lineWidth = 2

        let label = FontManager.shared.createLabel(
            text: text,
            font: .body,
            color: .white
        )
        label.verticalAlignmentMode = .center
        button.addChild(label)

        return button
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        let nodeName = touchedNode.name ?? touchedNode.parent?.name ?? ""

        if nodeName == "confirmReset" {
            resetProgress()
        } else if nodeName == "cancelReset" {
            hideConfirmation()
        }
    }

    private func resetProgress() {
        LevelManager.shared.resetProgress()
        GameModeManager.shared.resetHighScores()
        SoundManager.shared.playSound(.buttonTap)
        hideConfirmation()

        showMessage("Progress Reset!")
    }

    private func hideConfirmation() {
        enumerateChildNodes(withName: "confirmOverlay") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "confirmReset") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "cancelReset") { node, _ in
            node.removeFromParent()
        }
    }

    private func returnToMenu() {
        SoundManager.shared.playSound(.buttonTap)
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
