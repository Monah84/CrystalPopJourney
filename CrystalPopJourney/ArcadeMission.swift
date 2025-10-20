import Foundation

struct ArcadeMission {
    let missionNumber: Int
    let objectives: [CrystalObjective]
    let bonusMoves: Int
    let bonusPoints: Int

    struct CrystalObjective {
        let crystalType: Crystal.CrystalType
        let target: Int
        var current: Int = 0

        var isComplete: Bool {
            return current >= target
        }

        var progress: Float {
            return Float(current) / Float(target)
        }

        var description: String {
            return "\(current)/\(target) \(crystalType.name.capitalized)"
        }
    }

    var isComplete: Bool {
        return objectives.allSatisfy { $0.isComplete }
    }

    var progressPercentage: Float {
        let totalProgress = objectives.reduce(0.0) { $0 + $1.progress }
        return totalProgress / Float(objectives.count)
    }
}

class ArcadeMissionManager {
    static let shared = ArcadeMissionManager()

    private var currentMissionNumber: Int = 1
    private var currentObjectives: [ArcadeMission.CrystalObjective] = []

    private init() {
        loadProgress()
    }

    func startNewGame() {
        currentMissionNumber = 1
        currentObjectives = generateMission(number: 1).objectives
        saveProgress()
    }

    // MARK: - Progress Persistence
    func saveProgress() {
        UserDefaults.standard.set(currentMissionNumber, forKey: "ArcadeMissionNumber")

        // Save objectives progress as arrays
        let crystalTypes = currentObjectives.map { $0.crystalType.rawValue }
        let targets = currentObjectives.map { $0.target }
        let currents = currentObjectives.map { $0.current }

        UserDefaults.standard.set(crystalTypes, forKey: "ArcadeObjectiveTypes")
        UserDefaults.standard.set(targets, forKey: "ArcadeObjectiveTargets")
        UserDefaults.standard.set(currents, forKey: "ArcadeObjectiveCurrents")

        print("💾 Arcade progress saved: Mission \(currentMissionNumber)")
    }

    func loadProgress() {
        let savedMission = UserDefaults.standard.integer(forKey: "ArcadeMissionNumber")

        // If no saved progress, start fresh
        guard savedMission > 0,
              let crystalTypes = UserDefaults.standard.array(forKey: "ArcadeObjectiveTypes") as? [String],
              let targets = UserDefaults.standard.array(forKey: "ArcadeObjectiveTargets") as? [Int],
              let currents = UserDefaults.standard.array(forKey: "ArcadeObjectiveCurrents") as? [Int],
              crystalTypes.count == targets.count && targets.count == currents.count else {
            print("💾 No saved arcade progress found, starting fresh")
            currentMissionNumber = 1
            currentObjectives = []
            return
        }

        currentMissionNumber = savedMission

        // Restore objectives
        currentObjectives = []
        for i in 0..<crystalTypes.count {
            if let type = Crystal.CrystalType(rawValue: crystalTypes[i]) {
                var objective = ArcadeMission.CrystalObjective(
                    crystalType: type,
                    target: targets[i]
                )
                objective.current = currents[i]
                currentObjectives.append(objective)
            }
        }

        print("💾 Arcade progress loaded: Mission \(currentMissionNumber) with \(currentObjectives.count) objectives")
    }

    func getCurrentMission() -> ArcadeMission {
        return ArcadeMission(
            missionNumber: currentMissionNumber,
            objectives: currentObjectives,
            bonusMoves: calculateBonusMoves(),
            bonusPoints: calculateBonusPoints()
        )
    }

    func recordCrystalDestroyed(_ type: Crystal.CrystalType) {
        var progressChanged = false
        for i in 0..<currentObjectives.count {
            if currentObjectives[i].crystalType == type && !currentObjectives[i].isComplete {
                currentObjectives[i].current += 1
                progressChanged = true
            }
        }
        if progressChanged {
            saveProgress()
        }
    }

    func checkMissionComplete() -> Bool {
        return currentObjectives.allSatisfy { $0.isComplete }
    }

    func advanceToNextMission() -> ArcadeMission {
        currentMissionNumber += 1
        let newMission = generateMission(number: currentMissionNumber)
        currentObjectives = newMission.objectives
        saveProgress()
        return newMission
    }

    private func generateMission(number: Int) -> ArcadeMission {
        let objectives: [ArcadeMission.CrystalObjective]

        // Progressive difficulty - more objectives and higher targets
        switch number {
        case 1:
            // Mission 1: Destroy 10 of one color
            let randomType = Crystal.CrystalType.allCases.randomElement()!
            objectives = [
                ArcadeMission.CrystalObjective(crystalType: randomType, target: 10)
            ]

        case 2:
            // Mission 2: Destroy 15 of one color
            let randomType = Crystal.CrystalType.allCases.randomElement()!
            objectives = [
                ArcadeMission.CrystalObjective(crystalType: randomType, target: 15)
            ]

        case 3:
            // Mission 3: Destroy 8 of two different colors
            let types = Crystal.CrystalType.allCases.shuffled().prefix(2)
            objectives = types.map {
                ArcadeMission.CrystalObjective(crystalType: $0, target: 8)
            }

        case 4:
            // Mission 4: Destroy 12 and 12 of two colors
            let types = Crystal.CrystalType.allCases.shuffled().prefix(2)
            objectives = types.map {
                ArcadeMission.CrystalObjective(crystalType: $0, target: 12)
            }

        case 5:
            // Mission 5: Destroy 10 each of three colors
            let types = Crystal.CrystalType.allCases.shuffled().prefix(3)
            objectives = types.map {
                ArcadeMission.CrystalObjective(crystalType: $0, target: 10)
            }

        case 6:
            // Mission 6: Destroy 20 of one color
            let randomType = Crystal.CrystalType.allCases.randomElement()!
            objectives = [
                ArcadeMission.CrystalObjective(crystalType: randomType, target: 20)
            ]

        case 7...10:
            // Missions 7-10: Mix of 2-3 colors with increasing targets
            let colorCount = number % 2 == 0 ? 2 : 3
            let types = Crystal.CrystalType.allCases.shuffled().prefix(colorCount)
            let baseTarget = 10 + (number - 6) * 2
            objectives = types.map {
                ArcadeMission.CrystalObjective(crystalType: $0, target: baseTarget)
            }

        default:
            // Mission 11+: Challenging missions
            let colorCount = min(number % 3 + 2, 4) // 2-4 colors
            let types = Crystal.CrystalType.allCases.shuffled().prefix(colorCount)
            let baseTarget = 15 + (number - 10)
            objectives = types.enumerated().map { index, type in
                let target = baseTarget + (index * 2)
                return ArcadeMission.CrystalObjective(crystalType: type, target: target)
            }
        }

        return ArcadeMission(
            missionNumber: number,
            objectives: objectives,
            bonusMoves: calculateBonusMoves(),
            bonusPoints: calculateBonusPoints()
        )
    }

    private func calculateBonusMoves() -> Int {
        // Give fewer bonus moves as missions progress
        if currentMissionNumber <= 3 {
            return 15
        } else if currentMissionNumber <= 6 {
            return 12
        } else if currentMissionNumber <= 10 {
            return 10
        } else {
            return 8
        }
    }

    private func calculateBonusPoints() -> Int {
        return 100 * currentMissionNumber
    }

    func reset() {
        currentMissionNumber = 1
        currentObjectives = []
    }
}
