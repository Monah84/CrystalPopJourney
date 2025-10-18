import GameKit
import UIKit

class GameCenterManager: NSObject {
    static let shared = GameCenterManager()

    // Leaderboard ID - Create this in App Store Connect
    private let leaderboardID = "com.monah.crystalpop.highscores"

    var isAuthenticated = false
    var localPlayer: GKLocalPlayer {
        return GKLocalPlayer.local
    }

    private override init() {
        super.init()
    }

    // MARK: - Authentication
    func authenticatePlayer(completion: @escaping (Bool) -> Void) {
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            if let error = error {
                print("Game Center authentication error: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let viewController = viewController {
                // Present the Game Center login view controller
                if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                    rootViewController.present(viewController, animated: true)
                }
                completion(false)
                return
            }

            if self?.localPlayer.isAuthenticated == true {
                print("✅ Game Center authenticated: \(self?.localPlayer.displayName ?? "Player")")
                self?.isAuthenticated = true
                completion(true)
            } else {
                print("⚠️ Game Center not authenticated")
                self?.isAuthenticated = false
                completion(false)
            }
        }
    }

    // MARK: - Leaderboards
    func submitScore(_ score: Int, completion: ((Bool) -> Void)? = nil) {
        guard isAuthenticated else {
            print("Cannot submit score: Not authenticated to Game Center")
            completion?(false)
            return
        }

        // iOS 12-compatible API
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardID)
        scoreReporter.value = Int64(score)

        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
                completion?(false)
            } else {
                print("✅ Score submitted: \(score)")
                completion?(true)
            }
        }
    }

    func showLeaderboard(scope: LeaderboardScope = .global) {
        guard isAuthenticated else {
            print("Cannot show leaderboard: Not authenticated to Game Center")
            return
        }

        // iOS 12-compatible API
        // Note: Game Center UI automatically provides tabs for Global, Friends, and regional rankings
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = .leaderboards
        gcViewController.leaderboardIdentifier = leaderboardID
        gcViewController.leaderboardTimeScope = .allTime

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(gcViewController, animated: true)
        }
    }

    func showAchievements() {
        guard isAuthenticated else {
            print("Cannot show achievements: Not authenticated to Game Center")
            return
        }

        // iOS 12-compatible API
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = .achievements

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(gcViewController, animated: true)
        }
    }

    // MARK: - Player Info
    func getPlayerInfo() -> (displayName: String, isAuthenticated: Bool) {
        return (localPlayer.displayName, isAuthenticated)
    }

    // MARK: - Leaderboard Scopes
    enum LeaderboardScope {
        case global   // All players worldwide
        case friends  // Only Game Center friends
    }
}

// MARK: - Game Center Delegate
extension GameCenterManager: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
