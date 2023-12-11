import UIKit

extension UIView {
    func setGradientBackground(with colors: [CGColor]) {
        if let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = colors
        }
    }
}
