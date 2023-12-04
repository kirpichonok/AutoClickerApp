import UIKit

class RoundedTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }

    private func viewSetup() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
