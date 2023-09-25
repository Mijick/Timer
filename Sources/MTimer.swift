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

public class MTimer {
    static let shared: MTimer = .init()

    // Current State
    var internalTimer: Timer?
    var runningTime: TimeInterval = 0
    var backgroundTransitionDate: Date? = nil

    // Configuration
    var initialTime: (start: TimeInterval, end: TimeInterval) = (0, 1)
    var publisherTime: TimeInterval = 0
    var onRunningTimeChange: ((TimeInterval) -> ())!
    var onTimerActivityChange: ((Bool) -> ())?
}







private extension MTimer {
    func publishTimerStatusChange() {
        DispatchQueue.main.async { [self] in onTimerActivityChange?(isTimerRunning) }
    }



}



// MARK: - Timer Controls
extension MTimer {
    public static func resume() throws {
        guard shared.onRunningTimeChange != nil else { throw Error.cannotResumeNotInitialisedTimer }

        shared.startTimer()
    }
    public static func stop() {
        shared.stopTimer()
    }
    public static func reset() {
        shared.runningTime = shared.initialTime.start
        shared.onRunningTimeChange(shared.runningTime)
    }
}



extension MTimer {
    public func start(from: TimeInterval = 0, to: TimeInterval = .infinity) throws {
        guard from >= 0,
              to >= 0
        else { throw Error.timeCannotBeLessThanZero }
        guard from != to else { throw Error.startTimeCannotBeTheSameAsEndTime }


        initialTime = (from, to)


        runningTime = from


        startTimer()
    }
    

}
private extension MTimer {
    func startTimer() {
        guard !isTimerRunning || backgroundTransitionDate != nil else { return }



        addObservers()




        DispatchQueue.main.async { [self] in
            internalTimer = .scheduledTimer(withTimeInterval: publisherTime, repeats: true, block: aaaa)

            //RunLoop.current.add(internalTimer, forMode: .common)
        }

        publishTimerStatusChange()
    }
    func stopTimer() {
        internalTimer?.invalidate()
        removeObservers()
        publishTimerStatusChange()
    }
}
private extension MTimer {
    func aaaa(_ t: Timer) {
        let newTime = runningTime + publisherTime * timeIncrementMultiplier


        let test = (newTime - initialTime.end) * timeIncrementMultiplier
        if test >= 0 {
            onRunningTimeChange(initialTime.end)
            stopTimer()
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
                stopTimer()
                return
            }


            runningTime = newTime
        }


        // czy tutaj też musi być running?
        onRunningTimeChange(runningTime)

        startTimer()


        backgroundTransitionDate = nil
    }
}










private extension MTimer {
    var timeIncrementMultiplier: Double { initialTime.start > initialTime.end ? -1 : 1 }
    var isTimerRunning: Bool { internalTimer?.isValid ?? false }
}
