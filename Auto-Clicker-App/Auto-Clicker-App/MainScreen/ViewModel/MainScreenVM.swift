import Combine
import Foundation

class MainScreenVM: ObservableObject {
    /// The point to simulate touches.
    var pointLocation: CGPoint? {
        didSet {
            if pointLocation != nil {
                startTapping()
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
    }

    /// Emits a specified amount of touch simulations with a specified time interval.
    private func startTapping() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: true) { [weak self] timer in
            guard let self else {
                return
            }
            guard counter > 0 else {
                timer.invalidate()
                return
            }

            counter -= 1
            DispatchQueue.main.async {
                self.touches = self.pointLocation
            }
        }
    }

    private var counter = 3
    private var timeInterval = 2.0
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
}
