import SpriteKit
import GameplayKit

class Crystal: SKSpriteNode {
    enum CrystalType: Int, CaseIterable {
        case red = 0, blue, green, yellow, purple, orange
        
        var color: UIColor {
            switch self {
            case .red: return UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
            case .blue: return UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
            case .green: return UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
            case .yellow: return UIColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1.0)
            case .purple: return UIColor(red: 0.8, green: 0.3, blue: 0.8, alpha: 1.0)
            case .orange: return UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
            }
        }
        
        var name: String {
            switch self {
            case .red: return "red"
            case .blue: return "blue"
            case .green: return "green"
            case .yellow: return "yellow"
            case .purple: return "purple"
            case .orange: return "orange"
            }
        }
    }
    
    var type: CrystalType
    var row: Int = 0
    var column: Int = 0
    
    init(type: CrystalType) {
        self.type = type
        
        let texture = SKTexture()
        super.init(texture: texture, color: type.color, size: CGSize(width: 50, height: 50))
        
        self.name = "crystal_\(type.name)"
        
        createCrystalAppearance()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCrystalAppearance() {
        let outerGlow = SKShapeNode(circleOfRadius: 30)
        outerGlow.fillColor = type.color.withAlphaComponent(0.3)
        outerGlow.strokeColor = .clear
        outerGlow.glowWidth = 5
        addChild(outerGlow)
        
        let innerShape = SKShapeNode(rect: CGRect(x: -20, y: -20, width: 40, height: 40), cornerRadius: 8)
        innerShape.fillColor = type.color
        innerShape.strokeColor = UIColor.white.withAlphaComponent(0.8)
        innerShape.lineWidth = 2
        
        let gradient = SKShapeNode(rect: CGRect(x: -18, y: 10, width: 36, height: 15), cornerRadius: 3)
        gradient.fillColor = UIColor.white.withAlphaComponent(0.4)
        gradient.strokeColor = .clear
        innerShape.addChild(gradient)
        
        addChild(innerShape)
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 1
    }
    
    func animateSelection() {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        run(sequence)
        
        let rotateLeft = SKAction.rotate(byAngle: -0.1, duration: 0.05)
        let rotateRight = SKAction.rotate(byAngle: 0.2, duration: 0.1)
        let rotateBack = SKAction.rotate(byAngle: -0.1, duration: 0.05)
        let rotateSequence = SKAction.sequence([rotateLeft, rotateRight, rotateBack])
        run(rotateSequence)
    }
    
    func animateDestroy(completion: @escaping () -> Void) {
        let particles = createExplosionParticles()
        parent?.addChild(particles)
        
        let scaleOut = SKAction.scale(to: 0, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let group = SKAction.group([scaleOut, fadeOut])
        
        run(group) {
            self.removeFromParent()
            completion()
        }
    }
    
    private func createExplosionParticles() -> SKEmitterNode {
        let particles = SKEmitterNode()
        particles.particleTexture = SKTexture()
        particles.particleBirthRate = 50
        particles.numParticlesToEmit = 30
        particles.particleLifetime = 0.8
        particles.particleLifetimeRange = 0.3
        particles.particlePositionRange = CGVector(dx: 30, dy: 30)
        particles.particleSpeed = 100
        particles.particleSpeedRange = 50
        particles.particleAlpha = 0.8
        particles.particleAlphaRange = 0.3
        particles.particleAlphaSpeed = -1.0
        particles.particleScale = 0.3
        particles.particleScaleRange = 0.2
        particles.particleScaleSpeed = -0.3
        particles.particleColor = type.color
        particles.particleColorBlendFactor = 1.0
        particles.position = position
        
        let removeAction = SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.removeFromParent()
        ])
        particles.run(removeAction)
        
        return particles
    }
    
    func animateFall(to newPosition: CGPoint, completion: @escaping () -> Void) {
        let moveAction = SKAction.move(to: newPosition, duration: 0.4)
        moveAction.timingMode = .easeIn

        run(moveAction, completion: completion)
    }

    func updateType(_ newType: CrystalType) {
        type = newType
        name = "crystal_\(newType.name)"

        // Remove old appearance
        removeAllChildren()

        // Recreate appearance with new type
        createCrystalAppearance()
    }
}