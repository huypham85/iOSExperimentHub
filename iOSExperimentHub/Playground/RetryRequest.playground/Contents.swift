import Combine
import Foundation

enum MyError: Error {
    case unknown
}

let url = URL(string: "https://example.comm")!

let cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .mapError { error -> Error in
        print("retrying ...")
        if let urlError = error as? URLError, urlError.code == .networkConnectionLost {
            print("networkConnectionLost ...")
            return urlError
        } else {
            print("unknown ...")
            return MyError.unknown
        }
    }
    .retry(3)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Request completed successfully.")
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
    }, receiveValue: { value in
        print("Received value: \(value)")
    })

// replace error
let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .replaceError(with: Data())
