import SpriteKit

class CellNode: SKSpriteNode {
    let cellPosition: CellPosition

    var isLiving: Bool = false {
        didSet {
            color = isLiving ? livingColor : deadColor
        }
    }

    // MARK: - Private properties

    private let livingColor: SKColor
    private let deadColor: SKColor

    init(cellPosition: CellPosition, livingColor: SKColor, deadColor: SKColor) {
        self.cellPosition = cellPosition
        self.livingColor = livingColor
        self.deadColor = deadColor
        super.init(texture: nil, color: deadColor, size: .zero)
    }

    required init?(coder: NSCoder) { fatalError() }
}
