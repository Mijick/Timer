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
    func didEnterBackground() {
        internalTimer?.invalidate()
        backgroundTransitionDate = .init()
    }
    func willEnterForeground() {
        backgroundTransitionDate = nil
    }
}
