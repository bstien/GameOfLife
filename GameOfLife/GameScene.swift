import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Private properties

    private let cellSize: CGFloat = 5
    private let padding: CGFloat = 1
    private var columns = 0
    private var rows = 0
    private var cellNodes = [[CellNode]]()
    private var livingCells = Set<LivingCell>()

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .secondarySystemBackground

        let viewPort = view.bounds.inset(by: view.safeAreaInsets)

        columns = Int(floor(viewPort.width / cellSize))
        rows = Int(floor(viewPort.height / cellSize))

        let colOuterPadding = viewPort.height.truncatingRemainder(dividingBy: cellSize) / 2
        let rowOuterPadding = viewPort.width.truncatingRemainder(dividingBy: cellSize)

        cellNodes = Array(repeating: [], count: columns)
        let sideSize = cellSize - (padding * 2)
        for column in (0..<columns) {
            for row in (0..<rows) {
                let cell = CellNode(livingColor: .white, deadColor: .black)
                cell.anchorPoint = .zero

                cell.size = CGSize(width: sideSize, height: sideSize)
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

        var newLivingCells = Set<LivingCell>()

        for column in (0..<columns) {
            for row in (0..<rows) {
                let cell = cellNodes[column][row]
                let livingNeighbors = countLivingNeighbors(column: column, row: row)

                if cell.isLiving, [2, 3].contains(livingNeighbors) {
                    newLivingCells.insert(LivingCell(x: column, y: row))
                } else if !cell.isLiving, livingNeighbors == 3 {
                    newLivingCells.insert(LivingCell(x: column, y: row))
                }
            }
        }

        updateLivingCells(newCells: newLivingCells)
    }

    // MARK: - Private methods

    private func countLivingNeighbors(column: Int, row: Int) -> Int {
        var livingNeighbors = 0
        for x in (-1...1) {
            for y in (-1...1) {
                // Don't count self.
                if x == 0, y == 0 { continue }

                if livingCells.contains(LivingCell(x: column + x, y: row + y)) {
                    livingNeighbors += 1
                }
            }
        }
        return livingNeighbors
    }

    private func updateLivingCells(newCells: Set<LivingCell>) {
        // Updating cells that are still alive is redundant. Only update those that have changed state.
        let dyingCells = livingCells.subtracting(newCells)
        let bornCells = newCells.subtracting(livingCells)
        livingCells = newCells

        for dyingCell in dyingCells {
            cellNodes[dyingCell.x][dyingCell.y].isLiving = false
        }

        for bornCell in bornCells {
            cellNodes[bornCell.x][bornCell.y].isLiving = true
        }
    }

    private func createInitialCells(columnCount: Int, rowCount: Int, fillPercentage: Int) -> Set<LivingCell> {
        let totalCells = columnCount * rowCount
        let numberOfLivingCells = Int(Double(totalCells) * Double(fillPercentage) / 100)

        var livingCells = Set<LivingCell>()
        repeat {
            let xPos = Int.random(in: 0..<columnCount)
            let yPos = Int.random(in: 0..<rowCount)
            livingCells.insert(LivingCell(x: xPos, y: yPos))
        } while (livingCells.count <= numberOfLivingCells)

        return livingCells
    }
}
