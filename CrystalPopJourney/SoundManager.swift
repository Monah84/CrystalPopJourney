import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    enum SoundEffect {
        case buttonTap, select, match, gameOver, gameStart, levelUp, highScore, powerUp

        var fileName: String {
            switch self {
            case .buttonTap: return "button_tap"
            case .select: return "crystal_select"
            case .match: return "crystal_match"
            case .gameOver: return "game_over"
            case .gameStart: return "game_start"
            case .levelUp: return "level_up"
            case .highScore: return "high_score"
            case .powerUp: return "power_up"
            }
        }

        var frequency: Float {
            switch self {
            case .buttonTap: return 800.0
            case .select: return 600.0
            case .match: return 1000.0
            case .gameOver: return 300.0
            case .gameStart: return 500.0
            case .levelUp: return 1200.0
            case .highScore: return 1500.0
            case .powerUp: return 900.0
            }
        }

        var duration: Float {
            switch self {
            case .buttonTap: return 0.1
            case .select: return 0.15
            case .match: return 0.3
            case .gameOver: return 1.0
            case .gameStart: return 0.5
            case .levelUp: return 0.8
            case .highScore: return 1.2
            case .powerUp: return 0.6
            }
        }
    }
    
    private var audioEngine: AVAudioEngine
    private var soundPlayers: [String: AVAudioPlayer] = [:]
    private var isSoundEnabled = true
    
    private init() {
        audioEngine = AVAudioEngine()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playSound(_ effect: SoundEffect) {
        guard isSoundEnabled else { return }
        
        generateTone(frequency: effect.frequency, duration: effect.duration)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func generateTone(frequency: Float, duration: Float) {
        let sampleRate: Float = 44100
        let samples = Int(sampleRate * duration)
        
        var audioBuffer = [Float]()
        
        for i in 0..<samples {
            let time = Float(i) / sampleRate
            let amplitude: Float = 0.3 * exp(-time * 3.0)
            let sample = amplitude * sin(2.0 * Float.pi * frequency * time)
            audioBuffer.append(sample)
        }
        
        playToneBuffer(audioBuffer, sampleRate: sampleRate)
    }
    
    private func playToneBuffer(_ buffer: [Float], sampleRate: Float) {
        guard !buffer.isEmpty else { return }
        
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: Double(sampleRate), channels: 1)!
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(buffer.count))!
        
        audioBuffer.frameLength = AVAudioFrameCount(buffer.count)
        
        let channelData = audioBuffer.floatChannelData![0]
        for i in 0..<buffer.count {
            channelData[i] = buffer[i]
        }
        
        let playerNode = AVAudioPlayerNode()
        
        if !audioEngine.isRunning {
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
            
            do {
                try audioEngine.start()
            } catch {
                print("Failed to start audio engine: \(error)")
                return
            }
        } else {
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        }
        
        playerNode.play()
        playerNode.scheduleBuffer(audioBuffer, at: nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.audioEngine.detach(playerNode)
            }
        }
    }
    
    func playHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func playSuccessFeedback() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    func playErrorFeedback() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        isSoundEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "SoundEnabled")
    }
    
    func isSoundOn() -> Bool {
        return UserDefaults.standard.bool(forKey: "SoundEnabled")
    }
}