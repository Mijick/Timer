//
//  Public+MTimer.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

// MARK: - Creating New Instance Of Timer
extension MTimer {
    public static func createNewInstance() -> MTimer { .init() }
}

// MARK: - Initialising Timer
extension MTimer {
    public static func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> ()) throws -> MTimer {
        try shared.publish(every: time, tolerance: tolerance, completion)
    }
    public func publish(every time: TimeInterval, tolerance: TimeInterval = 0.4, _ completion: @escaping (_ currentTime: MTime) -> ()) throws -> MTimer {
        try checkRequirementsForInitialisingTimer(time)
        assignInitialPublisherValues(time, tolerance, completion)
        return self
    }
}

// MARK: - Starting Timer
extension MTimer {
    public func start(from startTime: TimeInterval = 0, to endTime: TimeInterval = .infinity) throws {
        try checkRequirementsForStartingTimer(startTime, endTime)
        assignInitialStartValues(startTime, endTime)
        startTimer()
    }
}

// MARK: - Stopping Timer
extension MTimer {
    public static func stop() {
        shared.stop()
    }
    public func stop() {
        stopTimer()
    }
}

// MARK: - Resuming Timer
extension MTimer {
    public static func resume() throws {
        try shared.resume()
    }
    public func resume() throws {
        try checkRequirementsForResumingTimer()
        startTimer()
    }
}

// MARK: - Resetting Timer
extension MTimer {
    public static func reset() {
        shared.reset()
    }
    public func reset() {
        resetRunningTime()
        stopTimer()
    }
}

// MARK: - Publishing Timer Activity Status
extension MTimer {
    public func onTimerActivityChange(_ action: @escaping (_ isRunning: Bool) -> ()) -> MTimer {
        onTimerActivityChange = action
        return self
    }
}
