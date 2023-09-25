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




private extension MTimer {
    func handleTimer(start: Bool) {
        isTimerRunning = start
        updateInternalTimer(start)
        updateObservers(start)
        publishTimerStatusChange()
    }
}
private extension MTimer {
    func updateInternalTimer(_ start: Bool) { DispatchQueue.main.async { [self] in switch start {
        case true: internalTimer = .scheduledTimer(withTimeInterval: publisherTime, repeats: true, block: aaaa)
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
private extension MTimer {
    func aaaa(_ t: Timer) {
        let newTime = runningTime + publisherTime * timeIncrementMultiplier


        let test = (newTime - initialTime.end) * timeIncrementMultiplier
        if test >= 0 {
            onRunningTimeChange(initialTime.end)
            handleTimer(start: false)
            return
        }

        runningTime = newTime
        onRunningTimeChange(runningTime)
    }
}



// MARK: - Notification Center
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
        if isTimerRunning {
            let newTime = max(0, runningTime + Date().timeIntervalSince(backgroundTransitionDate!) * timeIncrementMultiplier)

            let test = (newTime - initialTime.end) * timeIncrementMultiplier
            if test >= 0 {
                onRunningTimeChange(initialTime.end)
                handleTimer(start: false)
                return
            }


            runningTime = newTime

            onRunningTimeChange(runningTime)

            handleTimer(start: true)
        }

        backgroundTransitionDate = nil
    }
}





private extension MTimer {

}




private extension MTimer {
    var timeIncrementMultiplier: Double { initialTime.start > initialTime.end ? -1 : 1 }
}





// MARK: - Timer Controls
extension MTimer {
    public static func resume() throws {
        guard shared.onRunningTimeChange != nil else { throw Error.cannotResumeNotInitialisedTimer }

        shared.handleTimer(start: true)
    }
    public static func stop() {
        shared.handleTimer(start: false)
    }
    public static func reset() {
        shared.runningTime = shared.initialTime.start
        shared.onRunningTimeChange(shared.runningTime)
    }
}
