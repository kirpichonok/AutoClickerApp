import Foundation

final class PointsGeneratorModel {
    // MARK: - Properties

    /// Point to be updated over time.
    @Published private(set) var point: CGPoint?

    private var counter = 3
    private var timeInterval = 2.0
    private var timer: Timer?

    // MARK: - Methods

    /// Generates a certain amount of points with a certain time interval.
    ///
    /// - Parameter coordinates: The coordinate of the point to be generated.
    func generatePoints(with coordinates: CGPoint?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: true) { [weak self] _ in
            guard let self else {
                return
            }
            guard counter > 0 else {
                reset()
                return
            }

            counter -= 1
            point = coordinates
        }
    }

    private func reset() {
        timer?.invalidate()
        counter = 3
    }
}
