import UIKit
import WebKit

final class MainScreenVC: UIViewController {
    // MARK: - Properties

    @IBOutlet private var startButton: RoundedButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var goForwardButton: UIButton!
    @IBOutlet private var settingsButton: UIButton!
    @IBOutlet private var refreshButton: UIButton!
    @IBOutlet private var pointView: UIImageView!

    @IBOutlet private var textFieldView: RoundedTextField!
    @IBOutlet private var webView: WKWebView!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        insertGradientLayer()
        startButton.setGradientBackground(with: Gradient.purple)
    }

    // MARK: - Private Methods

    private func insertGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = Gradient.background
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
