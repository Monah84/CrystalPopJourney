import Foundation

class LevelManager {
    static let shared = LevelManager()
    
    struct Level {
        let number: Int
        let targetScore: Int
        let maxMoves: Int
        let difficulty: Difficulty
        let specialCrystals: [Crystal.CrystalType]
        let reward: Int
        
        enum Difficulty {
            case easy, medium, hard, expert
            
            var description: String {
                switch self {
                case .easy: return "Easy"
                case .medium: return "Medium"
                case .hard: return "Hard"
                case .expert: return "Expert"
                }
            }
            
            var multiplier: Float {
                switch self {
                case .easy: return 1.0
                case .medium: return 1.2
                case .hard: return 1.5
                case .expert: return 2.0
                }
            }
        }
    }
    
    private var currentLevel = 1
    private var unlockedLevels: Set<Int> = [1]
    private var levelScores: [Int: Int] = [:]
    private var totalStars = 0
    
    private init() {
        loadProgress()
    }
    
    private func loadProgress() {
        currentLevel = UserDefaults.standard.integer(forKey: "CurrentLevel")
        if currentLevel == 0 { currentLevel = 1 }
        
        if let unlockedData = UserDefaults.standard.data(forKey: "UnlockedLevels"),
           let decoded = try? JSONDecoder().decode(Set<Int>.self, from: unlockedData) {
            unlockedLevels = decoded
        }
        
        if let scoresData = UserDefaults.standard.data(forKey: "LevelScores"),
           let decoded = try? JSONDecoder().decode([Int: Int].self, from: scoresData) {
            levelScores = decoded
        }
        
        totalStars = UserDefaults.standard.integer(forKey: "TotalStars")
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(currentLevel, forKey: "CurrentLevel")
        
        if let encoded = try? JSONEncoder().encode(unlockedLevels) {
            UserDefaults.standard.set(encoded, forKey: "UnlockedLevels")
        }
        
        if let encoded = try? JSONEncoder().encode(levelScores) {
            UserDefaults.standard.set(encoded, forKey: "LevelScores")
        }
        
        UserDefaults.standard.set(totalStars, forKey: "TotalStars")
    }
    
    func generateLevel(_ number: Int) -> Level {
        let baseScore = 1000
        let baseMoves = 30
        
        let difficulty: Level.Difficulty
        switch number {
        case 1...10: difficulty = .easy
        case 11...25: difficulty = .medium
        case 26...50: difficulty = .hard
        default: difficulty = .expert
        }
        
        let targetScore = Int(Float(baseScore + (number * 50)) * difficulty.multiplier)
        let maxMoves = max(20, baseMoves - (number / 5))
        
        let specialCrystals: [Crystal.CrystalType]
        if number <= 5 {
            specialCrystals = Array(Crystal.CrystalType.allCases.prefix(4))
        } else if number <= 15 {
            specialCrystals = Array(Crystal.CrystalType.allCases.prefix(5))
        } else {
            specialCrystals = Crystal.CrystalType.allCases
        }
        
        let reward = 10 + (number * 2)
        
        return Level(
            number: number,
            targetScore: targetScore,
            maxMoves: maxMoves,
            difficulty: difficulty,
            specialCrystals: specialCrystals,
            reward: reward
        )
    }
    
    func completeLevel(_ levelNumber: Int, score: Int) {
        let level = generateLevel(levelNumber)
        let stars = calculateStars(score: score, targetScore: level.targetScore)
        
        if let previousScore = levelScores[levelNumber] {
            if score > previousScore {
                levelScores[levelNumber] = score
                
                let previousStars = calculateStars(score: previousScore, targetScore: level.targetScore)
                let starDifference = stars - previousStars
                totalStars += starDifference
                
                MonetizationManager.shared.awardCoins(level.reward * starDifference)
            }
        } else {
            levelScores[levelNumber] = score
            totalStars += stars
            
            MonetizationManager.shared.awardCoins(level.reward * stars)
        }
        
        if stars > 0 {
            let nextLevel = levelNumber + 1
            unlockedLevels.insert(nextLevel)
            
            if levelNumber == currentLevel {
                currentLevel = nextLevel
            }
        }
        
        saveProgress()
    }
    
    private func calculateStars(score: Int, targetScore: Int) -> Int {
        let percentage = Float(score) / Float(targetScore)
        
        if percentage >= 1.5 {
            return 3
        } else if percentage >= 1.0 {
            return 2
        } else if percentage >= 0.7 {
            return 1
        } else {
            return 0
        }
    }
    
    func isLevelUnlocked(_ levelNumber: Int) -> Bool {
        return unlockedLevels.contains(levelNumber)
    }
    
    func getLevelScore(_ levelNumber: Int) -> Int? {
        return levelScores[levelNumber]
    }
    
    func getLevelStars(_ levelNumber: Int) -> Int {
        guard let score = levelScores[levelNumber] else { return 0 }
        let level = generateLevel(levelNumber)
        return calculateStars(score: score, targetScore: level.targetScore)
    }
    
    func getCurrentLevel() -> Int {
        return currentLevel
    }
    
    func getTotalStars() -> Int {
        return totalStars
    }
    
    func getMaxUnlockedLevel() -> Int {
        return unlockedLevels.max() ?? 1
    }
    
    func resetProgress() {
        currentLevel = 1
        unlockedLevels = [1]
        levelScores = [:]
        totalStars = 0
        saveProgress()
    }
    
    func unlockLevel(_ levelNumber: Int) {
        unlockedLevels.insert(levelNumber)
        saveProgress()
    }
    
    func getProgressPercentage() -> Float {
        let maxLevel = 100
        return Float(currentLevel) / Float(maxLevel) * 100.0
    }
    
    func canSkipLevel(_ levelNumber: Int) -> Bool {
        let cost = 100
        return MonetizationManager.shared.getCoins() >= cost
    }
    
    func skipLevel(_ levelNumber: Int) -> Bool {
        let cost = 100
        guard MonetizationManager.shared.spendCoins(cost) else { return false }
        
        unlockLevel(levelNumber + 1)
        return true
    }
}