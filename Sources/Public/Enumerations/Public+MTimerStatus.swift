//
//  Public+MTimerStatus.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

public enum MTimerStatus {
    /// Initial timer status
    /// ## Triggered by methods
    /// - ``MTimer/reset()``
    case notStarted
    
    /// Timer is in a progress
    ///
    /// ## Triggered by methods
    ///  - ``MTimer/start()``
    ///  - ``MTimer/start(from:to:)-1mvp1``
    ///  - ``MTimer/resume()``
    case running
    
    /// Timer is in a paused state
    ///
    ///  ## Triggered by methods
    ///  - ``MTimer/pause()``
    case paused
    
    /// The timer was terminated by running out of time or calling the function
    ///
    /// ## Triggered by methods
    ///  - ``MTimer/skip()``
    case finished
}

extension MTimerStatus {
    var isTimerRunning: Bool { self == .running }
    var isNeededReset: Bool { self == .notStarted || self == .finished }
    var isSkippable: Bool { self == .running || self == .paused }
}
