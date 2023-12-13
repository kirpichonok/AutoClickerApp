import UIKit

final class MainScreenSettingsView: UIViewController {
    // MARK: - Private properties

    @IBOutlet private var numberOfPointersLabel: UILabel!
    @IBOutlet private var numberOfClicksLabel: UILabel!
    @IBOutlet private var intervalTimeLabel: UILabel!

    @IBOutlet private var numberOfPointersSlider: UISlider!
    @IBOutlet private var numberOfClicksSlider: UISlider!
    @IBOutlet private var intervalTimeSlider: UISlider!

    private let titleFontSize: CGFloat = 18

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }

    // MARK: - Private methods

    private func viewSetup() {
        (view.layer as? CAGradientLayer)?.colors = Gradient.background
        navigationBarSetup()
    }

    private func navigationBarSetup() {
        let imageView = UIImageView(image: UIImage(systemName: .K.xmarkImageName))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.whiteApp,
            NSAttributedString.Key.font: UIFont.appSemibold(size: titleFontSize),
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
    }
}
