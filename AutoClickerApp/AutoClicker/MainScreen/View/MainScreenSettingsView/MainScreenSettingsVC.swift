import Combine
import UIKit

final class MainScreenSettingsVC: UIViewController {
    // MARK: - Private properties

    @IBOutlet private var numberOfPointersLabel: UILabel!
    @IBOutlet private var numberOfClicksLabel: UILabel!
    @IBOutlet private var timeIntervalLabel: UILabel!

    @IBOutlet private var numberOfPointersSlider: UISlider!
    @IBOutlet private var numberOfClicksSlider: UISlider!
    @IBOutlet private var timeIntervalSlider: UISlider!

    weak var viewModel: MainScreenVM?
    private let titleFontSize: CGFloat = 18
    private var cancellables = Set<AnyCancellable>()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        bindViewModel()
    }

    // MARK: - Private methods

    @IBAction private func changeNumberOfPoints(_ sender: UISlider) {
        viewModel?.setNumberOfPointers(sender.value)
    }

    @IBAction private func changeNumberOfClicks(_ sender: UISlider) {
        viewModel?.setNumberOfClicks(sender.value)
    }

    @IBAction private func changeTimeInterval(_ sender: UISlider) {
        viewModel?.setTimeInterval(sender.value)
    }

    private func viewSetup() {
        (view.layer as? CAGradientLayer)?.colors = Gradient.background
        sheetPresentationController?.prefersGrabberVisible = true
        navigationBarSetup()
    }

    private func navigationBarSetup() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: .K.xmarkImageName),
                                        style: .plain,
                                        target: self,
                                        action: #selector(dismissScreen))
        rightItem.tintColor = .whiteHalf
        navigationItem.rightBarButtonItem = rightItem

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.whiteApp,
            NSAttributedString.Key.font: UIFont.appSemibold(size: titleFontSize),
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
    }

    @objc private func dismissScreen() {
        dismiss(animated: true)
    }

    private func bindViewModel() {
        viewModel?.$numberOfPointers
            .sink { [weak self] value in
                guard let self else { return }
                numberOfPointersLabel.text = String(value)
                numberOfPointersSlider.value = Float(value)
            }
            .store(in: &cancellables)

        viewModel?.$numberOfClicks
            .sink { [weak self] numberOfClicks in
                guard let self else { return }
                numberOfClicksLabel.text = String(numberOfClicks)
                numberOfClicksSlider.value = Float(numberOfClicks)
            }
            .store(in: &cancellables)

        viewModel?.$timeInterval
            .sink { [weak self] timeInterval in
                guard let self else { return }
                timeIntervalLabel.text = String(timeInterval)
                timeIntervalSlider.value = Float(timeInterval)
            }
            .store(in: &cancellables)
    }
}
