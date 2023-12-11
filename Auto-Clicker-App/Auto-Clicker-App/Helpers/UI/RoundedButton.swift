import UIKit

final class RoundedButton: UIButton {
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Private methods

    private func viewSetup() {
        layer.cornerRadius = bounds.size.height / 2
        clipsToBounds = true
    }
}
