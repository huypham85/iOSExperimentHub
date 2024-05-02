import Combine
import UIKit
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
URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://mydomain/image_654")!)
    .map { result -> UIImage in
        return UIImage(data: result.data) ?? UIImage(named: "placeholder-image")!
    }
    .replaceError(with: UIImage(named: "placeholder-image")!)
    .sink(receiveCompletion: { print("received completion: \($0)") }, receiveValue: {print("received auth: \($0)")})
