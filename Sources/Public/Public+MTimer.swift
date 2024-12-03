//
//  Public+MTimer.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialising Timer
public extension MTimer {
    /// Configure the interval at which the timer's status will be published.
    ///
    /// - Parameters:
    ///   - time: the interval of publishing timer state
    ///   - tolerance: The amount of time after the scheduled fire date that the timer may fire.
    ///   - currentTime: Binding value that will be updated every **time** interval
    ///
    /// - WARNING: Use the ``start()``  or ``start(from:to:)-1mvp1`` methods to start the timer.
    func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, currentTime: Binding<MTime>) throws -> MTimer {
        try publish(every: time, tolerance: tolerance) { currentTime.wrappedValue = $0 }
    }
    
    /// Configure the interval at which the timer's status will be published.
    ///
    /// - Parameters:
    ///   - time: the interval of publishing timer state
    ///   - tolerance: The amount of time after the scheduled fire date that the timer may fire.
    ///   - completion: Completion block that will be executed every **time** interval
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
     
     - Note: Can be run backwards - use any  **to** value that is greater than  **from**.
     
     ### Up going timer
     ```swift
         MTimer(.exampleId)
             .start(from: .zero, to: MTime(seconds: 10))
     ```
     
     ### Down going timer
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
     
     - Note: Can be run backwards - use any  **to** value that is greater than  **from**.
     
     ### Up going timer
     ```swift
         MTimer(.exampleId)
             .start(from: .zero, to: 10)
     ```
     
     ### Down going timer
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
    
    /// Starts up going infinity timer
    func start() throws {
        try start(from: .zero, to: .infinity)
    }
}

// MARK: - Stopping Timer
public extension MTimer {
    /// Pause the timer.
    func pause() {
        guard timerStatus == .inProgress else { return }
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
        guard timerStatus.isCancellable else { return }
        resetRunningTime()
        cancelTimer()
    }
}

// MARK: - Aborting Timer
public extension MTimer {
    /// Stops the timer and resets all timer states to default
    func reset() {
        resetTimer()
    }
}

// MARK: - Skip Timer
public extension MTimer {
    /// Stops the timer and updates its status to the final state
    func skip() throws {
        guard timerStatus.isSkippable else { return }
        try MTimerValidator.isCanBeSkipped(timerStatus)
        skipRunningTime()
        finishTimer()
    }
}

// MARK: - Publishing Timer Activity Status
public extension MTimer {
    /// Publishes the timer status changes.
    ///  - Note: To configure the interval at which the timer's status will be published use the method ``publish(every:tolerance:currentTime:)``
    func onTimerStatusChange(_ action: @escaping (_ timerStatus: MTimerStatus) -> ()) -> MTimer {
        callbacks.onTimerStatusChange = action
        return self
    }
    /// Publishes the timer activity changes.
    /// - Note: To configure the interval at which the timer's status will be published use the method ``publish(every:tolerance:currentTime:)``
    func bindTimerStatus(timerStatus: Binding<MTimerStatus>) -> MTimer {
        onTimerStatusChange { timerStatus.wrappedValue = $0 }
    }
}

// MARK: - Publishing Timer Progress
public extension MTimer {
    /// Publishes the timer progress changes.
    /// - Note: To configure the interval at which the timer's progress will be published use the method ``publish(every:tolerance:currentTime:)``
    func onTimerProgressChange(_ action: @escaping (_ progress: Double) -> ()) -> MTimer {
        callbacks.onTimerProgressChange = action
        return self
    }
    /// Publishes the timer progress changes.
    /// - Note: To configure the interval at which the timer's progress will be published use the method ``publish(every:tolerance:currentTime:)``
    func bindTimerProgress(progress: Binding<Double>) -> MTimer {
        onTimerProgressChange { progress.wrappedValue = $0 }
    }
}
