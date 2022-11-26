import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: - Internal properties

    override var prefersStatusBarHidden: Bool {
        true
    }

    // MARK: - Private properties

    private lazy var sceneView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
        ])

        view.setNeedsLayout()
        view.layoutIfNeeded()

        DispatchQueue.main.async {
            let scene = GameScene(size: self.sceneView.bounds.size)
            scene.scaleMode = .fill

            // Present the scene
            self.sceneView.presentScene(scene)
            self.sceneView.ignoresSiblingOrder = true
            self.sceneView.showsFPS = true
            self.sceneView.showsNodeCount = true
        }
    }
}
