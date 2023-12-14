import UIKit

extension UIImage {
    /// Returns the scaled version of the image.
    ///
    /// - Parameter size: The size of rectangle in which to draw the image.
    func scaleTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage
    }
}
