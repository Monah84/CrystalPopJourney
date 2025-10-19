import Foundation

enum GameMode {
    case classic        // Standard mode with moves
    case timed         // Time-based mode with countdown
    case arcade        // Endless mode with increasing difficulty
    case challenge     // Progressive levels with goals

    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .timed: return "Timed"
        case .arcade: return "Arcade"
        case .challenge: return "Challenge"
        }
    }

    var description: String {
        switch self {
        case .classic:
            return "Match crystals with limited moves"
        case .timed:
            return "Race against the clock!"
        case .arcade:
            return "Complete missions to earn bonus moves"
        case .challenge:
            return "Complete levels with specific goals"
        }
    }

    var icon: String {
        switch self {
        case .classic: return "🎮"
        case .timed: return "⏱️"
        case .arcade: return "🕹️"
        case .challenge: return "🏆"
        }
    }

    var startingMoves: Int {
        switch self {
        case .classic: return 30
        case .timed: return 999 // Unlimited moves in timed mode
        case .arcade: return 20
        case .challenge: return 25
        }
    }

    var startingTime: Int? {
        switch self {
        case .timed: return 60 // 60 seconds
        default: return nil
        }
    }

    var hasLevels: Bool {
        switch self {
        case .classic, .arcade:
            return false
        case .timed, .challenge:
            return true
        }
    }
}

class GameModeManager {
    static let shared = GameModeManager()

    private var currentMode: GameMode = .classic
    private var highScores: [GameMode: Int] = [:]

    private init() {
        loadHighScores()
    }

    func setCurrentMode(_ mode: GameMode) {
        currentMode = mode
        UserDefaults.standard.set(mode.displayName, forKey: "CurrentGameMode")
    }

    func getCurrentMode() -> GameMode {
        return currentMode
    }

    func getHighScore(for mode: GameMode) -> Int {
        return highScores[mode] ?? 0
    }

    func updateHighScore(for mode: GameMode, score: Int) {
        let currentHighScore = highScores[mode] ?? 0
        if score > currentHighScore {
            highScores[mode] = score
            saveHighScores()
        }
    }

    private func loadHighScores() {
        if let data = UserDefaults.standard.data(forKey: "ModeHighScores"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            for (key, value) in decoded {
                switch key {
                case "Classic": highScores[.classic] = value
                case "Timed": highScores[.timed] = value
                case "Arcade": highScores[.arcade] = value
                case "Challenge": highScores[.challenge] = value
                default: break
                }
            }
        }
    }

    private func saveHighScores() {
        var scoresDict: [String: Int] = [:]
        for (mode, score) in highScores {
            scoresDict[mode.displayName] = score
        }

        if let encoded = try? JSONEncoder().encode(scoresDict) {
            UserDefaults.standard.set(encoded, forKey: "ModeHighScores")
        }
    }

    func resetHighScores() {
        highScores = [:]
        saveHighScores()
    }
}
