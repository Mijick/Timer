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

// MARK: - Creating New Instance Of Timer
extension MTimer {
    /// Allows to create multiple instances of a timer.
    public static func createNewInstance() -> MTimer { .init() }
}

// MARK: - Initialising Timer
extension MTimer {
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    public static func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> ()) throws -> MTimer {
        try shared.publish(every: time, tolerance: tolerance, completion)
    }
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    public static func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, currentTime: Binding<MTime>) throws -> MTimer {
        try shared.publish(every: time, tolerance: tolerance) { currentTime.wrappedValue = $0 }
    }
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    public func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, currentTime: Binding<MTime>) throws -> MTimer {
        try publish(every: time, tolerance: tolerance) { currentTime.wrappedValue = $0 }
    }
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    public func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> ()) throws -> MTimer {
        try checkRequirementsForInitialisingTimer(time)
        assignInitialPublisherValues(time, tolerance, completion)
        return self
    }
}

// MARK: - Starting Timer
extension MTimer {
    /// Starts the timer using the specified initial values. Can be run backwards - use any "to" value that is greater than  "from".
    public func start(from startTime: MTime = .zero, to endTime: MTime = .max) throws {
        try start(from: startTime.toTimeInterval(), to: endTime.toTimeInterval())
    }
    /// Starts the timer using the specified initial values. Can be run backwards - use any "to" value that is greater than  "from".
    public func start(from startTime: TimeInterval = 0, to endTime: TimeInterval = .infinity) throws {
        try checkRequirementsForStartingTimer(startTime, endTime)
        assignInitialStartValues(startTime, endTime)
        startTimer()
    }
    /// Starts the timer.
    public func start() throws {
        try start(from: .zero, to: .infinity)
    }
}

// MARK: - Stopping Timer
extension MTimer {
    /// Stops the timer.
    public static func stop() {
        shared.stop()
    }
    /// Stops the timer.
    public func stop() {
        stopTimer()
    }
}

// MARK: - Resuming Timer
extension MTimer {
    /// Resumes the stopped timer.
    public static func resume() throws {
        try shared.resume()
    }
    /// Resumes the stopped timer.
    public func resume() throws {
        try checkRequirementsForResumingTimer()
        startTimer()
    }
}

// MARK: - Resetting Timer
extension MTimer {
    /// Stops the timer and resets its current time to the initial value.
    public static func reset() {
        shared.reset()
    }
    /// Stops the timer and resets its current time to the initial value.
    public func reset() {
        resetRunningTime()
        stopTimer()
    }
}

// MARK: - Publishing Timer Activity Status
extension MTimer {
    /// Publishes the timer activity changes.
    public func onTimerActivityChange(_ action: @escaping (_ isRunning: Bool) -> ()) -> MTimer {
        onTimerActivityChange = action
        return self
    }
    /// Publishes the timer activity changes.
    public func bindTimerStatus(isTimerRunning: Binding<Bool>) -> MTimer {
        onTimerActivityChange { isTimerRunning.wrappedValue = $0 }
    }
}

// MARK: - Publishing Timer Progress
extension MTimer {
    /// Publishes the timer progress changes.
    public func onTimerProgressChange(_ action: @escaping (_ progress: Double) -> ()) -> MTimer {
        onTimerProgressChange = action
        return self
    }
    /// Publishes the timer progress changes.
    public func bindTimerProgress(progress: Binding<Double>) -> MTimer {
        onTimerProgressChange { progress.wrappedValue = $0 }
    }
}
