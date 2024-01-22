import Combine
import Foundation

class MainScreenVM {
    // MARK: - Properties

    /// The point to simulate touches.
    var pointLocation = [CGPoint]()

    /// The point where the touch should be simulated.
    @MainActor @Published private(set) var touches: CGPoint?
    /// The number of visible pointers.
    @MainActor @Published private(set) var numberOfPointers = 1
    /// The text to display as the set number of clicks.
    @Published private(set) var numberOfClicks = 2
    /// The text to display as the set time interval between clicks.
    @Published private(set) var timeInterval: Double = 2.0
    /// Displays whether the model is generating points at the moment.
    @MainActor @Published private(set) var isGenerating = false

    /// The string in the address line.
    @MainActor @Published private(set) var urlString: String? {
        didSet {
            if let urlString,
               let url = URL(string: urlString) {
                self.url = url
            }
        }
    }

    /// URL address obtained from the user input.
    @MainActor @Published private(set) var url: URL?

    /// Handles inputted string data as a URL and broadcasts the result.
    let urlInput = PassthroughSubject<String, Never>()

    // MARK: - Private properties

    private let model = PointsGeneratorModel()
    private var cancellables = Set<AnyCancellable>()

    private static let minNumberOfPointers = 1
    private static let maxNumberOfPointers = 5

    // MARK: - Initialization

    init() {
        urlInput
            .map { urlString in
                if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
                    return "https://" + urlString
                }

                return urlString
            }
            .assign(to: \.urlString, on: self)
            .store(in: &cancellables)

        model.$point
            .assign(to: &$touches)

        model.$isGenerating
            .assign(to: &$isGenerating)
    }

    // MARK: - Methods

    func startGenerating() {
        model.start(coordinates: pointLocation,
                    numberOfClicks: numberOfClicks,
                    timeInterval: timeInterval)
    }

    func stopGenerating() {
        model.stop()
    }

    @MainActor func setNumberOfPointers(_ number: Float) {
        var newNumberOfPointers = Int(number.rounded())
        newNumberOfPointers = min(Self.maxNumberOfPointers, newNumberOfPointers)
        newNumberOfPointers = max(Self.minNumberOfPointers, newNumberOfPointers)
        numberOfPointers = newNumberOfPointers
    }

    @MainActor func setNumberOfClicks(_ number: Float) {
        let number = Int(number)
        numberOfClicks = number
    }

    @MainActor func setTimeInterval(_ interval: Float) {
        timeInterval = Double(Int(interval * 10.0)) / 10
    }
}
