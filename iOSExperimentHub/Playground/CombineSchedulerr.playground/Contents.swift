import Combine
import Foundation

//let immediateScheduler = ImmediateScheduler.shared
//
//let aNum = [1, 2, 3].publisher
//    .receive(on: immediateScheduler)
//    .sink(receiveValue: {
//        print("Received \($0) on thread \(Thread.current)")
//    }
//)
//
//let subject = PassthroughSubject<Int, Never>()
//// 1
//let token = subject.sink(receiveValue: { value in
//    print(Thread.isMainThread)
//})
//// 2
//subject.send(1)
//// 3
//DispatchQueue.global().async {
//    subject.send(2)
//}

//Just(1)
//   .map { _ in print(Thread.isMainThread) }
//   .receive(on: DispatchQueue.global())
//   .map { print(Thread.isMainThread) }
//   .sink { print(Thread.isMainThread) }
//
//Just(1)
//   .subscribe(on: DispatchQueue.global())
//   .map { _ in print(Thread.isMainThread) }
//   .sink { print(Thread.isMainThread) }

//URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.vadimbulavin.com")!)
////   .subscribe(on: DispatchQueue.main) // Subscribe on the main thread
//   .receive(on: DispatchQueue.main)
//   .sink(receiveCompletion: { _ in },
//         receiveValue: { _ in
//           print(Thread.isMainThread) // Are we on the main thread?
//   })

//URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.vadimbulavin.com")!)
//    .subscribe(on: DispatchQueue.main)
//    .receive(on: DispatchQueue.main)
//    .sink(receiveCompletion: { completion in
//        switch completion {
//        case .finished:
//            print("Finished successfully")
//        case .failure(let error):
//            print("Failed with error: \(error)")
//        }
//    },
//          receiveValue: { _, _ in
//        print("Received value on main thread: \(Thread.isMainThread)")
//    })

struct BusyPublisher: Publisher {
    typealias Output = Int
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        sleep(5)
        subscriber.receive(subscription: Subscriptions.empty)
        _ = subscriber.receive(1)
        subscriber.receive(completion: .finished)
    }
}
BusyPublisher()
    .subscribe(on: DispatchQueue.global())
    .receive(on: DispatchQueue.main)
    .sink { _ in print("Received value") }

print("Hello")

let subject = PassthroughSubject<Int, Never>()
// 1
let token = subject.sink(receiveValue: { value in
    print(Thread.isMainThread)
})
// 2
subject.send(1)
// 3
DispatchQueue.global().async {
    subject.send(2)
}

Just(1)
    .subscribe(on: DispatchQueue.global())
    .map { _ in print(Thread.isMainThread) }
    .sink { print(Thread.isMainThread) }
