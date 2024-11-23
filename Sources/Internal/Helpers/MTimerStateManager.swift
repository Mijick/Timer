//
//  MTimerStateManager.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

class MTimerStateManager {
    var internalTimer: Timer?
    var backgroundTransitionDate: Date? = nil
}

extension MTimerStateManager {
    func runTimer(_ target: Any, _ timeInterval: TimeInterval, _ selector: Selector) { // TODO: create separate func to handle it
        internalTimer = .scheduledTimer(
            timeInterval: timeInterval,
            target: target,
            selector: selector,
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: App State Handle
extension MTimerStateManager {
    func didEnterBackground() {
        internalTimer?.invalidate()
        backgroundTransitionDate = .init()
    }
    func willEnterForeground() {
        backgroundTransitionDate = nil
    }
}
