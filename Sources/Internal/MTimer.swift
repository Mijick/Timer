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
    var publisherTimeTolerance: TimeInterval = 0.4
    var onRunningTimeChange: ((MTime) -> ())!
    var onTimerActivityChange: ((Bool) -> ())?
    var onTimerProgressChange: ((Double) -> ())?

    deinit { internalTimer?.invalidate() }
}


// MARK: - Initialising Timer
extension MTimer {
    func checkRequirementsForInitialisingTimer(_ publisherTime: TimeInterval) throws {
        if publisherTime < 0.001 { throw Error.publisherTimeCannotBeLessThanOneMillisecond }
    }
    func assignInitialPublisherValues(_ time: TimeInterval, _ tolerance: TimeInterval, _ completion: @escaping (MTime) -> ()) {
        publisherTime = time
        publisherTimeTolerance = tolerance
        onRunningTimeChange = completion
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
}


// MARK: - Handling Timer
private extension MTimer {
    func handleTimer(start: Bool) { if !start || canTimerBeStarted {
        isTimerRunning = start
        updateInternalTimer(start)
        updateObservers(start)
        publishTimerStatus()
    }}
}
private extension MTimer {
    func updateInternalTimer(_ start: Bool) { DispatchQueue.main.async { [self] in switch start {
        case true: updateInternalTimerStart()
        case false: updateInternalTimerStop()
    }}}
    func updateObservers(_ start: Bool) { switch start {
        case true: addObservers()
        case false: removeObservers()
    }}
}
private extension MTimer {
    func updateInternalTimerStart() {
        internalTimer = .scheduledTimer(withTimeInterval: publisherTime, repeats: true, block: handleTimeChange)
        internalTimer?.tolerance = publisherTimeTolerance
        updateInternalTimerStartAddToRunLoop()
    }
    func updateInternalTimerStop() { internalTimer?.invalidate() }
}
private extension MTimer {
    /// **CONTEXT**: On macOS, when the mouse is down in a menu item or other tracking loop, the timer will not start.
    /// **DECISION**: Adding a timer the RunLoop seems to fix the issue issue.
    func updateInternalTimerStartAddToRunLoop() {
        #if os(macOS)
        if let internalTimer { RunLoop.main.add(internalTimer, forMode: .common) }
        #endif
    }
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
        handleReturnFromBackgroundWhenTimerIsRunning()
        backgroundTransitionDate = nil
    }
}
private extension MTimer {
    func handleReturnFromBackgroundWhenTimerIsRunning() { if let backgroundTransitionDate, isTimerRunning {
        let timeChange = Date().timeIntervalSince(backgroundTransitionDate)

        handleTimeChange(timeChange)
        resumeTimerAfterReturningFromBackground()
    }}
}
private extension MTimer {
    func resumeTimerAfterReturningFromBackground() { if canTimerBeStarted {
        updateInternalTimer(true)
    }}
}

// MARK: - Publishers
private extension MTimer {
    func publishTimerStatus() {
        publishTimerStatusChange()
        publishRunningTimeChange()
    }
}
private extension MTimer {
    func publishTimerStatusChange() { DispatchQueue.main.async { [self] in
        onTimerActivityChange?(isTimerRunning)
    }}
    func publishRunningTimeChange() { DispatchQueue.main.async { [self] in
        onRunningTimeChange?(.init(timeInterval: runningTime))
        onTimerProgressChange?(calculateTimerProgress())
    }}
}
private extension MTimer {
    func calculateTimerProgress() -> Double {
        let timerTotalTime = max(initialTime.start, initialTime.end) - min(initialTime.start, initialTime.end)
        let timerRunningTime = abs(runningTime - initialTime.start)
        return timerRunningTime / timerTotalTime
    }
}

// MARK: - Others
private extension MTimer {
    var canTimerBeStarted: Bool { runningTime != initialTime.end }
    var timeIncrementMultiplier: Double { initialTime.start > initialTime.end ? -1 : 1 }
}
