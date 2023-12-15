import Combine
import UIKit

final class MainScreenSettingsView: UIViewController {
    // MARK: - Private properties

    @IBOutlet private var numberOfPointersLabel: UILabel!
    @IBOutlet private var numberOfClicksLabel: UILabel!
    @IBOutlet private var intervalTimeLabel: UILabel!

    @IBOutlet private var numberOfPointersSlider: UISlider!
    @IBOutlet private var numberOfClicksSlider: UISlider!
    @IBOutlet private var intervalTimeSlider: UISlider!

    weak var viewModel: MainScreenVM?
    private let titleFontSize: CGFloat = 18
    private var cancellables = Set<AnyCancellable>()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewSetup()
    }

    // MARK: - Private methods

    @IBAction private func changeNumberOfPoints(_ sender: UISlider) {
        viewModel?.setNumberOfPointers(sender.value)
    }

    @IBAction private func changeNumberOfClicks(_ sender: UISlider) {
        updateNumberOfClicksLabel(with: sender.value)
    }

    @IBAction private func changeIntervalTime(_ sender: UISlider) {
        updateIntervalTimeLabel(with: sender.value)
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
                guard let self else {
                    return
                }
                numberOfPointersSlider.value = Float(value)
                numberOfPointersLabel.text = "\(value)"
            }
            .store(in: &cancellables)
    }

    private func updateNumberOfClicksLabel(with value: Float) {
        let valueToUse = Int(value)
        numberOfClicksLabel.text = "\(valueToUse)"
    }

    private func updateIntervalTimeLabel(with value: Float) {
        let valueToUse = Float(Int(value * 10.0)) / 10
        intervalTimeLabel.text = valueToUse.stringWithoutZeroFraction
    }
}
