import SpriteKit

class CellNode: SKSpriteNode {

    // MARK: - Internal properties

    let cellPosition: CellPosition

    var isLiving: Bool = false {
        didSet {
            rectangle.color = currentColor
        }
    }

    override var size: CGSize {
        didSet {
            updateRectangle()
        }
    }

    // MARK: - Private properties

    private let padding: CGFloat
    private let livingColor: SKColor
    private let deadColor: SKColor
    private lazy var rectangle = SKSpriteNode(color: currentColor, size: .zero)

    private var currentColor: SKColor {
        isLiving ? livingColor : deadColor
    }

    // MARK: - Init

    init(
        cellPosition: CellPosition,
        backgroundColor: SKColor,
        padding: CGFloat,
        livingColor: SKColor,
        deadColor: SKColor
    ) {
        self.cellPosition = cellPosition
        self.padding = padding
        self.livingColor = livingColor
        self.deadColor = deadColor
        super.init(texture: nil, color: backgroundColor, size: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addChild(rectangle)
    }

    // MARK: - Private methods

    private func updateRectangle() {
        rectangle.size = CGSize(width: size.width - (padding * 2), height: size.height - (padding * 2))
        rectangle.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
}
