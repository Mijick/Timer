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
    
    deinit { internalTimer?.invalidate() }
}

extension MTimerStateManager {
    func runTimer(_ target: Any, _ timeInterval: TimeInterval, _ selector: Selector) {
        internalTimer = .scheduledTimer(timeInterval: timeInterval,
                                        target: target,
                                        selector: selector,
                                        userInfo: nil,
                                        repeats: true)
    }
    func didEnterBackground() {
        internalTimer?.invalidate()
        backgroundTransitionDate = .init()
    }
    func willEnterForeground() {
        backgroundTransitionDate = nil
    }
}
