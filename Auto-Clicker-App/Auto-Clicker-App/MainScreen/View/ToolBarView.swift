import SwiftUI

final class ToolBarView: UIToolbar {
    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBarItems()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBarItems()
    }

    // MARK: - Private method

    private func setupBarItems() {
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let firstItem = UIBarButtonItem(
            image: UIImage(systemName: .K.chevronLeftImageName),
            style: .plain,
            target: nil,
            action: nil
        )
        let secondItem = UIBarButtonItem(
            image: UIImage(systemName: .K.chevronRightImageName),
            style: .plain,
            target: nil,
            action: nil
        )
        let thirdItem = UIBarButtonItem(
            image: UIImage(systemName: .K.arrowCirclePathImageName),
            style: .plain,
            target: nil,
            action: nil
        )
        let fourthItem = UIBarButtonItem(
            image: UIImage(systemName: .K.scopeImageName),
            style: .plain,
            target: nil,
            action: nil
        )

        items = [
            firstItem,
            spacer,
            secondItem,
            spacer,
            thirdItem,
            spacer,
            fourthItem,
        ]
    }
}

// MARK: - Preview

struct ToolBarViewPreview: PreviewProvider {
    static var previews: some View {
        PreviewContainer(ToolBarView())
    }
}
