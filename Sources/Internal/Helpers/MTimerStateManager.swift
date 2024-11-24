//
//  MTimerStateManager.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

class MTimerStateManager {
    private var internalTimer: Timer?
    var backgroundTransitionDate: Date? = nil
}

// MARK: Run Timer
extension MTimerStateManager {
    func runTimer(_ configuration: MTimerConfigurationManager, _ target: Any, _ completion: Selector) {
            stopTimer()
            runTimer(target, configuration.getPublisherTime(), completion)
            setTolerance(configuration.publisherTimeTolerance)
            updateInternalTimerStartAddToRunLoop()
    }
}
private extension MTimerStateManager {
    func runTimer(_ target: Any, _ timeInterval: TimeInterval, _ completion: Selector) {
        internalTimer = .scheduledTimer(
            timeInterval: timeInterval,
            target: target,
            selector: completion,
            userInfo: nil,
            repeats: true
        )
    }
    func setTolerance(_ value: TimeInterval) {
       internalTimer?.tolerance = value
    }
    func updateInternalTimerStartAddToRunLoop() {
        #if os(macOS)
        guard let internalTimer = internalTimer else { return }
        RunLoop.main.add(internalTimer, forMode: .common)
        #endif
    }
}

// MARK: Stop Timer
extension MTimerStateManager {
    func stopTimer() {
        internalTimer?.invalidate()
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
