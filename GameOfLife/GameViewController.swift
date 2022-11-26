import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: - Internal properties

    override var prefersStatusBarHidden: Bool {
        true
    }

    // MARK: - Private properties

    private var sceneView: SKView? {
        view as? SKView
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view = SKView()
        view.bounds = UIScreen.main.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .fill

        // Present the scene
        sceneView?.presentScene(scene)
        sceneView?.ignoresSiblingOrder = true
        sceneView?.showsFPS = true
        sceneView?.showsNodeCount = true
        sceneView?.preferredFramesPerSecond = 20
    }
}
