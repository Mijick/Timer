//
//  Public+MTimerStatus.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

public enum MTimerStatus {
    /// Initial timer state
    /// ## Triggered by methods
    /// - ``MTimer/reset()``
    case notStarted
    
    /// Timer in progress
    ///
    /// ## Triggered by methods
    ///  - ``MTimer/start()``
    ///  - ``MTimer/start(from:to:)-1mvp1``
    ///  - ``MTimer/resume()``
    case inProgress
    
    /// Timer was stopped/cancelled
    ///
    /// ## Triggered by methods
    ///  - ``MTimer/cancel()``
    case cancelled
    
    /// Timer is in a pause
    ///
    ///  ## Triggered by methods
    ///  - ``MTimer/pause()``
    case paused
    
    /// Timer was finished by running out of time or by calling function
    ///
    /// ## Triggered by methods
    ///  - ``MTimer/skip()``
    case finished
}


extension MTimerStatus {
    var isTimerRunning: Bool { self == .inProgress }
    var isNeededReset: Bool { self == .notStarted || self == .finished || self == .cancelled }
    var isSkippable: Bool { self == .inProgress || self == .paused }
    var isCancellable: Bool { self == .inProgress || self == .paused }
}
