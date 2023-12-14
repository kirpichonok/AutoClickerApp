import SwiftUI

final class PointerView: UIView {
    // MARK: - Properties

    var pointerNumber: String? {
        get { pointerNumberLabel.text }
        set {
            pointerNumberLabel.text = newValue
            setNeedsLayout()
        }
    }

    var pointerCenter: CGPoint {
        imageView.center
    }

    // MARK: - Private properties

    private let majorColor = UIColor.systemRed

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center

        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImage(systemName: .K.dotScopeImageName,
                            withConfiguration: UIImage.SymbolConfiguration(
                                font: .preferredFont(forTextStyle: .title1)
                            ))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = majorColor
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var pointerNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appRegular(size: 12)
        label.textColor = majorColor
        label.text = "1"
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    convenience init(pointerNumber: String) {
        self.init()
        self.pointerNumber = pointerNumber
    }

    // MARK: - Override

    // Used for appropriate preview
    override var intrinsicContentSize: CGSize {
        CGSize(width: 30, height: 40)
    }

    // MARK: - Private methods

    private func setupViews() {
        backgroundColor = .clear
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(pointerNumberLabel)
        contentStackView.addArrangedSubview(imageView)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Preview

struct PreviewRepresentedMyView: PreviewProvider {
    static var previews: some View {
        PreviewContainer(PointerView(pointerNumber: "123"))
    }
}
