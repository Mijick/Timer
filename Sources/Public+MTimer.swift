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

// MARK: - Creating Timer
extension MTimer {
    public static func publish(every time: TimeInterval, _ completion: @escaping (_ currentTime: TimeInterval) -> ()) -> MTimer {
        assignInitialPublisherValues(time, completion)
        return shared
    }
}

// MARK: - Basic Control
extension MTimer {
    public func start(from startTime: TimeInterval = 0, to endTime: TimeInterval = .infinity) throws {
        try checkRequirementsForStartingTimer(startTime, endTime)
        assignInitialStartValues(startTime, endTime)
        startTimer()
    }
    public static func resume() throws {
        try shared.checkRequirementsForResumingTimer()
        shared.startTimer()
    }
    public static func stop() {
        shared.stopTimer()
    }
    public static func reset() {
        shared.stopTimer()
        shared.resetRunningTime()
        shared.resetPublishers()
    }
}

// MARK: - Publishing Timer Activity Status
extension MTimer {
    public func onTimerActivityChange(_ action: @escaping (_ isRunning: Bool) -> ()) -> MTimer {
        onTimerActivityChange = action
        return self
    }
}
