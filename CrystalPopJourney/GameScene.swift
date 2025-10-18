import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var gameBoard: GameBoard!
    private var scoreLabel: SKLabelNode!
    private var movesLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var timerLabel: SKLabelNode!
    private var backgroundMusic: SKAudioNode?
    private var gameMode: GameMode = .classic
    private var timeRemaining: Int = 0
    private var timer: Timer?
    
    convenience init(size: CGSize, mode: GameMode) {
        self.init(size: size)
        self.gameMode = mode
    }

    override func didMove(to view: SKView) {
        gameMode = GameModeManager.shared.getCurrentMode()
        setupBackground()
        setupGameBoard()
        setupUI()
        setupBackgroundMusic()

        if let startTime = gameMode.startingTime {
            timeRemaining = startTime
            startTimer()
        }

        SoundManager.shared.playSound(.gameStart)
    }

    deinit {
        timer?.invalidate()
    }

    override func update(_ currentTime: TimeInterval) {
        // Ensure board is always complete on every frame
        gameBoard?.ensureBoardComplete()
    }

    private func setupBackground() {
        let gradient = SKShapeNode(rect: frame)
        gradient.fillColor = UIColor(red: 0.3, green: 0.0, blue: 0.5, alpha: 1.0) // Dark Purple
        gradient.strokeColor = .clear
        addChild(gradient)
        
        let overlay = SKShapeNode(rect: frame)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.1)
        overlay.strokeColor = .clear
        addChild(overlay)
        
        createStarField()
    }
    
    private func createStarField() {
        for _ in 0..<50 {
            let star = SKShapeNode(circleOfRadius: 2)
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            star.alpha = CGFloat.random(in: 0.3...1.0)
            
            let twinkle = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 1.0...3.0)),
                SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 1.0...3.0))
            ])
            star.run(SKAction.repeatForever(twinkle))
            
            addChild(star)
        }
    }
    
    private func setupGameBoard() {
        gameBoard = GameBoard()
        gameBoard.gameScene = self
        gameBoard.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        addChild(gameBoard)
    }
    
    private func setupUI() {
        let headerHeight: CGFloat = 150
        let headerY = frame.maxY - headerHeight

        // Beautiful header background with gradient effect
        let headerBackground = SKShapeNode(rect: CGRect(
            x: 0, y: headerY, width: frame.width, height: headerHeight
        ))
        headerBackground.fillColor = UIColor.black.withAlphaComponent(0.4)
        headerBackground.strokeColor = .clear
        addChild(headerBackground)

        // Score label with better positioning
        scoreLabel = createLabel(text: "Score: 0", position: CGPoint(x: 20, y: headerY + 110))
        addChild(scoreLabel)

        // Show timer or moves based on game mode
        if gameMode.startingTime != nil {
            timerLabel = createLabel(text: "Time: \(timeRemaining)", position: CGPoint(x: 20, y: headerY + 75))
            addChild(timerLabel)
        } else {
            movesLabel = createLabel(text: "Moves: \(gameMode.startingMoves)", position: CGPoint(x: 20, y: headerY + 75))
            addChild(movesLabel)
        }

        levelLabel = createLabel(text: "Level: 1", position: CGPoint(x: 20, y: headerY + 40))
        addChild(levelLabel)

        // Beautiful icon buttons on the right side
        let buttonX = frame.width - 40

        let pauseButton = createIconButton(icon: "⏸", position: CGPoint(x: buttonX, y: headerY + 105))
        pauseButton.name = "pauseButton"
        addChild(pauseButton)

        let hintButton = createIconButton(icon: "💡", position: CGPoint(x: buttonX, y: headerY + 60))
        hintButton.name = "hintButton"
        addChild(hintButton)

        let menuButton = createIconButton(icon: "🏠", position: CGPoint(x: buttonX, y: headerY + 15))
        menuButton.name = "menuButton"
        addChild(menuButton)
    }
    
    private func createLabel(text: String, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = text
        label.fontSize = 18
        label.fontColor = .white
        label.position = position
        label.horizontalAlignmentMode = .left
        
        let shadow = SKLabelNode(fontNamed: "Arial-Bold")
        shadow.text = text
        shadow.fontSize = 18
        shadow.fontColor = .black
        shadow.position = CGPoint(x: position.x + 1, y: position.y - 1)
        shadow.horizontalAlignmentMode = .left
        shadow.alpha = 0.5
        addChild(shadow)
        
        return label
    }
    
    private func createIconButton(icon: String, position: CGPoint) -> SKLabelNode {
        let buttonRadius: CGFloat = 28

        // Shadow layer
        let shadow = SKShapeNode(circleOfRadius: buttonRadius)
        shadow.fillColor = UIColor.black.withAlphaComponent(0.5)
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: position.x + 2, y: position.y - 2)
        shadow.zPosition = -1
        addChild(shadow)

        // Main button background with gradient effect
        let background = SKShapeNode(circleOfRadius: buttonRadius)
        background.fillColor = UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 0.9)
        background.strokeColor = UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0)
        background.lineWidth = 3
        background.position = position
        background.zPosition = 0
        addChild(background)

        // Inner highlight for 3D effect
        let highlight = SKShapeNode(circleOfRadius: buttonRadius - 5)
        highlight.fillColor = UIColor.white.withAlphaComponent(0.15)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: 0, y: 5)
        background.addChild(highlight)

        // Icon label
        let button = SKLabelNode(fontNamed: "Arial")
        button.text = icon
        button.fontSize = 28
        button.fontColor = .white
        button.position = position
        button.horizontalAlignmentMode = .center
        button.verticalAlignmentMode = .center
        button.zPosition = 1

        return button
    }
    
    private func setupBackgroundMusic() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "pauseButton" {
            pauseGame()
        } else if touchedNode.name == "menuButton" {
            returnToMenu()
        } else if touchedNode.name == "hintButton" {
            SoundManager.shared.playSound(.buttonTap)
            gameBoard.showHint()
        } else {
            let boardLocation = convert(location, to: gameBoard)
            gameBoard.handleTouch(at: boardLocation)
        }
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(gameBoard.getScore())"

        if gameMode.startingTime != nil {
            timerLabel?.text = "Time: \(timeRemaining)"
            if timeRemaining <= 10 {
                timerLabel?.fontColor = .red
            }
        } else {
            movesLabel?.text = "Moves: \(gameBoard.getMoves())"
        }

        levelLabel.text = "Level: \(gameBoard.getLevel())"

        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        scoreLabel.run(pulseAction)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if !self.isPaused {
                self.timeRemaining -= 1
                self.updateUI()

                if self.timeRemaining <= 0 {
                    self.timer?.invalidate()
                    self.gameBoard.handleTimeUp()
                }
            }
        }
    }

    func addTime(_ seconds: Int) {
        timeRemaining += seconds
        updateUI()
    }

    func showHighScoreMessage() {
        SoundManager.shared.playSound(.highScore)
        SoundManager.shared.playSuccessFeedback()

        // Create congratulations banner
        let banner = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 400, height: 100), cornerRadius: 20)
        banner.fillColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0) // Yellow
        banner.strokeColor = UIColor.orange
        banner.lineWidth = 3
        banner.position = CGPoint(x: frame.midX - 200, y: frame.maxY + 100)
        banner.zPosition = 200

        let congratsLabel = SKLabelNode(fontNamed: "Arial-Bold")
        congratsLabel.text = "🎉 NEW HIGH SCORE! 🎉"
        congratsLabel.fontSize = 28
        congratsLabel.fontColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) // Red
        congratsLabel.position = CGPoint(x: 200, y: 30)
        banner.addChild(congratsLabel)

        addChild(banner)

        // Animate banner sliding in
        let slideIn = SKAction.moveTo(y: frame.midY, duration: 0.5)
        slideIn.timingMode = .easeOut
        let wait = SKAction.wait(forDuration: 2.5)
        let slideOut = SKAction.moveTo(y: frame.maxY + 100, duration: 0.5)
        slideOut.timingMode = .easeIn
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([slideIn, wait, slideOut, remove])
        banner.run(sequence)

        // Add particle effects
        createConfetti()
    }

    private func createConfetti() {
        for _ in 0..<30 {
            let confetti = SKShapeNode(circleOfRadius: 5)
            let colors: [UIColor] = [.red, .yellow, .green, .blue, .orange, .purple]
            confetti.fillColor = colors.randomElement()!
            confetti.strokeColor = .clear
            confetti.position = CGPoint(x: frame.midX, y: frame.midY)
            confetti.zPosition = 199

            let randomX = CGFloat.random(in: -200...200)
            let randomY = CGFloat.random(in: -200...200)
            let moveAction = SKAction.moveBy(x: randomX, y: randomY, duration: 1.5)
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -CGFloat.pi...CGFloat.pi), duration: 1.5)
            let group = SKAction.group([moveAction, fadeOut, rotate])
            let remove = SKAction.removeFromParent()

            addChild(confetti)
            confetti.run(SKAction.sequence([group, remove]))
        }
    }

    func showPowerUpMessage(_ message: String) {
        let messageLabel = SKLabelNode(fontNamed: "Arial-Bold")
        messageLabel.text = message
        messageLabel.fontSize = 32
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        messageLabel.zPosition = 150

        // Add outline
        let outline = SKLabelNode(fontNamed: "Arial-Bold")
        outline.text = message
        outline.fontSize = 32
        outline.fontColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0) // Green
        outline.position = CGPoint(x: 2, y: -2)
        outline.zPosition = -1
        messageLabel.addChild(outline)

        addChild(messageLabel)

        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([scaleUp, scaleDown, wait, fadeOut, remove])
        messageLabel.run(sequence)
    }
    
    func gameOver(score: Int) {
        SoundManager.shared.playSound(.gameOver)

        // Update high score for this mode
        GameModeManager.shared.updateHighScore(for: gameMode, score: score)

        // Submit score to Game Center leaderboard
        GameCenterManager.shared.submitScore(score) { success in
            if success {
                print("✅ Score submitted to leaderboard")
            }
        }

        let gameOverBackground = SKShapeNode(rect: frame)
        gameOverBackground.fillColor = UIColor.black.withAlphaComponent(0.8)
        gameOverBackground.strokeColor = .clear
        gameOverBackground.zPosition = 100
        addChild(gameOverBackground)

        let gameOverLabel = SKLabelNode(fontNamed: "Arial-Bold")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        gameOverLabel.zPosition = 101
        addChild(gameOverLabel)

        // Show game mode
        let modeLabel = SKLabelNode(fontNamed: "Arial")
        modeLabel.text = "\(gameMode.icon) \(gameMode.displayName) Mode"
        modeLabel.fontSize = 20
        modeLabel.fontColor = UIColor.lightGray
        modeLabel.position = CGPoint(x: frame.midX, y: frame.midY + 110)
        modeLabel.zPosition = 101
        addChild(modeLabel)

        let finalScoreLabel = SKLabelNode(fontNamed: "Arial")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 24
        finalScoreLabel.fontColor = .white
        finalScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 70)
        finalScoreLabel.zPosition = 101
        addChild(finalScoreLabel)

        // Show high score for this mode
        let highScore = GameModeManager.shared.getHighScore(for: gameMode)
        let highScoreLabel = SKLabelNode(fontNamed: "Arial")
        highScoreLabel.text = "Best: \(highScore)"
        highScoreLabel.fontSize = 20
        highScoreLabel.fontColor = .yellow
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        highScoreLabel.zPosition = 101
        addChild(highScoreLabel)

        let playAgainButton = createMenuButton(text: "Play Again", position: CGPoint(x: frame.midX, y: frame.midY - 20))
        playAgainButton.name = "playAgainButton"
        playAgainButton.zPosition = 101
        addChild(playAgainButton)

        let menuButton = createMenuButton(text: "Main Menu", position: CGPoint(x: frame.midX, y: frame.midY - 80))
        menuButton.name = "mainMenuButton"
        menuButton.zPosition = 101
        addChild(menuButton)

        MonetizationManager.shared.showInterstitialAd()
    }
    
    private func createMenuButton(text: String, position: CGPoint) -> SKShapeNode {
        let button = SKShapeNode(rect: CGRect(x: -100, y: -25, width: 200, height: 50), cornerRadius: 25)
        button.fillColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Blue
        button.strokeColor = UIColor.white
        button.lineWidth = 2
        button.position = position
        
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = text
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    private func pauseGame() {
        isPaused = true
        
        let pauseBackground = SKShapeNode(rect: frame)
        pauseBackground.fillColor = UIColor.black.withAlphaComponent(0.8)
        pauseBackground.strokeColor = .clear
        pauseBackground.zPosition = 100
        pauseBackground.name = "pauseBackground"
        addChild(pauseBackground)
        
        let pauseLabel = SKLabelNode(fontNamed: "Arial-Bold")
        pauseLabel.text = "Paused"
        pauseLabel.fontSize = 48
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        pauseLabel.zPosition = 101
        pauseLabel.name = "pauseLabel"
        addChild(pauseLabel)
        
        let resumeButton = createMenuButton(text: "Resume", position: CGPoint(x: frame.midX, y: frame.midY - 20))
        resumeButton.name = "resumeButton"
        resumeButton.zPosition = 101
        addChild(resumeButton)
    }
    
    private func resumeGame() {
        isPaused = false
        childNode(withName: "pauseBackground")?.removeFromParent()
        childNode(withName: "pauseLabel")?.removeFromParent()
        childNode(withName: "resumeButton")?.removeFromParent()
    }
    
    private func returnToMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "playAgainButton" || touchedNode.parent?.name == "playAgainButton" {
            let newGameScene = GameScene(size: size, mode: gameMode)
            newGameScene.scaleMode = scaleMode
            view?.presentScene(newGameScene, transition: SKTransition.fade(withDuration: 0.5))
        } else if touchedNode.name == "mainMenuButton" || touchedNode.parent?.name == "mainMenuButton" {
            returnToMenu()
        } else if touchedNode.name == "resumeButton" || touchedNode.parent?.name == "resumeButton" {
            resumeGame()
        }
    }
}