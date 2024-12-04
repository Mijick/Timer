//
//  MTimerValidator.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import Foundation

class MTimerValidator {
    static func checkRequirementsForInitializingTimer(_ publisherTime: TimeInterval) throws {
        if publisherTime < 0 { throw MTimerError.publisherTimeCannotBeLessThanZero }
    }
    static func checkRequirementsForStartingTimer(_ startTime: TimeInterval, _ endTime: TimeInterval, _ state: MTimerStateManager, _ status: MTimerStatus) throws {
        if startTime < 0 || endTime < 0 { throw MTimerError.timeCannotBeLessThanZero }
        if startTime == endTime { throw MTimerError.startTimeCannotBeTheSameAsEndTime }
        if status == .running && state.backgroundTransitionDate == nil { throw MTimerError.timerIsAlreadyRunning }
    }
    static func checkRequirementsForResumingTimer(_ callbacks: MTimerCallbacks) throws {
        if callbacks.onRunningTimeChange == nil { throw MTimerError.cannotResumeNotInitialisedTimer }
    }
    static func isCanBeSkipped(_ timerStatus: MTimerStatus) throws {
        if timerStatus == .running || timerStatus == .paused { return }
        throw MTimerError.timerIsNotStarted
    }
}
