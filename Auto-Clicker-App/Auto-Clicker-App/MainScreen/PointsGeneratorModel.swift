import Foundation

final class PointsGeneratorModel {
    // MARK: - Properties

    /// Point to be updated over time.
    @Published private(set) var point: CGPoint?
    @Published var numberOfClicks = 3
    @Published var intervalTime = 2.0
    @Published var isGenerating = false

    private var timer: Timer?
    private var coordinates = [CGPoint]()
    private var currentIndex = 0
    private var currentNumberOfClicks = 0

    // MARK: - Methods

    /// Generates points with passed coordinates with a certain time interval.
    /// The order of points generating is from the begging to the end of the passed list.
    ///
    /// - Parameter coordinates: The list of coordinates for the points to be generated.
    func generatePoints(with coordinates: [CGPoint]) {
        guard !coordinates.isEmpty else { return }
        self.coordinates = coordinates
        currentNumberOfClicks = numberOfClicks
        isGenerating = true
        timerSetup(with: intervalTime)
    }

    func stopGenerating() {
        reset()
    }

    private func timerSetup(with _: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: intervalTime,
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

    private func reset() {
        timer?.invalidate()
        isGenerating = false
        numberOfClicks = 3
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
            currentNumberOfClicks -= 1
        }

        if currentNumberOfClicks > 0 {
            return coordinates[currentIndex]
        } else {
            return nil
        }
    }
}
