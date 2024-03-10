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
        #if os(iOS)
        Self.default.addObserver(observer, selector: (backgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        Self.default.addObserver(observer, selector: (foregroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)

        #elseif os(macOS)
        Self.default.addObserver(observer, selector: (backgroundNotification), name: NSApplication.didResignActiveNotification, object: nil)
        Self.default.addObserver(observer, selector: (foregroundNotification), name: NSApplication.willBecomeActiveNotification, object: nil)

        #endif
    }
    static func removeAppStateChangedNotifications(_ observer: Any) {
        #if os(iOS)
        Self.default.removeObserver(observer, name: UIApplication.didEnterBackgroundNotification, object: nil)
        Self.default.removeObserver(observer, name: UIApplication.willEnterForegroundNotification, object: nil)

        #elseif os(macOS)
        Self.default.removeObserver(observer, name: NSApplication.didResignActiveNotification, object: nil)
        Self.default.removeObserver(observer, name: NSApplication.willBecomeActiveNotification, object: nil)
        
        #endif
    }
}
