//
//  NotificationCenter++.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


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
