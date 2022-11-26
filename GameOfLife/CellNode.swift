import SpriteKit

class CellNode: SKSpriteNode {
    var isLiving: Bool = false {
        didSet {
            color = isLiving ? .white : .black
        }
    }
}
