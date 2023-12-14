import UIKit

extension UIButton.Configuration {
    static func capsuleWithBackground(gradient colors: [CGColor]) -> Self {
        let customView = GradientBackgroundView()
        customView.setGradientBackground(with: colors)
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.background.customView = customView
        return buttonConfiguration
    }
}
