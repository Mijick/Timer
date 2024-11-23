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
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, currentTime: Binding<MTime>) throws -> MTimer {
        try publish(every: time, tolerance: tolerance) { currentTime.wrappedValue = $0 }
    }
    /// Prepares the timer to start.
    /// WARNING: Use the start() method to start the timer.
    func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> ()) throws -> MTimer {
        // TODO: add and test assert instead of throwing error
        try MTimerValidator.checkRequirementsForInitializingTimer(time)
        setupPublishers(time, tolerance, completion)
        return self
    }
}

// MARK: - Starting Timer
public extension MTimer {
    /// Starts the timer using the specified initial values. Can be run backwards - use any "to" value that is greater than  "from".
    func start(from startTime: MTime = .zero, to endTime: MTime = .max) throws {
        try start(from: startTime.toTimeInterval(), to: endTime.toTimeInterval())
    }
    /// Starts the timer using the specified initial values. Can be run backwards - use any "to" value that is greater than  "from".
    func start(from startTime: TimeInterval = 0, to endTime: TimeInterval = .infinity) throws {
        try MTimerValidator.checkRequirementsForStartingTimer(startTime, endTime, state, timerStatus)
        assignInitialStartValues(startTime, endTime)
        startTimer()
    }
    /// Starts the timer.
    func start() throws {
        try start(from: .zero, to: .infinity)
    }
}

// MARK: - Stopping Timer
public extension MTimer {
    /// Pause the timer.
    func pause() {
        pauseTimer()
    }
}

// MARK: - Resuming Timer
public extension MTimer {
    /// Resumes the stopped timer.
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
    /// Stops the timer and resets all timer states to default
    func reset() {
        resetTimer()
    }
}

// MARK: - Skip Timer
public extension MTimer {
    /// Stops the timer and skips it's condition to the final state.
    func skip() {
        skipRunningTime()
        finishTimer()
    }
}

// MARK: - Publishing Timer Activity Status
public extension MTimer {
    /// Publishes the timer activity changes.
    func onTimerActivityChange(_ action: @escaping (_ isRunning: MTimerStatus) -> ()) -> MTimer {
        callbacks.onTimerStatusChange = action
        return self
    }
    /// Publishes the timer activity changes.
    func bindTimerStatus(isTimerRunning: Binding<Bool>) -> MTimer {
        onTimerActivityChange { isTimerRunning.wrappedValue = $0 == .inProgress }
    }
}

// MARK: - Publishing Timer Progress
public extension MTimer {
    /// Publishes the timer progress changes.
    func onTimerProgressChange(_ action: @escaping (_ progress: Double) -> ()) -> MTimer {
        callbacks.onTimerProgressChange = action
        return self
    }
    /// Publishes the timer progress changes.
    func bindTimerProgress(progress: Binding<Double>) -> MTimer {
        onTimerProgressChange { progress.wrappedValue = $0 }
    }
}
