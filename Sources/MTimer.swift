//
//  MTimer.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public final class MTimer {
    static let shared: MTimer = .init()

    // Current State
    var internalTimer: Timer?
    var isTimerRunning: Bool = false
    var runningTime: TimeInterval = 0
    var backgroundTransitionDate: Date? = nil

    // Configuration
    var initialTime: (start: TimeInterval, end: TimeInterval) = (0, 1)
    var publisherTime: TimeInterval = 0
    var onRunningTimeChange: ((TimeInterval) -> ())!
    var onTimerActivityChange: ((Bool) -> ())?
}


// MARK: - Initialising Timer
extension MTimer {
    static func assignInitialPublisherValues(_ publisherTime: TimeInterval, _ onRunningTimeChange: @escaping (TimeInterval) -> ()) {
        shared.publisherTime = publisherTime
        shared.onRunningTimeChange = onRunningTimeChange
    }
}

// MARK: - Starting Timer
extension MTimer {
    func checkRequirementsForStartingTimer(_ startTime: TimeInterval, _ endTime: TimeInterval) throws {
        if startTime < 0 || endTime < 0 { throw Error.timeCannotBeLessThanZero }
        if startTime == endTime { throw Error.startTimeCannotBeTheSameAsEndTime }

        if isTimerRunning && backgroundTransitionDate == nil { throw Error.timerIsAlreadyRunning }
    }
    func assignInitialStartValues(_ startTime: TimeInterval, _ endTime: TimeInterval) {
        initialTime = (startTime, endTime)
        runningTime = startTime
    }
    func startTimer() { handleTimer(start: true) }
}

// MARK: - Resuming Timer
extension MTimer {
    func checkRequirementsForResumingTimer() throws {
        if onRunningTimeChange == nil { throw Error.cannotResumeNotInitialisedTimer }
    }
}

// MARK: - Stopping Timer
extension MTimer {
    func stopTimer() { handleTimer(start: false) }
}

// MARK: - Resetting Timer
extension MTimer {
    func resetRunningTime() { runningTime = initialTime.start }
    func resetPublishers() {
        publishTimerStatusChange()
        publishRunningTimeChange()
    }
}


// MARK: - Handling Timer
private extension MTimer {
    func handleTimer(start: Bool) { if !start || canTimerBeStarted {
        isTimerRunning = start
        updateInternalTimer(start)
        updateObservers(start)
        publishTimerStatusChange()
    }}
}
private extension MTimer {
    func updateInternalTimer(_ start: Bool) { DispatchQueue.main.async { [self] in switch start {
        case true: internalTimer = .scheduledTimer(withTimeInterval: publisherTime, repeats: true, block: handleTimeChange)
        case false: internalTimer?.invalidate()
    }}}
    func updateObservers(_ start: Bool) { switch start {
        case true: addObservers()
        case false: removeObservers()
    }}
    func publishTimerStatusChange() { DispatchQueue.main.async { [self] in
        onTimerActivityChange?(isTimerRunning)
    }}
}

// MARK: - Handling Time Change
private extension MTimer {
    func handleTimeChange(_ timeChange: Any? = nil) {
        runningTime = calculateNewRunningTime(timeChange as? TimeInterval ?? publisherTime)
        stopTimerIfNecessary()
        publishRunningTimeChange()
    }
}
private extension MTimer {
    func calculateNewRunningTime(_ timeChange: TimeInterval) -> TimeInterval {
        let newRunningTime = runningTime + timeChange * timeIncrementMultiplier
        return timeIncrementMultiplier == -1 ? max(newRunningTime, initialTime.end) : min(newRunningTime, initialTime.end)
    }
    func stopTimerIfNecessary() { if !canTimerBeStarted {
        stopTimer()
    }}
    func publishRunningTimeChange() { DispatchQueue.main.async { [self] in
        onRunningTimeChange(runningTime)
    }}
}

// MARK: - Handling Background Mode
private extension MTimer {
    func addObservers() {
        NotificationCenter.addAppStateNotifications(self, onDidEnterBackground: #selector(didEnterBackgroundNotification), onWillEnterForeground: #selector(willEnterForegroundNotification))
    }
    func removeObservers() {
        NotificationCenter.removeAppStateChangedNotifications(self)
    }
}



private extension MTimer {
    @objc func didEnterBackgroundNotification() {
        internalTimer?.invalidate()
        backgroundTransitionDate = .init()
    }
    @objc func willEnterForegroundNotification() {
        if let backgroundTransitionDate, isTimerRunning {
            let timeChange = Date().timeIntervalSince(backgroundTransitionDate)

            handleTimeChange(timeChange)
            resumeTimerAfterReturningFromBackground()
        }

        backgroundTransitionDate = nil
    }
}
private extension MTimer {
    func resumeTimerAfterReturningFromBackground() { if canTimerBeStarted {
        updateInternalTimer(true)
    }}
}





private extension MTimer {

}




private extension MTimer {
    var canTimerBeStarted: Bool { runningTime != initialTime.end }
    var timeIncrementMultiplier: Double { initialTime.start > initialTime.end ? -1 : 1 }
}
