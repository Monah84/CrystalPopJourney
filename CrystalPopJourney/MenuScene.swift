import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        setupAnimations()
    }
    
    private func setupBackground() {
        let gradient = SKShapeNode(rect: frame)
        gradient.fillColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0) // Purple
        gradient.strokeColor = .clear
        addChild(gradient)
        
        createFloatingCrystals()
        createStarField()
    }
    
    private func createFloatingCrystals() {
        for _ in 0..<8 {
            let crystal = Crystal(type: Crystal.CrystalType.allCases.randomElement()!)
            crystal.position = CGPoint(
                x: CGFloat.random(in: 50...frame.width - 50),
                y: CGFloat.random(in: 100...frame.height - 100)
            )
            crystal.alpha = 0.3
            crystal.zPosition = -1
            
            let floatAction = SKAction.sequence([
                SKAction.moveBy(x: CGFloat.random(in: -50...50), y: CGFloat.random(in: -30...30), duration: Double.random(in: 3...6)),
                SKAction.moveBy(x: CGFloat.random(in: -50...50), y: CGFloat.random(in: -30...30), duration: Double.random(in: 3...6))
            ])
            
            let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: Double.random(in: 8...12))
            
            crystal.run(SKAction.repeatForever(floatAction))
            crystal.run(SKAction.repeatForever(rotateAction))
            
            addChild(crystal)
        }
    }
    
    private func createStarField() {
        for _ in 0..<30 {
            let star = SKShapeNode(circleOfRadius: 2)
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            star.alpha = CGFloat.random(in: 0.3...0.8)
            star.zPosition = -2
            
            let twinkle = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.2, duration: Double.random(in: 1.0...2.0)),
                SKAction.fadeAlpha(to: 0.8, duration: Double.random(in: 1.0...2.0))
            ])
            star.run(SKAction.repeatForever(twinkle))
            
            addChild(star)
        }
    }
    
    private func setupUI() {
        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "Crystal Pop"
        titleLabel.fontSize = 64
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        titleLabel.zPosition = 10
        
        let titleShadow = SKLabelNode(fontNamed: "Arial-Bold")
        titleShadow.text = "Crystal Pop"
        titleShadow.fontSize = 64
        titleShadow.fontColor = .black
        titleShadow.position = CGPoint(x: frame.midX + 3, y: frame.midY + 197)
        titleShadow.alpha = 0.5
        titleShadow.zPosition = 9
        
        addChild(titleShadow)
        addChild(titleLabel)
        
        let subtitleLabel = SKLabelNode(fontNamed: "Arial")
        subtitleLabel.text = "Journey"
        subtitleLabel.fontSize = 24
        subtitleLabel.fontColor = UIColor.yellow
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
        
        let playButton = createMenuButton(text: "Play", position: CGPoint(x: frame.midX, y: frame.midY + 50))
        playButton.name = "playButton"
        addChild(playButton)
        
        let scoresButton = createMenuButton(text: "High Scores", position: CGPoint(x: frame.midX, y: frame.midY - 20))
        scoresButton.name = "levelsButton"
        addChild(scoresButton)

        let leaderboardButton = createMenuButton(text: "🏆 Leaderboards", position: CGPoint(x: frame.midX, y: frame.midY - 90))
        leaderboardButton.name = "leaderboardButton"
        addChild(leaderboardButton)

        let aboutButton = createMenuButton(text: "About DMD", position: CGPoint(x: frame.midX, y: frame.midY - 160))
        aboutButton.name = "aboutButton"
        addChild(aboutButton)

        let settingsButton = createMenuButton(text: "Settings", position: CGPoint(x: frame.midX, y: frame.midY - 230))
        settingsButton.name = "settingsButton"
        addChild(settingsButton)
    }
    
    private func createMenuButton(text: String, position: CGPoint) -> SKShapeNode {
        let button = SKShapeNode(rect: CGRect(x: -120, y: -30, width: 240, height: 60), cornerRadius: 30)
        button.fillColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Blue
        button.strokeColor = UIColor.white
        button.lineWidth = 3
        button.position = position
        button.zPosition = 10
        
        let innerGlow = SKShapeNode(rect: CGRect(x: -115, y: -25, width: 230, height: 50), cornerRadius: 25)
        innerGlow.fillColor = UIColor.white.withAlphaComponent(0.2)
        innerGlow.strokeColor = .clear
        button.addChild(innerGlow)
        
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = text
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    private func setupAnimations() {
        let titleAnimation = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        
        if let titleLabel = childNode(withName: "//titleLabel") {
            titleLabel.run(SKAction.repeatForever(titleAnimation))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        animateButtonPress(touchedNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        handleButtonTouch(touchedNode)
    }
    
    private func animateButtonPress(_ node: SKNode) {
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([scaleDown, scaleUp])
        
        if let button = node.parent as? SKShapeNode ?? node as? SKShapeNode {
            button.run(sequence)
        }
    }
    
    private func handleButtonTouch(_ node: SKNode) {
        let nodeName = node.name ?? node.parent?.name ?? ""

        // Handle game mode selection
        if nodeName.starts(with: "modeButton_") {
            let modeName = nodeName.replacingOccurrences(of: "modeButton_", with: "")
            let mode: GameMode
            switch modeName {
            case "Classic": mode = .classic
            case "Timed": mode = .timed
            case "Arcade": mode = .arcade
            case "Challenge": mode = .challenge
            default: return
            }
            SoundManager.shared.playSound(.buttonTap)
            startGameWithMode(mode)
            return
        }

        switch nodeName {
        case "playButton":
            startGame()
        case "levelsButton":
            showLevels()
        case "leaderboardButton":
            showLeaderboards()
        case "globalLeaderboardButton":
            SoundManager.shared.playSound(.buttonTap)
            GameCenterManager.shared.showLeaderboard(scope: .global)
            hideLeaderboardSelection()
        case "friendsLeaderboardButton":
            SoundManager.shared.playSound(.buttonTap)
            GameCenterManager.shared.showLeaderboard(scope: .friends)
            hideLeaderboardSelection()
        case "aboutButton":
            showAboutDMD()
        case "settingsButton":
            showSettings()
        case "backToMenuButton":
            SoundManager.shared.playSound(.buttonTap)
            hideModeSelection()
        case "backFromLeaderboardButton":
            SoundManager.shared.playSound(.buttonTap)
            hideLeaderboardSelection()
        default:
            break
        }
    }
    
    private func startGame() {
        SoundManager.shared.playSound(.buttonTap)
        showGameModeSelection()
    }

    private func showGameModeSelection() {
        // Create fully opaque background to hide menu behind it
        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor(red: 0.1, green: 0.0, blue: 0.15, alpha: 1.0) // Dark purple, fully opaque
        overlay.strokeColor = .clear
        overlay.zPosition = 100
        overlay.name = "modeSelectionOverlay"
        addChild(overlay)

        // Title
        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "Select Game Mode"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 220)
        titleLabel.zPosition = 101
        titleLabel.name = "modeSelectionOverlay"
        addChild(titleLabel)

        // Create mode selection buttons
        let modes: [GameMode] = [.classic, .timed, .arcade, .challenge]
        let startY = frame.midY + 140

        for (index, mode) in modes.enumerated() {
            let yPos = startY - CGFloat(index) * 100

            let modeButton = createModeButton(mode: mode, position: CGPoint(x: frame.midX, y: yPos))
            modeButton.name = "modeButton_\(mode.displayName)"
            modeButton.zPosition = 101
            addChild(modeButton)
        }

        // Back button
        let backButton = createMenuButton(text: "Back", position: CGPoint(x: frame.midX, y: frame.midY - 240))
        backButton.name = "backToMenuButton"
        backButton.zPosition = 101
        addChild(backButton)
    }

    private func createModeButton(mode: GameMode, position: CGPoint) -> SKShapeNode {
        let button = SKShapeNode(rect: CGRect(x: -160, y: -35, width: 320, height: 70), cornerRadius: 20)
        button.fillColor = UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0) // Indigo
        button.strokeColor = UIColor.white
        button.lineWidth = 2
        button.position = position

        // Mode icon
        let iconLabel = SKLabelNode(fontNamed: "Arial")
        iconLabel.text = mode.icon
        iconLabel.fontSize = 30
        iconLabel.position = CGPoint(x: -120, y: 0)
        iconLabel.verticalAlignmentMode = .center
        button.addChild(iconLabel)

        // Mode name
        let nameLabel = SKLabelNode(fontNamed: "Arial-Bold")
        nameLabel.text = mode.displayName
        nameLabel.fontSize = 22
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: 8)
        nameLabel.verticalAlignmentMode = .center
        button.addChild(nameLabel)

        // Mode description
        let descLabel = SKLabelNode(fontNamed: "Arial")
        descLabel.text = mode.description
        descLabel.fontSize = 14
        descLabel.fontColor = UIColor.lightGray
        descLabel.position = CGPoint(x: 0, y: -12)
        descLabel.verticalAlignmentMode = .center
        button.addChild(descLabel)

        // High score
        let highScore = GameModeManager.shared.getHighScore(for: mode)
        if highScore > 0 {
            let scoreLabel = SKLabelNode(fontNamed: "Arial")
            scoreLabel.text = "Best: \(highScore)"
            scoreLabel.fontSize = 12
            scoreLabel.fontColor = .yellow
            scoreLabel.position = CGPoint(x: 120, y: 0)
            scoreLabel.verticalAlignmentMode = .center
            button.addChild(scoreLabel)
        }

        return button
    }

    private func hideModeSelection() {
        enumerateChildNodes(withName: "modeSelectionOverlay") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "modeButton_*") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "backToMenuButton") { node, _ in
            node.removeFromParent()
        }
    }

    private func hideLeaderboardSelection() {
        enumerateChildNodes(withName: "leaderboardOverlay") { node, _ in
            node.removeFromParent()
        }
        childNode(withName: "globalLeaderboardButton")?.removeFromParent()
        childNode(withName: "friendsLeaderboardButton")?.removeFromParent()
        childNode(withName: "backFromLeaderboardButton")?.removeFromParent()
    }

    private func startGameWithMode(_ mode: GameMode) {
        GameModeManager.shared.setCurrentMode(mode)

        let gameScene = GameScene(size: size, mode: mode)
        gameScene.scaleMode = scaleMode

        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func showLevels() {
        SoundManager.shared.playSound(.buttonTap)
        let scoresScene = ScoresScene(size: size)
        scoresScene.scaleMode = scaleMode
        view?.presentScene(scoresScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showLeaderboards() {
        SoundManager.shared.playSound(.buttonTap)

        if !GameCenterManager.shared.isAuthenticated {
            showGameCenterNotAvailableMessage()
            return
        }

        // Show leaderboard selection overlay
        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.8)
        overlay.strokeColor = .clear
        overlay.zPosition = 100
        overlay.name = "leaderboardOverlay"
        addChild(overlay)

        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "Select Leaderboard"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        titleLabel.zPosition = 101
        titleLabel.name = "leaderboardOverlay"
        addChild(titleLabel)

        let globalButton = createMenuButton(text: "🌍 Global Rankings", position: CGPoint(x: frame.midX, y: frame.midY + 50))
        globalButton.name = "globalLeaderboardButton"
        globalButton.zPosition = 101
        addChild(globalButton)

        let friendsButton = createMenuButton(text: "👥 Friends Only", position: CGPoint(x: frame.midX, y: frame.midY - 30))
        friendsButton.name = "friendsLeaderboardButton"
        friendsButton.zPosition = 101
        addChild(friendsButton)

        let backButton = createMenuButton(text: "Back", position: CGPoint(x: frame.midX, y: frame.midY - 150))
        backButton.name = "backFromLeaderboardButton"
        backButton.zPosition = 101
        addChild(backButton)
    }

    private func showGameCenterNotAvailableMessage() {
        // Create semi-transparent overlay
        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.7)
        overlay.strokeColor = .clear
        overlay.zPosition = 150
        addChild(overlay)

        // Create message box
        let messageBox = SKShapeNode(rect: CGRect(x: -150, y: -60, width: 300, height: 120), cornerRadius: 20)
        messageBox.fillColor = UIColor(red: 0.2, green: 0.0, blue: 0.3, alpha: 1.0)
        messageBox.strokeColor = .white
        messageBox.lineWidth = 2
        messageBox.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        messageBox.zPosition = 151
        addChild(messageBox)

        let messageLabel = SKLabelNode(fontNamed: "Arial-Bold")
        messageLabel.text = "Game Center Not Available"
        messageLabel.fontSize = 20
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: 0, y: 15)
        messageLabel.verticalAlignmentMode = .center
        messageLabel.zPosition = 152
        messageBox.addChild(messageLabel)

        let detailLabel = SKLabelNode(fontNamed: "Arial")
        detailLabel.text = "Please sign in to Game Center"
        detailLabel.fontSize = 16
        detailLabel.fontColor = UIColor.lightGray
        detailLabel.position = CGPoint(x: 0, y: -15)
        detailLabel.verticalAlignmentMode = .center
        detailLabel.zPosition = 152
        messageBox.addChild(detailLabel)

        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 2.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, fadeOut, remove])

        overlay.run(sequence)
        messageBox.run(sequence)
    }

    private func showAboutDMD() {
        SoundManager.shared.playSound(.buttonTap)
        let aboutScene = AboutDMDScene(size: size)
        aboutScene.scaleMode = scaleMode
        view?.presentScene(aboutScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showSettings() {
        SoundManager.shared.playSound(.buttonTap)
        let settingsScene = SettingsScene(size: size)
        settingsScene.scaleMode = scaleMode
        view?.presentScene(settingsScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}