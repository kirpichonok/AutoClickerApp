import UIKit

final class GradientBackgroundView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    func setGradientBackground(with colors: [CGColor]) {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }

        gradientLayer.colors = colors
        setNeedsLayout()
    }
}
