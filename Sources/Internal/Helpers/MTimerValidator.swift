//
//  MTimerValidator.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import Foundation

class MTimerValidator {
    func checkRequirementsForInitializingTimer(_ publisherTime: TimeInterval) throws {
        if publisherTime < 0.001 { throw MTimer.Error.publisherTimeCannotBeLessThanOneMillisecond }
    }
    func checkRequirementsForStartingTimer(_ startTime: TimeInterval, _ endTime: TimeInterval, _ state: MTimerStateManager, _ status: MTimerStatus) throws {
        if startTime < 0 || endTime < 0 { throw MTimer.Error.timeCannotBeLessThanZero }
        if startTime == endTime { throw MTimer.Error.startTimeCannotBeTheSameAsEndTime }
        if status == .inProgress && state.backgroundTransitionDate == nil { throw MTimer.Error.timerIsAlreadyRunning }
    }
    func checkRequirementsForResumingTimer(_ callbacks: MTimerCallbacks) throws {
        if callbacks.onRunningTimeChange == nil { throw MTimer.Error.cannotResumeNotInitialisedTimer }
    }
}
