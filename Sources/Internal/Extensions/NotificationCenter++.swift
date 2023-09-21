//
//  NotificationCenter++.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension NotificationCenter {
    static func addAppStateNotifications(_ observer: Any, onDidEnterBackground backgroundNotification: Selector, onWillEnterForeground foregroundNotification: Selector) {
        Self.default.addObserver(observer, selector: (backgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        Self.default.addObserver(observer, selector: (foregroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    static func removeAppStateChangedNotifications(_ observer: Any) {
        Self.default.removeObserver(observer, name: UIApplication.didEnterBackgroundNotification, object: nil)
        Self.default.removeObserver(observer, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
