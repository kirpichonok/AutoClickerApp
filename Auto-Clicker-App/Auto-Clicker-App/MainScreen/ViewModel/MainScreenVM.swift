import Combine
import Foundation

class MainScreenVM {
    // MARK: - Properties

    /// The point to simulate touches.
    var pointLocation = [CGPoint]() {
        didSet {
            model.generatePoints(with: pointLocation)
        }
    }

    /// The point where the touch should be simulated.
    @MainActor @Published var touches: CGPoint?
    /// The number of displayed pointers.
    @MainActor @Published var numberOfPointers = 2

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

        model.$point
            .assign(to: \.touches, on: self)
            .store(in: &cancellables)

        model.$isGenerating
            .assign(to: \.isGenerating, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Methods

    @MainActor func setNumberOfPointers(_ number: Float) {
        var newNumberOfPointers = Int(number.rounded())
        newNumberOfPointers = min(Self.maxNumberOfPointers, newNumberOfPointers)
        newNumberOfPointers = max(Self.minNumberOfPointers, newNumberOfPointers)
        numberOfPointers = newNumberOfPointers
    }

    func startGenerating() {
        model.generatePoints(with: pointLocation)
    }

    func stopGenerating() {
        model.stopGenerating()
    }
}
