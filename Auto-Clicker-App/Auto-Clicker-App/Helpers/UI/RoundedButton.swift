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

    // MARK: - Method

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func setGradientBackground(with colors: [CGColor]) {
        gradientLayer.colors = colors
        setNeedsLayout()
    }

    // MARK: - Private property

    private let gradientLayer = CAGradientLayer()

    // MARK: - Private method

    private func viewSetup() {
        layer.cornerRadius = bounds.size.height / 2
        clipsToBounds = true
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}
