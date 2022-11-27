import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Private properties

    private let cellSize: CGFloat = 8
    private let padding: CGFloat = 2
    private var columns = 0
    private var rows = 0
    private var cellNodes = [[CellNode]]()
    private var livingCells = Set<CellPosition>()

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .secondarySystemBackground

        let viewPort = view.bounds.inset(by: view.safeAreaInsets)

        columns = Int(floor(viewPort.width / cellSize))
        rows = Int(floor(viewPort.height / cellSize))

        let colOuterPadding = viewPort.height.truncatingRemainder(dividingBy: cellSize) / 2
        let rowOuterPadding = viewPort.width.truncatingRemainder(dividingBy: cellSize) / 2

        cellNodes = Array(repeating: [], count: columns)
        for column in (0..<columns) {
            for row in (0..<rows) {
                let cell = CellNode(
                    cellPosition: CellPosition(column: column, row: row),
                    backgroundColor: .secondarySystemBackground,
                    padding: padding,
                    livingColor: .white,
                    deadColor: .black
                )

                cell.anchorPoint = .zero
                cell.size = CGSize(width: cellSize, height: cellSize)
                cell.position = CGPoint(
                    x: (CGFloat(column) * cellSize) + rowOuterPadding,
                    y: (CGFloat(row) * cellSize) + colOuterPadding
                )

                cellNodes[column].append(cell)
                addChild(cell)
            }
        }

        let livingCells = createInitialCells(columnCount: columns, rowCount: rows, fillPercentage: 30)
        updateLivingCells(newCells: livingCells)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        var newLivingCells = Set<CellPosition>()

        for column in (0..<columns) {
            for row in (0..<rows) {
                let cell = cellNodes[column][row]
                let livingNeighbors = countLivingNeighbors(column: column, row: row)

                if cell.isLiving, [2, 3].contains(livingNeighbors) {
                    newLivingCells.insert(CellPosition(column: column, row: row))
                } else if !cell.isLiving, livingNeighbors == 3 {
                    newLivingCells.insert(CellPosition(column: column, row: row))
                }
            }
        }

        updateLivingCells(newCells: newLivingCells)
    }

    // MARK: - Overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { rebirthCell(at: $0.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { rebirthCell(at: $0.location(in: self)) }
    }

    // MARK: - Private methods

    private func countLivingNeighbors(column: Int, row: Int) -> Int {
        var livingNeighbors = 0
        for x in (-1...1) {
            for y in (-1...1) {
                // Don't count self.
                if x == 0, y == 0 { continue }

                if livingCells.contains(CellPosition(column: column + x, row: row + y)) {
                    livingNeighbors += 1
                }

                // No need to count more neighbors than 4. Those cells will either die or not be rebirthed.
                if livingNeighbors >= 4 {
                    return livingNeighbors
                }
            }
        }
        return livingNeighbors
    }

    private func updateLivingCells(newCells: Set<CellPosition>) {
        // Updating cells that are still alive is redundant. Only update those that have changed state.
        let dyingCells = livingCells.subtracting(newCells)
        let bornCells = newCells.subtracting(livingCells)
        livingCells = newCells

        for dyingCell in dyingCells {
            cellNodes[dyingCell.column][dyingCell.row].isLiving = false
        }

        for bornCell in bornCells {
            cellNodes[bornCell.column][bornCell.row].isLiving = true
        }
    }

    private func rebirthCell(at point: CGPoint) {
        guard let cell = atPoint(point) as? CellNode, !cell.isLiving else { return }
        cell.isLiving = true
        livingCells.insert(cell.cellPosition)
    }

    private func createInitialCells(columnCount: Int, rowCount: Int, fillPercentage: Int) -> Set<CellPosition> {
        let totalCells = columnCount * rowCount
        let numberOfLivingCells = Int(Double(totalCells) * Double(fillPercentage) / 100)

        var livingCells = Set<CellPosition>()
        repeat {
            let column = Int.random(in: 0..<columnCount)
            let row = Int.random(in: 0..<rowCount)
            livingCells.insert(CellPosition(column: column, row: row))
        } while (livingCells.count <= numberOfLivingCells)

        return livingCells
    }
}
