import Combine
import Foundation

class MainScreenVM {
    // MARK: - Properties

    /// The point to simulate touches.
    var pointLocation = [CGPoint]()

    /// The point where the touch should be simulated.
    @MainActor @Published var touches: CGPoint?
    /// The number of visible pointers.
    @MainActor @Published var numberOfPointers = 1
    /// The text to display as the set number of visible pointers.
    @MainActor @Published var numberOfPointersText = ""
    /// The text to display as the set number of clicks.
    @MainActor @Published var numberOfClicks = ""
    /// The text to display as the set time interval between clicks.
    @MainActor @Published var intervalTime = ""
    /// Displays whether the model is generating points at the moment.
    @MainActor @Published var isGenerating = false

    /// The string in the address line.
    @MainActor @Published var urlString: String? {
        didSet {
            if let urlString,
               let url = URL(string: urlString) {
                self.url = url
            }
        }
    }

    /// URL address obtained from the user input.
    @MainActor @Published var url: URL?

    /// Handles inputted string data as a URL and broadcasts the result.
    let urlInput = PassthroughSubject<String, Never>()

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

        $numberOfPointers
            .map { String($0) }
            .assign(to: &$numberOfPointersText)

        model.$point
            .assign(to: &$touches)

        model.$isGenerating
            .assign(to: &$isGenerating)

        model.$numberOfClicks
            .map { String($0) }
            .assign(to: &$numberOfClicks)

        model.$intervalTime
            .map { String($0) }
            .assign(to: &$intervalTime)
    }

    // MARK: - Methods

    func startGenerating() {
        model.generatePoints(with: pointLocation)
    }

    func stopGenerating() {
        model.stopGenerating()
    }

    @MainActor func setNumberOfPointers(_ number: Float) {
        var newNumberOfPointers = Int(number.rounded())
        newNumberOfPointers = min(Self.maxNumberOfPointers, newNumberOfPointers)
        newNumberOfPointers = max(Self.minNumberOfPointers, newNumberOfPointers)
        numberOfPointers = newNumberOfPointers
    }

    @MainActor func setNumberOfClicks(_ number: Float) {
        let number = Int(number)
        model.numberOfClicks = number
    }

    @MainActor func setIntervalTime(_ interval: Float) {
        model.intervalTime = Double(Int(interval * 10.0)) / 10
    }
}
