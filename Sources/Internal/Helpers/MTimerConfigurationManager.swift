//
//  MTimerConfigurationManager.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

import SwiftUI

class MTimerConfigurationManager {
    private(set) var time: (start: TimeInterval, end: TimeInterval) = (0, 1)
    private(set) var publisherTime: TimeInterval = 0
    private(set) var publisherTimeTolerance: TimeInterval = 0.4
    private(set) var currentTime: TimeInterval = 0
}

// MARK: Getters
extension MTimerConfigurationManager {
    func getPublisherTime() -> TimeInterval {
        publisherTime == 0 ? max(time.start, time.end) : publisherTime
    }
    func getTimerProgress() -> Double {
        let timerTotalTime = max(time.start, time.end) - min(time.start, time.end)
        let timerRunningTime = abs(currentTime - time.start)
        return timerRunningTime / timerTotalTime
    }
}

// MARK: Setters
extension MTimerConfigurationManager {
    func setInitialTime(startTime: TimeInterval, endTime: TimeInterval) {
        time = (startTime, endTime)
        currentTime = startTime
    }
    func setPublishers(time: TimeInterval, tolerance: TimeInterval) {
        publisherTime = time
        publisherTimeTolerance = tolerance
    }
    func setCurrentTimeToStart() {
        currentTime = time.start
    }
    func setCurrentTimeToEnd() {
        currentTime = time.end
    }
    func setNewCurrentTime(_ timeChange: Any?) {
        let timeChange = timeChange as? TimeInterval ?? getPublisherTime()
        let newCurrentTime = currentTime + timeChange * timeIncrementMultiplier
        currentTime = timeIncrementMultiplier == -1
                    ? max(newCurrentTime, time.end)
                    : min(newCurrentTime, time.end)
    }
    func reset() {
        time = (0, 1)
        publisherTime = 0
        publisherTimeTolerance = 0.4
        currentTime = 0
    }
}
private extension MTimerConfigurationManager {
    var timeIncrementMultiplier: Double { time.start > time.end ? -1 : 1 }
}

// MARK: Helpers
extension MTimerConfigurationManager {
    var canTimerBeStarted: Bool { currentTime != time.end }
}
