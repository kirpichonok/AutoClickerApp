import Combine
import UIKit
import WebKit

final class MainScreenView: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var goBackButton: UIButton!
    @IBOutlet private var goForwardButton: UIButton!
    @IBOutlet private var settingsButton: UIButton!
    @IBOutlet private var refreshButton: UIButton!
    @IBOutlet private var pointersViews: [PointerView]!
    @IBOutlet private var textFieldView: RoundedTextField!
    @IBOutlet private var webView: WKWebView!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.delegate = self
        webView.navigationDelegate = self

        viewSetup()
        bindViewModel()
        buttonsActionSetup()
        addSubscribers()
    }

    // MARK: - Actions

    @objc private func handlePanPoint(_ gesture: UIPanGestureRecognizer) {
        guard let pointView = gesture.view else {
            return
        }
        let initialCenter = pointView.center
        let translation = gesture.translation(in: view)

        if gesture.state != .cancelled {
            pointView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: view)
        } else {
            pointView.center = initialCenter
        }
    }

    @objc private func pointDidSet() {
        viewModel.pointLocation = pointersViews.filter { !$0.isHidden }.map { $0.center }
    }

    @objc private func goBack() {
        webView.goBack()
    }

    @objc private func goForward() {
        webView.goForward()
    }

    @objc private func reloadPage() {
        webView.reload()
    }

    // MARK: - Private

    private var cancellables = Set<AnyCancellable>()
    private var viewModel = MainScreenVM()
    private let initialPointersCoordinates = [
        CGPoint(x: 140, y: 200),
        CGPoint(x: 90, y: 190),
        CGPoint(x: 100, y: 300),
        CGPoint(x: 200, y: 340),
        CGPoint(x: 230, y: 440),
    ]
    private var numberOfVisiblePointers = 0 {
        didSet {
            if oldValue > numberOfVisiblePointers {
                for index in numberOfVisiblePointers..<oldValue {
                    pointersViews[index].isHidden = true
                }
            }
            else if oldValue < numberOfVisiblePointers {
                for index in oldValue..<numberOfVisiblePointers {
                    pointersViews[index].center = initialPointersCoordinates[index]
                    pointersViews[index].isHidden = false
                }
            }
        }
    }

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

        viewModel.$numberOfPointers
            .assign(to: \.numberOfVisiblePointers, on: self)
            .store(in: &cancellables)
    }

    private func viewSetup() {
        (view as? GradientBackgroundView)?.setGradientBackground(with: Gradient.background)
        startButton.configuration = UIButton.Configuration.capsuleWithBackground(gradient: Gradient.purple)
        webView.allowsBackForwardNavigationGestures = true
        pointersSetup()
    }

    private func pointersSetup() {
        for (index, pointerView) in pointersViews.enumerated() {
            pointerView.pointerNumber = String(index + 1)
            pointerView.center = initialPointersCoordinates[index]
            pointerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanPoint)))
            pointerView.isHidden = true
        }
    }

    private func buttonsActionSetup() {
        startButton.addTarget(self, action: #selector(pointDidSet), for: .touchUpInside)
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        goForwardButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(reloadPage), for: .touchUpInside)
    }

    private func addSubscribers() {
        webView.publisher(for: \.canGoBack)
            .sink { [weak self] canGoBack in
                guard let self else {
                    return
                }
                if canGoBack {
                    self.goBackButton.tintColor = .accent
                } else {
                    self.goBackButton.tintColor = .systemGray
                }
            }
            .store(in: &cancellables)

        webView.publisher(for: \.canGoForward)
            .sink { [weak self] canGoForward in
                guard let self else {
                    return
                }
                if canGoForward {
                    self.goForwardButton.tintColor = .accent
                } else {
                    self.goForwardButton.tintColor = .systemGray
                }
            }
            .store(in: &cancellables)
    }

    private func simulateTouchAt(point: CGPoint) {
        webView.evaluateJavaScript("document.elementFromPoint(\(point.x), \(point.y)).click();") { _, _ in
            print("clicked on \(point)")
        }
    }
}

// MARK: - UITextFieldDelegate

extension MainScreenView: UITextFieldDelegate {
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

extension MainScreenView: WKNavigationDelegate {
    // swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        // swiftlint:enable implicitly_unwrapped_optional
        textFieldView.text = webView.url?.absoluteString
    }
}
