import SpriteKit
import GameplayKit

class GameBoard: SKNode {
    private let boardSize = 8
    private var crystals: [[Crystal?]] = []
    private var selectedCrystal: Crystal?
    private var score = 0
    private var moves = 30
    private var level = 1
    private var highScore = 0
    private var hasBeatenHighScore = false
    private var powerUps: [PowerUp] = []
    private var matchCount = 0
    private var gameMode: GameMode = .classic
    // FIXED crystal size - all tiles are exactly the same size
    private let crystalSize: CGFloat = 40  // FIXED at 40x40 pixels (optimized for iPhone SE)
    private let crystalSpacing: CGFloat = 42  // FIXED at 42px (creates 2px gap between tiles)

    weak var gameScene: GameScene?

    convenience init(screenWidth: CGFloat) {
        self.init()
        // Crystal size and spacing are now FIXED constants
        // All tiles will be exactly 40x40 pixels with 2px gaps
        // Total board width: 42px × 8 = 336px (fits iPhone SE and larger)
    }

    override init() {
        super.init()
        gameMode = GameModeManager.shared.getCurrentMode()
        moves = gameMode.startingMoves
        loadHighScore()

        // Start arcade mission if in arcade mode
        if gameMode == .arcade {
            ArcadeMissionManager.shared.startNewGame()
        }

        setupBoard()
        fillBoard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoard() {
        crystals = Array(repeating: Array(repeating: nil, count: boardSize), count: boardSize)
    }
    
    private func fillBoard() {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let crystal = createRandomCrystal(at: row, col: col)
                crystals[row][col] = crystal
                addChild(crystal)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeInitialMatches()
        }
    }
    
    private func createRandomCrystal(at row: Int, col: Int) -> Crystal {
        let availableTypes = Crystal.CrystalType.allCases
        let randomType = availableTypes.randomElement()!

        let crystal = Crystal(type: randomType, size: crystalSize)
        crystal.row = row
        crystal.column = col
        crystal.position = positionForCrystal(row: row, col: col)

        return crystal
    }
    
    private func positionForCrystal(row: Int, col: Int) -> CGPoint {
        let halfSpacing = crystalSpacing / 2
        let x = CGFloat(col) * crystalSpacing - CGFloat(boardSize - 1) * halfSpacing
        let y = CGFloat(row) * crystalSpacing - CGFloat(boardSize - 1) * halfSpacing
        return CGPoint(x: x, y: y)
    }
    
    func handleTouch(at location: CGPoint) {
        let touchedNode = atPoint(location)

        // Check if a power-up was touched (check node itself or its parent)
        var powerUp: PowerUp? = nil
        if let touchedPowerUp = touchedNode as? PowerUp {
            powerUp = touchedPowerUp
        } else if let parentPowerUp = touchedNode.parent as? PowerUp {
            powerUp = parentPowerUp
        }

        if let touchedPowerUp = powerUp {
            collectPowerUp(touchedPowerUp)
            return
        }

        // Check if we touched a Crystal directly or one of its children
        var crystal: Crystal? = nil
        if let touchedCrystal = touchedNode as? Crystal {
            crystal = touchedCrystal
        } else if let parent = touchedNode.parent as? Crystal {
            crystal = parent
        }

        guard let touchedCrystal = crystal else { return }

        if selectedCrystal == nil {
            selectCrystal(touchedCrystal)
        } else if selectedCrystal == touchedCrystal {
            deselectCrystal()
        } else {
            attemptSwap(from: selectedCrystal!, to: touchedCrystal)
        }
    }
    
    private func selectCrystal(_ crystal: Crystal) {
        selectedCrystal = crystal
        crystal.animateSelection()
        SoundManager.shared.playSound(.select)
    }
    
    private func deselectCrystal() {
        selectedCrystal = nil
    }
    
    private func attemptSwap(from crystal1: Crystal, to crystal2: Crystal) {
        guard areAdjacent(crystal1, crystal2) else {
            deselectCrystal()
            selectCrystal(crystal2)
            return
        }

        swapCrystals(crystal1, crystal2) { [weak self] in
            guard let self = self else { return }

            if self.hasMatches() == true {
                self.moves -= 1
                self.processMatches()
                self.gameScene?.updateUI()
            } else {
                self.swapCrystals(crystal1, crystal2) {
                    // Force-fill after swap-back completes
                    self.forceFillAnyMissingTiles()
                }
            }
            self.deselectCrystal()
        }
    }
    
    private func areAdjacent(_ crystal1: Crystal, _ crystal2: Crystal) -> Bool {
        let rowDiff = abs(crystal1.row - crystal2.row)
        let colDiff = abs(crystal1.column - crystal2.column)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    private func swapCrystals(_ crystal1: Crystal, _ crystal2: Crystal, completion: @escaping () -> Void) {
        let tempRow = crystal1.row
        let tempCol = crystal1.column
        
        crystal1.row = crystal2.row
        crystal1.column = crystal2.column
        crystal2.row = tempRow
        crystal2.column = tempCol
        
        crystals[crystal1.row][crystal1.column] = crystal1
        crystals[crystal2.row][crystal2.column] = crystal2
        
        let pos1 = positionForCrystal(row: crystal1.row, col: crystal1.column)
        let pos2 = positionForCrystal(row: crystal2.row, col: crystal2.column)
        
        let move1 = SKAction.move(to: pos1, duration: 0.3)
        let move2 = SKAction.move(to: pos2, duration: 0.3)
        
        crystal1.run(move1)
        crystal2.run(move2, completion: completion)
    }
    
    private func hasMatches() -> Bool {
        return findMatches().count > 0
    }
    
    private func findMatches() -> Set<Crystal> {
        var matches = Set<Crystal>()
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                guard let crystal = crystals[row][col] else { continue }
                
                let horizontalMatches = findHorizontalMatches(from: crystal)
                let verticalMatches = findVerticalMatches(from: crystal)
                
                if horizontalMatches.count >= 3 {
                    matches.formUnion(horizontalMatches)
                }
                
                if verticalMatches.count >= 3 {
                    matches.formUnion(verticalMatches)
                }
            }
        }
        
        return matches
    }
    
    private func findHorizontalMatches(from crystal: Crystal) -> [Crystal] {
        var matches = [crystal]
        let type = crystal.type
        
        for col in (crystal.column + 1)..<boardSize {
            guard let nextCrystal = crystals[crystal.row][col],
                  nextCrystal.type == type else { break }
            matches.append(nextCrystal)
        }
        
        for col in stride(from: crystal.column - 1, through: 0, by: -1) {
            guard let prevCrystal = crystals[crystal.row][col],
                  prevCrystal.type == type else { break }
            matches.append(prevCrystal)
        }
        
        return matches
    }
    
    private func findVerticalMatches(from crystal: Crystal) -> [Crystal] {
        var matches = [crystal]
        let type = crystal.type
        
        for row in (crystal.row + 1)..<boardSize {
            guard let nextCrystal = crystals[row][crystal.column],
                  nextCrystal.type == type else { break }
            matches.append(nextCrystal)
        }
        
        for row in stride(from: crystal.row - 1, through: 0, by: -1) {
            guard let prevCrystal = crystals[row][crystal.column],
                  prevCrystal.type == type else { break }
            matches.append(prevCrystal)
        }
        
        return matches
    }
    
    private func processMatches() {
        let matches = findMatches()
        guard !matches.isEmpty else {
            // After processing all matches, check if board has possible moves
            print("DEBUG processMatches: No matches found, checking board")
            forceFillAnyMissingTiles() // SAFETY: Ensure board is complete
            validateBoardComplete()

            // Check arcade mission completion
            if gameMode == .arcade {
                checkArcadeMissionComplete()
            }

            if !hasPossibleMoves() {
                scrambleBoard()
            } else {
                checkGameOver()
            }
            return
        }

        print("DEBUG processMatches: Found \(matches.count) matches")
        removeMatches(matches) { [weak self] in
            print("DEBUG processMatches: Remove complete, calling dropCrystals")
            self?.dropCrystals {
                print("DEBUG processMatches: Drop complete, calling fillEmptySpaces")
                self?.fillEmptySpaces {
                    print("DEBUG processMatches: Fill complete, calling processMatches recursively")
                    self?.forceFillAnyMissingTiles() // SAFETY: Ensure board is complete
                    self?.validateBoardComplete()
                    self?.processMatches()
                }
            }
        }
    }

    private func checkArcadeMissionComplete() {
        guard gameMode == .arcade else { return }

        if ArcadeMissionManager.shared.checkMissionComplete() {
            let completedMission = ArcadeMissionManager.shared.getCurrentMission()

            // Award bonus moves and points
            addMoves(completedMission.bonusMoves)
            addScore(completedMission.bonusPoints)

            // Show completion message
            let message = "Mission \(completedMission.missionNumber) Complete!\n+\(completedMission.bonusMoves) Moves  +\(completedMission.bonusPoints) Points"
            gameScene?.showPowerUpMessage(message)

            // Advance to next mission
            let nextMission = ArcadeMissionManager.shared.advanceToNextMission()
            print("✅ Mission completed! Next: Mission \(nextMission.missionNumber)")

            // Update UI to show new mission
            gameScene?.updateUI()
        }
    }

    // SAFETY MECHANISM: Force fill any nil positions without animation
    private func forceFillAnyMissingTiles() {
        var filledCount = 0
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if crystals[row][col] == nil {
                    print("⚠️ FORCE FILLING missing tile at (\(row),\(col))")
                    let crystal = createRandomCrystal(at: row, col: col)
                    crystal.position = positionForCrystal(row: row, col: col)
                    crystals[row][col] = crystal
                    addChild(crystal)
                    filledCount += 1
                }
            }
        }
        if filledCount > 0 {
            print("⚠️ FORCE FILLED \(filledCount) missing tiles!")
        }
    }

    private func validateBoardComplete() {
        var missingCount = 0
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if crystals[row][col] == nil {
                    print("⚠️ BOARD INCOMPLETE: Missing crystal at (\(row),\(col))")
                    missingCount += 1
                }
            }
        }
        if missingCount == 0 {
            print("✅ BOARD COMPLETE: All positions filled")
        } else {
            print("❌ BOARD INCOMPLETE: \(missingCount) missing crystals!")
        }
    }
    
    private func removeMatches(_ matches: Set<Crystal>, completion: @escaping () -> Void) {
        SoundManager.shared.playSound(.match)

        let matchesCount = matches.count
        addScore(matchesCount * 10 * level)
        matchCount += 1

        // Track destroyed crystals for arcade mode missions
        if gameMode == .arcade {
            for crystal in matches {
                ArcadeMissionManager.shared.recordCrystalDestroyed(crystal.type)
            }
        }

        // Randomly spawn power-up (10% chance after every 3 matches)
        if matchCount % 3 == 0 && CGFloat.random(in: 0...1) < 0.3 {
            spawnRandomPowerUp()
        }

        var removedCount = 0
        for crystal in matches {
            crystals[crystal.row][crystal.column] = nil
            crystal.animateDestroy {
                removedCount += 1
                if removedCount == matchesCount {
                    completion()
                }
            }
        }
    }
    
    private func dropCrystals(completion: @escaping () -> Void) {
        // First pass: collect all crystals that need to drop
        var crystalsToAnimate: [(crystal: Crystal, targetPosition: CGPoint)] = []

        for col in 0..<boardSize {
            var writeIndex = 0

            for readIndex in 0..<boardSize {
                if let crystal = crystals[readIndex][col] {
                    if writeIndex != readIndex {
                        crystals[readIndex][col] = nil
                        crystals[writeIndex][col] = crystal
                        crystal.row = writeIndex

                        let targetPosition = positionForCrystal(row: writeIndex, col: col)
                        crystalsToAnimate.append((crystal: crystal, targetPosition: targetPosition))
                    }
                    writeIndex += 1
                }
            }
        }

        // If no crystals to animate, complete immediately
        if crystalsToAnimate.isEmpty {
            completion()
            return
        }

        // Second pass: animate all crystals with guaranteed completion
        var animationCount = 0
        let totalAnimations = crystalsToAnimate.count
        var completionCalled = false

        // Timeout safety: Force completion after 1 second if animations don't finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !completionCalled {
                print("⚠️ dropCrystals: Animation timeout, forcing completion")
                completionCalled = true
                completion()
            }
        }

        for item in crystalsToAnimate {
            item.crystal.animateFall(to: item.targetPosition) {
                animationCount += 1
                if animationCount == totalAnimations && !completionCalled {
                    completionCalled = true
                    completion()
                }
            }
        }
    }
    
    private func fillEmptySpaces(completion: @escaping () -> Void) {
        // First, collect all empty positions and create crystals
        var newCrystals: [(crystal: Crystal, targetPosition: CGPoint)] = []

        for col in 0..<boardSize {
            for row in 0..<boardSize {
                if crystals[row][col] == nil {
                    let crystal = createRandomCrystal(at: row, col: col)
                    // Start ABOVE the board so it falls in
                    crystal.position = positionForCrystal(row: boardSize + (boardSize - row), col: col)
                    crystals[row][col] = crystal
                    addChild(crystal)

                    let targetPosition = positionForCrystal(row: row, col: col)
                    newCrystals.append((crystal: crystal, targetPosition: targetPosition))
                }
            }
        }

        // If no crystals to fill, complete immediately
        if newCrystals.isEmpty {
            completion()
            return
        }

        // Now animate all crystals with guaranteed completion
        var animationCount = 0
        let totalAnimations = newCrystals.count
        var completionCalled = false

        // Timeout safety: Force completion after 1 second if animations don't finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !completionCalled {
                print("⚠️ fillEmptySpaces: Animation timeout, forcing completion")
                completionCalled = true
                completion()
            }
        }

        for item in newCrystals {
            item.crystal.animateFall(to: item.targetPosition) {
                animationCount += 1
                if animationCount == totalAnimations && !completionCalled {
                    completionCalled = true
                    completion()
                }
            }
        }
    }
    
    private func removeInitialMatches() {
        let matches = findMatches()
        if !matches.isEmpty {
            for crystal in matches {
                crystals[crystal.row][crystal.column] = nil
                crystal.removeFromParent()
            }
            
            fillEmptySpaces {
                self.removeInitialMatches()
            }
        }
    }
    
    private func checkGameOver() {
        // SAFETY: Always ensure board is complete before checking game over
        forceFillAnyMissingTiles()

        // Don't check moves in timed mode
        if gameMode != .timed && moves <= 0 {
            gameScene?.gameOver(score: score)
        } else if !hasPossibleMoves() {
            gameScene?.gameOver(score: score)
        }
    }

    func handleTimeUp() {
        gameScene?.gameOver(score: score)
    }

    private func levelUp() {
        level += 1
        SoundManager.shared.playSound(.levelUp)
        gameScene?.showPowerUpMessage("Level \(level)!")
        gameScene?.updateUI()

        // Progressive difficulty: as levels increase, scoring multipliers increase
        // In arcade mode, board gradually gets more challenging
        if gameMode == .arcade {
            // Every 3 levels, remove some moves to increase pressure
            if level % 3 == 0 && moves > 15 {
                moves = max(15, moves - 2)
            }

            // Every 5 levels, spawn a celebration power-up
            if level % 5 == 0 {
                spawnRandomPowerUp()
            }
        }
    }
    
    private func hasPossibleMoves() -> Bool {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                guard let crystal = crystals[row][col] else { continue }
                
                let adjacent = [
                    (row - 1, col), (row + 1, col),
                    (row, col - 1), (row, col + 1)
                ]
                
                for (adjRow, adjCol) in adjacent {
                    guard adjRow >= 0 && adjRow < boardSize &&
                          adjCol >= 0 && adjCol < boardSize,
                          let adjCrystal = crystals[adjRow][adjCol] else { continue }
                    
                    swapCrystalsTemporarily(crystal, adjCrystal)
                    let hasMatch = hasMatches()
                    swapCrystalsTemporarily(crystal, adjCrystal)
                    
                    if hasMatch {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func swapCrystalsTemporarily(_ crystal1: Crystal, _ crystal2: Crystal) {
        let tempRow = crystal1.row
        let tempCol = crystal1.column
        
        crystal1.row = crystal2.row
        crystal1.column = crystal2.column
        crystal2.row = tempRow
        crystal2.column = tempCol
        
        crystals[crystal1.row][crystal1.column] = crystal1
        crystals[crystal2.row][crystal2.column] = crystal2
    }
    
    func getScore() -> Int { return score }
    func getMoves() -> Int { return moves }
    func getLevel() -> Int { return level }
    func getHighScore() -> Int { return highScore }

    func getCurrentMission() -> ArcadeMission? {
        guard gameMode == .arcade else { return nil }
        return ArcadeMissionManager.shared.getCurrentMission()
    }

    func setLevel(_ newLevel: Int) {
        level = newLevel
        moves = 30 + (level * 5)
    }

    // MARK: - High Score Management
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }

    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }

    private func checkHighScore() {
        if score > highScore && !hasBeatenHighScore {
            hasBeatenHighScore = true
            highScore = score
            saveHighScore()
            gameScene?.showHighScoreMessage()
        }
    }

    func addScore(_ points: Int) {
        score += points
        checkHighScore()
    }

    // MARK: - Power-Up System
    private func spawnRandomPowerUp() {
        var powerUpTypes: [PowerUp.PowerUpType] = [.extraMoves, .doublePoints, .bombClear]

        // Add time extension for timed mode
        if gameMode == .timed {
            powerUpTypes.append(.timeExtension)
        }

        let randomType = powerUpTypes.randomElement()!

        let powerUp = PowerUp(type: randomType)
        let randomX = CGFloat.random(in: -200...200)
        let randomY = CGFloat.random(in: -150...150)
        powerUp.position = CGPoint(x: randomX, y: randomY)
        powerUp.zPosition = 50

        powerUps.append(powerUp)
        addChild(powerUp)

        // Auto-remove after 10 seconds if not collected
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            if let index = self?.powerUps.firstIndex(where: { $0 === powerUp }) {
                self?.powerUps.remove(at: index)
                powerUp.removeFromParent()
            }
        }
    }

    private func collectPowerUp(_ powerUp: PowerUp) {
        guard let index = powerUps.firstIndex(where: { $0 === powerUp }) else { return }

        powerUps.remove(at: index)
        SoundManager.shared.playSound(.powerUp)
        SoundManager.shared.playSuccessFeedback()

        powerUp.animateCollection { [weak self] in
            guard let self = self else { return }

            switch powerUp.type {
            case .extraMoves:
                self.moves += 5
                self.gameScene?.showPowerUpMessage("+5 Moves!")
            case .doublePoints:
                self.addScore(self.score)
                self.gameScene?.showPowerUpMessage("Points Doubled!")
            case .bombClear:
                self.clearRandomArea()
                self.gameScene?.showPowerUpMessage("Area Cleared!")
            case .timeExtension:
                self.gameScene?.addTime(10)
                self.gameScene?.showPowerUpMessage("+10 Seconds!")
            }

            self.gameScene?.updateUI()
        }
    }

    private func clearRandomArea() {
        let centerRow = Int.random(in: 2...(boardSize - 3))
        let centerCol = Int.random(in: 2...(boardSize - 3))

        var crystalsToClear: Set<Crystal> = []

        for row in (centerRow - 2)...(centerRow + 2) {
            for col in (centerCol - 2)...(centerCol + 2) {
                if let crystal = crystals[row][col] {
                    crystalsToClear.insert(crystal)
                }
            }
        }

        if !crystalsToClear.isEmpty {
            addScore(crystalsToClear.count * 20 * level)
            removeMatches(crystalsToClear) { [weak self] in
                self?.dropCrystals {
                    self?.fillEmptySpaces {
                        // SAFETY: Force fill any missing tiles before processing matches
                        self?.forceFillAnyMissingTiles()
                        self?.processMatches()
                    }
                }
            }
        }
    }

    func addMoves(_ amount: Int) {
        moves += amount
        gameScene?.updateUI()
    }

    func increaseLevel() {
        levelUp()
    }

    // Public method to ensure board is complete - can be called from GameScene
    func ensureBoardComplete() {
        forceFillAnyMissingTiles()
    }

    // MARK: - Scramble Board
    private func scrambleBoard() {
        SoundManager.shared.playSound(.powerUp)
        gameScene?.showPowerUpMessage("No moves! Shuffling...")

        // Collect all crystal types from the board
        var crystalTypes: [Crystal.CrystalType] = []
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if let crystal = crystals[row][col] {
                    crystalTypes.append(crystal.type)
                }
            }
        }

        // Shuffle the types
        crystalTypes.shuffle()

        // Reassign types to crystals with animation
        var index = 0
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if let crystal = crystals[row][col] {
                    let newType = crystalTypes[index]

                    // Animate the change
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    let changeType = SKAction.run {
                        crystal.updateType(newType)
                    }
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let sequence = SKAction.sequence([fadeOut, changeType, fadeIn])
                    crystal.run(sequence)

                    index += 1
                }
            }
        }

        // Check again after scramble to ensure we have moves
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if self?.hasPossibleMoves() == false {
                self?.scrambleBoard()
            }
        }
    }

    // MARK: - Hint System
    func showHint() {
        // Find a valid matching move
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                guard let crystal = crystals[row][col] else { continue }

                let adjacent = [
                    (row - 1, col), (row + 1, col),
                    (row, col - 1), (row, col + 1)
                ]

                for (adjRow, adjCol) in adjacent {
                    guard adjRow >= 0 && adjRow < boardSize &&
                          adjCol >= 0 && adjCol < boardSize,
                          let adjCrystal = crystals[adjRow][adjCol] else { continue }

                    // Temporarily swap to test if it creates a match
                    swapCrystalsTemporarily(crystal, adjCrystal)

                    // Check if either of the swapped crystals is now part of a match
                    let matches = findMatches()
                    let crystal1InMatch = matches.contains(where: { $0.row == crystal.row && $0.column == crystal.column })
                    let crystal2InMatch = matches.contains(where: { $0.row == adjCrystal.row && $0.column == adjCrystal.column })

                    // Swap back
                    swapCrystalsTemporarily(crystal, adjCrystal)

                    // Only show hint if one of the swapped crystals is in the match
                    if crystal1InMatch || crystal2InMatch {
                        print("Hint found: Swap (\(row),\(col)) with (\(adjRow),\(adjCol))")
                        animateHint(crystal)
                        animateHint(adjCrystal)
                        return
                    }
                }
            }
        }

        print("No valid hint found")
    }

    private func animateHint(_ crystal: Crystal) {
        // Stop any existing animations first
        crystal.removeAllActions()

        // Glow animation with color highlight
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.4)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.4)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SKAction.repeat(pulse, count: 3)

        // Add a subtle rotation to make it more noticeable
        let rotateRight = SKAction.rotate(byAngle: 0.1, duration: 0.2)
        let rotateLeft = SKAction.rotate(byAngle: -0.2, duration: 0.4)
        let rotateBack = SKAction.rotate(byAngle: 0.1, duration: 0.2)
        let wiggle = SKAction.sequence([rotateRight, rotateLeft, rotateBack])
        let repeatWiggle = SKAction.repeat(wiggle, count: 3)

        crystal.run(SKAction.group([repeatPulse, repeatWiggle]))
    }
}