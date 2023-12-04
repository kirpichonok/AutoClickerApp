import UIKit
import WebKit

class MainScreenVC: UIViewController {
    @IBOutlet private var startButton: RoundedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        insertGradientLayer()
        startButton.setGradientBackground(with: Gradient.purple)
    }

    private func insertGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = Gradient.background
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
