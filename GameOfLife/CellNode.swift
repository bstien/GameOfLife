import SpriteKit

class CellNode: SKSpriteNode {
    var isLiving: Bool = false {
        didSet {
            color = isLiving ? livingColor : deadColor
        }
    }

    // MARK: - Private properties

    private let livingColor: SKColor
    private let deadColor: SKColor

    init(livingColor: SKColor, deadColor: SKColor) {
        self.livingColor = livingColor
        self.deadColor = deadColor
        super.init(texture: nil, color: deadColor, size: .zero)
    }

    required init?(coder: NSCoder) { fatalError() }
}
