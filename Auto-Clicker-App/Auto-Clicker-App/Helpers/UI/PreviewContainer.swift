import SwiftUI

struct PreviewContainer<T: UIView>: UIViewRepresentable {
    let view: T

    init(_ viewBuilder: @escaping @autoclosure () -> T) {
        view = viewBuilder()
    }

    func makeUIView(context _: Context) -> T {
        return view
    }

    func updateUIView(_ view: T, context _: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
