//
//  MTimer.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

public final class MTimer: ObservableObject, FactoryInitializable {
    private let state = MTimerStateManager()
    private let configuration = MTimerConfigurationManager()
    private let validator = MTimerValidator()
    
    let callbacks = MTimerCallbacks()
    let id: MTimerID
    
    @Published public private(set) var timerTime: MTime = .init()
    @Published public private(set) var timerState: MTimerStatus = .notStarted
    @Published public private(set) var timerProgress: Double = 0
    
    init(identifier: MTimerID) { self.id = identifier }
}

// MARK: - Initialising Timer
extension MTimer {
    func checkRequirementsForInitializingTimer(_ publisherTime: TimeInterval) throws {
        try validator.checkRequirementsForInitializingTimer(publisherTime)
    }
    func assignInitialPublisherValues(_ time: TimeInterval, _ tolerance: TimeInterval, _ completion: @escaping (MTime) -> ()) {
        configuration.assignInitialPublisherValues(time, tolerance)
        callbacks.onRunningTimeChange = completion
    }
}

// MARK: - Starting Timer
extension MTimer {
    func checkRequirementsForStartingTimer(_ startTime: TimeInterval, _ endTime: TimeInterval) throws {
        try validator.checkRequirementsForStartingTimer(startTime, endTime, state, timerState)
    }
    func assignInitialStartValues(_ startTime: TimeInterval, _ endTime: TimeInterval) {
        configuration.assignInitialStartValues(startTime, endTime)
        resetRunningTime()
        resetTimerPublishers()
    }
    func startTimer() {
        handleTimer(status: .inProgress)
    }
}

// MARK: - Resuming Timer
extension MTimer {
    func checkRequirementsForResumingTimer() throws {
        try validator.checkRequirementsForResumingTimer(callbacks)
    }
}

// MARK: - Timer State Control
extension MTimer {
    func pauseTimer() { handleTimer(status: .paused) }
    func cancelTimer() { handleTimer(status: .cancelled) }
    func finishTimer() { handleTimer(status: .finished) }
}

// MARK: - Reset Timer
extension MTimer {
    func resetTimer() {
        configuration.reset()
        updateInternalTimer(false)
        timerState = .notStarted
        updateObservers(false)
        resetTimerPublishers()
        publishTimerStatus()
    }
}

// MARK: - Running Time Updates
extension MTimer {
    func resetRunningTime() { configuration.resetRunningTime() }
    func skipRunningTime() { configuration.skipRunningTime() }
}

// MARK: - Handling Timer
private extension MTimer {
    func handleTimer(status: MTimerStatus) { if status != .inProgress || configuration.canTimerBeStarted {
        timerState = status
        updateInternalTimer(isTimerRunning)
        updateObservers(isTimerRunning)
        publishTimerStatus()
    }}
}
private extension MTimer {
    func updateInternalTimer(_ start: Bool) {
        switch start {
            case true: updateInternalTimerStart()
            case false: updateInternalTimerStop()
    }}
    func updateObservers(_ start: Bool) {
        switch start {
            case true: addObservers()
            case false: removeObservers()
        }
    }
}
private extension MTimer {
    func updateInternalTimerStart() {
        let publisherTime = configuration.getPublisherTime()
        state.internalTimer = .scheduledTimer(timeInterval: publisherTime,
                                              target: self,
                                              selector: #selector(handleTimeChange),
                                              userInfo: nil,
                                              repeats: true)
        state.internalTimer?.tolerance = configuration.publisherTimeTolerance
        updateInternalTimerStartAddToRunLoop()
    }
    func updateInternalTimerStop() {
        state.internalTimer?.invalidate()
    }
}

private extension MTimer {
    /// **CONTEXT**: On macOS, when the mouse is down in a menu item or other tracking loop, the timer will not start.
    /// **DECISION**: Adding a timer the RunLoop seems to fix the issue issue.
    func updateInternalTimerStartAddToRunLoop() {
        #if os(macOS)
        guard let internalTimer = state.internalTimer else { return }
        RunLoop.main.add(internalTimer, forMode: .common)
        #endif
    }
}

// MARK: - Handling Time Change
private extension MTimer {
    @objc func handleTimeChange(_ timeChange: Any) {
        configuration.calculateNewRunningTime(timeChange)
        stopTimerIfNecessary()
        publishRunningTimeChange()
    }
}
private extension MTimer {
    func stopTimerIfNecessary() { if !configuration.canTimerBeStarted {
        finishTimer()
    }}
}

// MARK: - Handling Background Mode
private extension MTimer {
    func addObservers() {
        NotificationCenter
            .addAppStateNotifications(self,
                                      onDidEnterBackground: #selector(didEnterBackgroundNotification),
                                      onWillEnterForeground: #selector(willEnterForegroundNotification))
    }
    func removeObservers() {
        NotificationCenter.removeAppStateChangedNotifications(self)
    }
}
private extension MTimer {
    @objc func willEnterForegroundNotification() {
        handleReturnFromBackgroundWhenTimerIsRunning()
        state.willEnterForeground()
    }
    @objc func didEnterBackgroundNotification() {
        state.didEnterBackground()
    }
}
private extension MTimer {
    func handleReturnFromBackgroundWhenTimerIsRunning() {
        guard let backgroundTransitionDate = state.backgroundTransitionDate, isTimerRunning else { return }
        let timeChange = Date().timeIntervalSince(backgroundTransitionDate)
        
        handleTimeChange(timeChange)
        resumeTimerAfterReturningFromBackground()
    }
}
private extension MTimer {
    func resumeTimerAfterReturningFromBackground() { if configuration.canTimerBeStarted {
        updateInternalTimer(true)
    }}
}

// MARK: - Publishers
private extension MTimer {
    func publishTimerStatus() {
        publishTimerStatusChange()
        publishRunningTimeChange()
    }
    func resetTimerPublishers() {
        guard isNeededReset else { return }
        timerState = .notStarted
        timerProgress = 0
        timerTime = .init(timeInterval: configuration.initialTime.start)
    }
}

private extension MTimer {
    func publishTimerStatusChange() { DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
        guard let self else { return }
        callbacks.onTimerActivityChange?(timerState)
    }}
    func publishRunningTimeChange() { DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
        guard let self else { return }
        callbacks.onRunningTimeChange?(.init(timeInterval: configuration.runningTime))
        callbacks.onTimerProgressChange?(configuration.calculateTimerProgress())
        timerTime = .init(timeInterval: configuration.runningTime)
        timerProgress = configuration.calculateTimerProgress()
    }}
}

// MARK: - Helpers
private extension MTimer {
    var isTimerRunning: Bool { timerState == .inProgress }
    var isNeededReset: Bool { timerState == .finished || timerState == .cancelled || timerState == .notStarted }
}
