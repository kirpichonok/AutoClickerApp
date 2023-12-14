import UIKit

extension UIFont {
    static func appSemibold(size: CGFloat) -> UIFont? {
        if let font = UIFont(name: "SFPro-Semibold", size: size) {
            return font
        } else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }

    static func appRegular(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFPro-Regular", size: size) {
            return font
        } else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }

    static func appMedium(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFPro-Medium", size: size) {
            return font
        }
        else {
            assertionFailure()
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
}
