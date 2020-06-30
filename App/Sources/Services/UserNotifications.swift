import Foundation
import UIKit.UIApplication
import UserNotifications

protocol UserNotifications: EventsListener {
    func registerNotifications()
    func handleNotification(_ notification: [AnyHashable: Any],
                            completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserNotificationsImpl: NSObject, UserNotifications {
    private let network: NetworkService
    private let dispatcher: EventDispatcher

    init(network: NetworkService, dispatcher: EventDispatcher) {
        self.network = network
        self.dispatcher = dispatcher

        super.init()

        UNUserNotificationCenter.current().delegate = self
    }

    func registerNotifications() {
        let worker = UNUserNotificationCenter.current()

        worker.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {}
            }
        }

        UIApplication.shared.registerForRemoteNotifications()
    }

    fileprivate func registerPushToken(_ token: Data,
                                       completion: @escaping (Result<Void, Error>) -> Void) {
        let formattedToken = token.map { String(format: "%02x", $0) }.joined()
        network.registerPushToken(token: formattedToken, completion: completion)
    }

    func handleNotification(_ notification: [AnyHashable: Any],
                            completion: @escaping (Result<Void, Error>) -> Void) {
        print("\(Date()) - \(notification)")

        guard let type = notification["type"] as? String else {
            completion(.success(Void()))
            return
        }

        switch type {
        case "refresh_accounts":
            dispatcher.dispatchEvent(.backgroundFetch, completion: completion)
        default:
            completion(.success(Void()))
        }
    }
}

extension UserNotificationsImpl: UNUserNotificationCenterDelegate {}

extension UserNotificationsImpl {
    func handleEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        switch event {
        case let .pushToken(token):
            registerPushToken(token, completion: completion)
        default:
            completion(.success(Void()))
        }
    }
}
