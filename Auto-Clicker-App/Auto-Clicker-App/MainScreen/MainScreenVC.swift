import Combine
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

        textFieldView.delegate = self
        webView.navigationDelegate = self

        bindViewModel()
        pointView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardTapped)))
        startButton.addTarget(self, action: #selector(pointDidSet), for: .touchUpInside)
    }

    // MARK: - View Private Methods

    private func bindViewModel() {
        viewModel.$touches
            .sink { [weak self] point in
                guard let self, let point else {
                    return
                }

                let touchPointInWebView = webView.convert(point, from: view)
                simulateTouchAt(point: touchPointInWebView)
            }
            .store(in: &cancellables)

        viewModel.$urlString
            .assign(to: \.text, on: textFieldView)
            .store(in: &cancellables)

        viewModel.$url
            .sink { [weak self] url in
                if let self, let url {
                    webView.load(URLRequest(url: url))
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func insertGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = Gradient.background
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc private func handleCardTapped(_ gesture: UIPanGestureRecognizer) {
        if let pointView = gesture.view {
            let point = gesture.translation(in: view)

            pointView.center = CGPoint(x: pointView.center.x + point.x, y: pointView.center.y + point.y)
            gesture.setTranslation(CGPoint.zero, in: view)
        }
    }

    @objc private func pointDidSet() {
        viewModel.pointLocation = pointView.center
    }

    private func simulateTouchAt(point: CGPoint) {
        webView.evaluateJavaScript("document.elementFromPoint(\(point.x), \(point.y)).click();") { _, _ in
            print("clicked on \(point)")
        }
    }

    // MARK: - Private Property

    private var cancellables = Set<AnyCancellable>()
    private var viewModel = MainScreenVM()
}

// MARK: - UITextFieldDelegate

extension MainScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let urlString = textField.text,
           !urlString.isEmpty {
            viewModel.urlInput.send(urlString)
        }

        return true
    }
}

// MARK: - WKNavigationDelegate

extension MainScreenVC: WKNavigationDelegate {
    // swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        // swiftlint:enable implicitly_unwrapped_optional
        textFieldView.text = webView.url?.absoluteString
    }
}
