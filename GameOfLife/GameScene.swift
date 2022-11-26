import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .secondarySystemBackground

        let viewPort = view.bounds.inset(by: view.safeAreaInsets)
        let cellSize: CGFloat = 8
        let padding: CGFloat = 1

        let numCols = Int(floor(viewPort.width / cellSize))
        let numRows = Int(floor(viewPort.height / cellSize))

        let colOuterPadding = viewPort.width.truncatingRemainder(dividingBy: cellSize) / 2
        let rowOuterPadding = viewPort.height.truncatingRemainder(dividingBy: cellSize) / 2

        for column in (0..<numCols) {
            for row in (0..<numRows) {
                let cell = SKSpriteNode()
                cell.anchorPoint = .zero
                cell.color = .secondaryLabel

                let sideSize = cellSize - padding
                cell.size = CGSize(width: sideSize, height: sideSize)

                let xPos: CGFloat = (CGFloat(column) * cellSize) + colOuterPadding
                let yPos: CGFloat = (CGFloat(row) * cellSize) + rowOuterPadding
                cell.position = CGPoint(x: xPos, y: yPos)

                addChild(cell)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach {
            let location = $0.location(in: self)
            let node = atPoint(location) as? SKSpriteNode
            node?.color = .red
        }
    }
}
