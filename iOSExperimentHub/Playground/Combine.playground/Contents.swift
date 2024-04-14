import Combine
import Foundation

class ViewModel {
    var name: String = ""
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    deinit {
        print("deinit")
    }
    
    init(publisher: CurrentValueSubject<String, Never>) {
        publisher.assign(to: \.name, on: self).store(in: &cancellable)
    }
}

let publisher = CurrentValueSubject<String, Never>("Test")

var viewModel: ViewModel? = ViewModel(publisher: publisher)
viewModel = nil // the ViewModel object can't be released because upstream publisher hasn't finished
publisher.send(completion: .finished) // finish the publisher, now the ViewModel object is completely released


var cancellables: Set<AnyCancellable> = Set()
let a = Just("Hello, Combine!")

a
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
    .store(in: &cancellables)

