//
//  MTimer.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

public final class MTimer: ObservableObject, FactoryInitializable {
    /// Timer time publisher.
    /// - important: The frequency for updating this property can be configured with function ``MTimer/publish(every:tolerance:currentTime:)``
    /// - NOTE: By default, updates are triggered each time the timer status is marked as **finished**
    @Published public private(set) var timerTime: MTime = .init()
    
    /// Timer status publisher.
    @Published public private(set) var timerStatus: MTimerStatus = .notStarted
    
    /// Timer progress publisher.
    /// - important: The frequency for updating this property can be configured with function ``MTimer/publish(every:tolerance:currentTime:)``
    /// - NOTE: By default, updates are triggered each time the timer status is marked as **finished**
    @Published public private(set) var timerProgress: Double = 0
    
    /// Unique id that enables an access to the registered timer from any location.
    public let id: MTimerID
    
    let callbacks = MTimerCallbacks()
    let state = MTimerStateManager()
    let configuration = MTimerConfigurationManager()
    
    init(identifier: MTimerID) { self.id = identifier }
}

// MARK: - Initialising Timer
extension MTimer {
    func setupPublishers(_ time: TimeInterval, _ tolerance: TimeInterval, _ completion: @escaping (MTime) -> ()) {
        configuration.setPublishers(time: time, tolerance: tolerance)
        callbacks.onRunningTimeChange = completion
        resetTimerPublishers()
    }
}

// MARK: - Starting Timer
extension MTimer {
    func assignInitialStartValues(_ startTime: TimeInterval, _ endTime: TimeInterval) {
        configuration.setInitialTime(startTime: startTime, endTime: endTime)
        resetRunningTime()
        resetTimerPublishers()
    }
    func startTimer() {
        handleTimer(status: .running)
    }
}

// MARK: - Timer State Control
extension MTimer {
    func pauseTimer() { handleTimer(status: .paused) }
    func cancelTimer() { handleTimer(status: .notStarted) }
    func finishTimer() { handleTimer(status: .finished) }
}

// MARK: - Reset Timer
extension MTimer {
    func resetTimer() {
        configuration.reset()
        updateInternalTimer(false)
        timerStatus = .notStarted
        updateObservers(false)
        resetTimerPublishers()
        publishTimerStatus()
    }
}

// MARK: - Running Time Updates
extension MTimer {
    func resetRunningTime() { configuration.setCurrentTimeToStart() }
    func skipRunningTime() { configuration.setCurrentTimeToEnd() }
}

// MARK: - Handling Timer
private extension MTimer {
    func handleTimer(status: MTimerStatus) { if status != .running || configuration.canTimerBeStarted {
        timerStatus = status
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
    func updateInternalTimerStart() { state.runTimer(configuration, self, #selector(handleTimeChange)) }
    func updateInternalTimerStop() { state.stopTimer() }
}

// MARK: - Handling Time Change
private extension MTimer {
    @objc func handleTimeChange(_ timeChange: Any) {
        configuration.setNewCurrentTime(timeChange)
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
        timerStatus = .notStarted
        timerProgress = 0
        timerTime = .init(timeInterval: configuration.time.start)
    }
}

private extension MTimer {
    func publishTimerStatusChange() { DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
        guard let self else { return }
        callbacks.onTimerStatusChange?(timerStatus)
    }}
    func publishRunningTimeChange() { DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
        guard let self else { return }
        callbacks.onRunningTimeChange?(.init(timeInterval: configuration.currentTime))
        callbacks.onTimerProgressChange?(configuration.getTimerProgress())
        timerTime = .init(timeInterval: configuration.currentTime)
        timerProgress = configuration.getTimerProgress()
    }}
}

// MARK: - Helpers
private extension MTimer {
    var isTimerRunning: Bool { timerStatus.isTimerRunning }
    var isNeededReset: Bool { timerStatus.isNeededReset }
}
