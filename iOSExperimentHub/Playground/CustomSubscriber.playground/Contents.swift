import Combine

class CustomSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.max(3))
    }

    func receive(_ input: Int) -> Subscribers.Demand {
        print("Value:", input)
        return .max(1)
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completion: \(completion)")
    }
}
let publisher = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher
let subscriber = CustomSubscriber()
publisher.subscribe(subscriber)
