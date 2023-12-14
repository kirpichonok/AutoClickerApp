import Foundation

final class PointsGeneratorModel {
    // MARK: - Properties

    /// Point to be updated over time.
    @Published private(set) var point: CGPoint?
    @Published var isGenerating = false

    private var counter = 3
    private var timeInterval = 2.0
    private var timer: Timer?
    private var coordinates = [CGPoint]()
    private var currentIndex = 0

    // MARK: - Methods

    /// Generates points with passed coordinates with a certain time interval.
    /// The order of points generating is from the begging to the end of the passed list.
    ///
    /// - Parameter coordinates: The list of coordinates for the points to be generated.
    func generatePoints(with coordinates: [CGPoint]) {
        guard !coordinates.isEmpty else { return }
        timer?.invalidate()
        self.coordinates = coordinates
        isGenerating = true

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            if let nextPoint = next() {
                self.point = nextPoint
            } else {
                reset()
            }
        }
    }

    func stopGenerating() {
        reset()
    }

    private func reset() {
        timer?.invalidate()
        isGenerating = false
        counter = 3
        currentIndex = 0
    }

    private func next() -> CGPoint? {
        guard !coordinates.isEmpty else {
            return nil
        }
        defer {
            currentIndex += 1
        }

        if !coordinates.indices.contains(currentIndex) {
            currentIndex = 0
            counter -= 1
        }

        if counter > 0 {
            return coordinates[currentIndex]
        } else {
            return nil
        }
    }
}
