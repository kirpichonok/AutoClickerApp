import UIKit

extension UIFont {
    convenience init?(SFProSemiBold size: CGFloat) {
        self.init(name: "SFPro-Semibold", size: size)
    }

    convenience init?(SFProRegular size: CGFloat) {
        self.init(name: "SFPro-Regular", size: size)
    }
}
