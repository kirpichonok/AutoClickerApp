import Combine
import Foundation

class MainScreenVM {
    /// The point to simulate touches.
    var pointLocation: CGPoint? {
        didSet {
            if pointLocation != nil {
                model.generatePoints(with: pointLocation)
            }
        }
    }

    /// The string in the address line.
    @MainActor @Published var urlString: String? {
        didSet {
            if let urlString,
               let url = URL(string: urlString) {
                self.url = url
            }
        }
    }

    /// The point where the touch should be simulated.
    @MainActor @Published var touches: CGPoint?

    /// URL address obtained from the user input.
    @MainActor @Published var url: URL?

    /// Handles inputted string data as a URL and broadcasts the result.
    let urlInput = PassthroughSubject<String, Never>()

    init() {
        urlInput
            .map { urlString in
                if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
                    return "https://" + urlString
                }

                return urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            }
            .assign(to: \.urlString, on: self)
            .store(in: &cancellables)

        model.$point
            .assign(to: \.touches, on: self)
            .store(in: &cancellables)
    }

    private let model = PointsGeneratorModel()
    private var cancellables = Set<AnyCancellable>()
}
