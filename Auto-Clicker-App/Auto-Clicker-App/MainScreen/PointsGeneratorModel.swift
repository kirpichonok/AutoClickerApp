import Foundation

final class PointsGeneratorModel {
    // MARK: - Properties

    /// Point to be updated over time.
    @Published private(set) var point: CGPoint?
    @Published private(set) var isGenerating = false

    // MARK: - Private properties

    private var timer: Timer?
    private var coordinates = [CGPoint]()
    private var currentIndex = 0
    private var restNumberOfClicks = 0

    // MARK: - Methods

    /// Generates points with passed coordinates with a certain time interval.
    /// The order of points generating is from the begging to the end of the passed list.
    ///
    /// - Parameters:
    ///  - coordinates: The list of coordinates for the points to be generated.
    ///  - numberOfClicks: The number of tap repetitions at each point.
    ///  - timeInterval: The time interval between two consecutive taps.
    func start(coordinates: [CGPoint], numberOfClicks: Int, timeInterval: Double) {
        guard !coordinates.isEmpty else { return }
        self.coordinates = coordinates
        restNumberOfClicks = numberOfClicks
        isGenerating = true
        timerSetup(with: timeInterval) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            if let point = nextPoint() {
                self.point = point
            } else {
                reset()
            }
        }
    }

    func stop() {
        reset()
    }

    // MARK: -  Private methods

    private func timerSetup(with timeInterval: TimeInterval, handler: @escaping (Timer) -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: true,
                                     block: handler)
    }

    private func reset() {
        timer?.invalidate()
        isGenerating = false
        currentIndex = 0
    }

    private func nextPoint() -> CGPoint? {
        guard !coordinates.isEmpty else {
            return nil
        }
        defer { currentIndex += 1 }

        if !coordinates.indices.contains(currentIndex) {
            currentIndex = 0
            restNumberOfClicks -= 1
        }

        if restNumberOfClicks > 0 {
            return coordinates[currentIndex]
        } else {
            return nil
        }
    }
}
