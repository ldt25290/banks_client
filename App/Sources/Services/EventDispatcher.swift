import Foundation
import UIKit

protocol EventsListener: AnyObject {
    func handleEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void)
}

typealias BackgroundFetchResult = (UIBackgroundFetchResult) -> Void

enum Event {
    case backgroundFetch
}

protocol EventDispatcher: AnyObject {
    func addListener(_ listener: EventsListener)
    func removeListener(_ listener: EventsListener)

    func dispatchEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void)
}

final class EventDispatcherImpl: EventDispatcher {
    private var listenersStorage = NSHashTable<AnyObject>(options: .weakMemory)
    private let listenersQueue = DispatchQueue(label: "banks.event-dispatcher", attributes: .concurrent)

    deinit {
        listenersStorage.removeAllObjects()
    }

    func addListener(_ listener: EventsListener) {
        listenersQueue.async(flags: .barrier) {
            self.listenersStorage.add(listener)
        }
    }

    func removeListener(_ listener: EventsListener) {
        listenersQueue.async(flags: .barrier) {
            self.listenersStorage.remove(listener)
        }
    }

    private var listeners: [EventsListener] {
        var listeners: [EventsListener]?

        listenersQueue.sync {
            listeners = self.listenersStorage.allObjects as? [EventsListener]
        }

        return listeners ?? []
    }

    func dispatchEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let listeners = self.listeners

        guard !listeners.isEmpty else {
            completion(.success(Void()))
            return
        }

        let group = DispatchGroup()

        for listener in listeners {
            group.enter()
            listener.handleEvent(event) { _ in
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(Void()))
        }
    }
}
