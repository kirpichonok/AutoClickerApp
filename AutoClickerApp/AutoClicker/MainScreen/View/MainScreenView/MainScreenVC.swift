import Combine
import UIKit
import WebKit

final class MainScreenVC: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var startButtonWidth: NSLayoutConstraint!
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

        bindViewModel()
        viewSetup()
        buttonsActionSetup()
        addSubscribers()
        updatePointLocations()
    }

    // MARK: - Overrides

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier {
        case "goToSettings":
            if let viewController = segue.destination as? UINavigationController {
                (viewController.viewControllers.first as? MainScreenSettingsVC)?.viewModel = viewModel
            }

        default:
            break
        }
    }

    // MARK: - Actions

    @objc private func handlePanPointer(_ gesture: UIPanGestureRecognizer) {
        guard let pointerView = gesture.view else {
            return
        }
        let initialCenter = pointerView.center
        let translation = gesture.translation(in: view)

        if gesture.state != .cancelled {
            pointerView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: view)
        } else {
            pointerView.center = initialCenter
        }
        updatePointLocations()
    }

    @objc private func startButtonDidPressed() {
        if viewModel.isGenerating {
            viewModel.stopGenerating()
        } else {
            viewModel.startGenerating()
        }
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

    // MARK: - Private properties

    private var isLoading = false {
        didSet {
            startButtonSetup()
        }
    }

    private func updatePointLocations() {
        viewModel.pointLocation = pointersViews.filter { !$0.isHidden }.map { $0.center }
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
            } else if oldValue < numberOfVisiblePointers {
                for index in oldValue..<numberOfVisiblePointers {
                    pointersViews[index].center = initialPointersCoordinates[index]
                    pointersViews[index].isHidden = false
                }
            }
            updatePointLocations()
        }
    }

    private var buttonWidth: CGFloat {
        viewModel.isGenerating ?
            startButton.frame.height :
            311
    }

    // MARK: - Private methods

    private func startButtonSetup() {
        startButtonWidth.constant = isLoading ? startButton.bounds.height : 211

        var didPressedConfiguration = UIButton.Configuration.borderedProminent()
        didPressedConfiguration.image = UIImage(systemName: .K.stopFillImageName)
        didPressedConfiguration.cornerStyle = .capsule
        didPressedConfiguration.baseBackgroundColor = .systemRed

        var normalConfiguration = UIButton.Configuration.capsuleWithBackground(gradient: Gradient.purple)
        normalConfiguration.image = UIImage(systemName: .K.playFillImageName)
        normalConfiguration.baseForegroundColor = .white

        startButton.configuration = isLoading ? didPressedConfiguration : normalConfiguration
        startButton.setNeedsLayout()
    }

    private func bindViewModel() {
        viewModel.$touches
            .sink { [weak self] point in
                guard let self, let point else { return }

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

        viewModel.$isGenerating
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }

    private func viewSetup() {
        (view as? GradientBackgroundView)?.setGradientBackground(with: Gradient.background)
        startButtonSetup()
        webView.allowsBackForwardNavigationGestures = true
        pointersSetup()
    }

    private func pointersSetup() {
        for (index, pointerView) in pointersViews.enumerated() {
            pointerView.pointerNumber = String(index + 1)
            pointerView.center = initialPointersCoordinates[index]
            pointerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanPointer)))
            pointerView.isHidden = index >= numberOfVisiblePointers
        }
    }

    private func buttonsActionSetup() {
        startButton.addTarget(self, action: #selector(startButtonDidPressed), for: .touchUpInside)
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
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        textFieldView.text = webView.url?.absoluteString
    }
}
