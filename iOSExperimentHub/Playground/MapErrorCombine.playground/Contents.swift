import Combine
import Foundation

enum MyError: Error {
    case testError
}

enum MappedError: Error {
    case transformedError
}

let publisher = PassthroughSubject<Int, MyError>()

let cancellable = publisher
    .mapError { _ in MappedError.transformedError }
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Publisher completed successfully.")
        case .failure(let error):
            print("Publisher completed with error: \(error)")
        }
    }, receiveValue: { value in
        print("Received value: \(value)")
    })

publisher.send(1)
publisher.send(completion: .failure(.testError))


