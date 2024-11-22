//
//  MTimerConfigurationManager.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

class MTimerConfigurationManager {
    var initialTime: (start: TimeInterval, end: TimeInterval) = (0, 1)
    var publisherTime: TimeInterval = 0
    var publisherTimeTolerance: TimeInterval = 0.4
    var runningTime: TimeInterval = 0
}

extension MTimerConfigurationManager {
    func assignInitialStartValues(_ startTime: TimeInterval, _ endTime: TimeInterval) {
        initialTime = (startTime, endTime)
        runningTime = startTime
    }
    func assignInitialPublisherValues(_ time: TimeInterval, _ tolerance: TimeInterval) {
        publisherTime = time
        publisherTimeTolerance = tolerance
    }
    func resetRunningTime() {
        runningTime = initialTime.start
    }
    func skipRunningTime() {
        runningTime = initialTime.end
    }
    func getPublisherTime() -> TimeInterval {
        publisherTime == 0 ? max(initialTime.start, initialTime.end) : publisherTime
    }
    func calculateNewRunningTime(_ timeChange: Any?) {
        let timeChange = timeChange as? TimeInterval ?? publisherTime
        let newRunningTime = runningTime + timeChange * timeIncrementMultiplier
        runningTime = timeIncrementMultiplier == -1
                    ? max(newRunningTime, initialTime.end)
                    : min(newRunningTime, initialTime.end)
    }
    func calculateTimerProgress() -> Double {
        let timerTotalTime = max(initialTime.start, initialTime.end) - min(initialTime.start, initialTime.end)
        let timerRunningTime = abs(runningTime - initialTime.start)
        return timerRunningTime / timerTotalTime
    }
    func reset() {
        initialTime = (0, 1)
        publisherTime = 0
        publisherTimeTolerance = 0.4
        runningTime = 0
    }
}

extension MTimerConfigurationManager {
    var canTimerBeStarted: Bool { runningTime != initialTime.end }
    var timeIncrementMultiplier: Double { initialTime.start > initialTime.end ? -1 : 1 }
}
