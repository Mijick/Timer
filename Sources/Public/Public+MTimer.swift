//
//  Public+MTimer.swift of Timer
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: - Initialising Timer
public extension MTimer {
    /// Configure the interval for publishing the timer status.
    ///
    /// - Parameters:
    ///   - time: timer status publishing interval
    ///   - tolerance: The amount of time after the scheduled fire date that the timer may fire.
    ///   - currentTime: A binding value that will be updated every **time** interval.
    ///
    /// - WARNING: Use the ``start()``  or ``start(from:to:)-1mvp1`` methods to start the timer.
    func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, currentTime: Binding<MTime>) throws -> MTimer {
        try publish(every: time, tolerance: tolerance) { currentTime.wrappedValue = $0 }
    }
    
    /// Configure the interval for publishing the timer status.
    ///
    /// - Parameters:
    ///   - time: timer status publishing interval
    ///   - tolerance: The amount of time after the scheduled fire date that the timer may fire.
    ///   - completion: A completion block that will be executed every **time** interval
    ///
    /// - WARNING: Use the ``start()`` or  ``start(from:to:)-1mvp1`` method to start the timer.
    func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> () = { _ in }) throws -> MTimer {
        try MTimerValidator.checkRequirementsForInitializingTimer(time)
        setupPublishers(time, tolerance, completion)
        return self
    }
}

// MARK: - Starting Timer
public extension MTimer {
    /**
     Starts the timer using the specified initial values.
     
     - Note: The timer can be run backwards - use any value **to** that is greater than **from**.
     
     ### Up-going timer
     ```swift
         MTimer(.exampleId)
             .start(from: .zero, to: MTime(seconds: 10))
     ```
     
     ### Down-going timer
     ```swift
         MTimer(.exampleId)
             .start(from: MTime(seconds: 10), to: .zero)
     ```
     */
    func start(from startTime: MTime = .zero, to endTime: MTime = .max) throws {
        try start(from: startTime.toTimeInterval(), to: endTime.toTimeInterval())
    }
    
    /**
     Starts the timer using the specified initial values.
     
     - Note: The timer can be run backwards - use any value **to** that is greater than **from**.
     
     ### Up-going timer
     ```swift
         MTimer(.exampleId)
             .start(from: .zero, to: 10)
     ```
     
     ### Down-going timer
     ```swift
         MTimer(.exampleId)
             .start(from: 10, to: .zero)
     ```
     */
    func start(from startTime: TimeInterval = 0, to endTime: TimeInterval = .infinity) throws {
        try MTimerValidator.checkRequirementsForStartingTimer(startTime, endTime, state, timerStatus)
        assignInitialStartValues(startTime, endTime)
        startTimer()
    }
    
    /// Starts the up-going infinity timer
    func start() throws {
        try start(from: .zero, to: .infinity)
    }
}

// MARK: - Stopping Timer
public extension MTimer {
    /// Pause the timer.
    func pause() {
        guard timerStatus == .running else { return }
        pauseTimer()
    }
}

// MARK: - Resuming Timer
public extension MTimer {
    /// Resumes the paused timer.
    func resume() throws {
        try MTimerValidator.checkRequirementsForResumingTimer(callbacks)
        startTimer()
    }
}

// MARK: - Aborting Timer
public extension MTimer {
    /// Stops the timer and resets its current time to the initial value.
    func cancel() {
        resetRunningTime()
        cancelTimer()
    }
}

// MARK: - Aborting Timer
public extension MTimer {
    /// Stops the timer and resets all timer states to default values.
    func reset() {
        resetTimer()
    }
}

// MARK: - Skip Timer
public extension MTimer {
    /// Stops the timer and updates its status to the final state.
    func skip() throws {
        guard timerStatus.isSkippable else { return }
        try MTimerValidator.isCanBeSkipped(timerStatus)
        skipRunningTime()
        finishTimer()
    }
}

// MARK: - Publishing Timer Activity Status
public extension MTimer {
    /// Publishes timer status changes.
    ///  - Note: To configure the interval at which the state of the timer will be published, use method  ``publish(every:tolerance:currentTime:)``
    func onTimerStatusChange(_ action: @escaping (_ timerStatus: MTimerStatus) -> ()) -> MTimer {
        callbacks.onTimerStatusChange = action
        return self
    }
    /// Publishes timer status changes.
    /// - Note: To configure the interval at which the state of the timer will be published, use method  ``publish(every:tolerance:currentTime:)``
    func bindTimerStatus(timerStatus: Binding<MTimerStatus>) -> MTimer {
        onTimerStatusChange { timerStatus.wrappedValue = $0 }
    }
}

// MARK: - Publishing Timer Progress
public extension MTimer {
    /// Publishes timer progress changes.
    /// - Note: To configure the interval at which the timer's progress will be published, use method ``publish(every:tolerance:currentTime:)``
    func onTimerProgressChange(_ action: @escaping (_ progress: Double) -> ()) -> MTimer {
        callbacks.onTimerProgressChange = action
        return self
    }
    /// Publishes timer progress changes.
    /// - Note: To configure the interval at which the timer's progress will be published, use method ``publish(every:tolerance:currentTime:)``
    func bindTimerProgress(progress: Binding<Double>) -> MTimer {
        onTimerProgressChange { progress.wrappedValue = $0 }
    }
}
