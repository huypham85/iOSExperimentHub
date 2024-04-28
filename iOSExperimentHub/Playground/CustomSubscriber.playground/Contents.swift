import Combine

// Define CustomSubscriber as a normal class
class CustomSubscriber {
    var value: Int = 0
}

// Extend CustomSubscriber to conform to the Subscriber protocol
extension CustomSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }

    func receive(_ input: Int) -> Subscribers.Demand {
        self.value = input
        print("Value:", input)
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completion: \(completion)")
    }
}

// Use CustomSubscriber
let publisher = [1, 2, 3, 4, 5].publisher
let subscriber = CustomSubscriber()
publisher.subscribe(subscriber)

