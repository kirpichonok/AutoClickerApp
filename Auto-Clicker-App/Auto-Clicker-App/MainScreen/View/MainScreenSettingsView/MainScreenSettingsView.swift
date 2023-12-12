import UIKit

class MainScreenSettingsView: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var numberOfPointersLabel: UILabel!
    @IBOutlet private var numberOfClicksLabel: UILabel!
    @IBOutlet private var intervalTimeLabel: UILabel!

    @IBOutlet private var numberOfPointersSlider: UISlider!
    @IBOutlet private var numberOfClicksSlider: UISlider!
    @IBOutlet private var intervalTimeSlider: UISlider!

    @IBOutlet private var startButton: UIButton!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }

    // MARK: - Actions

    private func viewSetup() {
        (view.layer as? CAGradientLayer)?.colors = Gradient.background
        startButton.configuration = .capsuleWithBackground(gradient: Gradient.purple)
    }
}
