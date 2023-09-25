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
    var internalTimer: Timer!
    var status: Status = .stopped
    var runningTime: TimeInterval = 0
    var backgroundDate: Date? = nil

    // Configuration
    var initialTime: (start: TimeInterval, end: TimeInterval) = (0, 1)
    var publisherTime: TimeInterval = 0
    var completion: ((TimeInterval) -> ())!
    var onStatusChange: ((MTimer.Status) -> ())?
}







private extension MTimer {
    func updateStatus(to newStatus: Status) {
        status = newStatus
        DispatchQueue.main.async { [self] in onStatusChange?(newStatus) }
    }
}



// MARK: - Timer Controls
extension MTimer {
    public static func resume() throws {
        guard shared.completion != nil else { throw Error.cannotResumeNotInitialisedTimer }

        shared.startTimer()
    }
    public static func stop() {
        shared.stopTimer()
    }
    public static func reset() {
        shared.runningTime = shared.initialTime.start
        shared.completion(shared.runningTime)
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
        guard status == .stopped || backgroundDate != nil else { return }

        updateStatus(to: .running)

        addObservers()




        DispatchQueue.main.async { [self] in
        internalTimer = .scheduledTimer(withTimeInterval: publisherTime, repeats: true, block: aaaa)
        //RunLoop.current.add(internalTimer, forMode: .common)
    }}
    func stopTimer() {
        internalTimer.invalidate()
        updateStatus(to: .stopped)


        removeObservers()
    }
}
private extension MTimer {
    func aaaa(_ t: Timer) {
        let newTime = runningTime + publisherTime * timerType.rawValue


        let test = (newTime - initialTime.end) * timerType.rawValue
        if test >= 0 {
            completion(initialTime.end)
            stopTimer()
            return
        }

        runningTime = newTime
        completion(runningTime)
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
        internalTimer.invalidate()
        backgroundDate = .init()
    }
    @objc func willEnterForegroundNotification() {
        if status == .running {
            let newTime = max(0, runningTime + Date().timeIntervalSince(backgroundDate!) * timerType.rawValue)

            let test = (newTime - initialTime.end) * timerType.rawValue
            if test >= 0 {
                completion(initialTime.end)
                stopTimer()
                return
            }


            runningTime = newTime
        }


        // czy tutaj też musi być running?
        completion(runningTime)

        startTimer()


        backgroundDate = nil
    }
}










private extension MTimer {
    var timerType: TimerType { initialTime.start > initialTime.end ? .decreasing : .increasing }
}






extension MTimer { public enum Status {
    case running, stopped
}}



private extension MTimer { enum TimerType: Double {
    case increasing = 1, decreasing = -1
}}



extension MTimer { public enum Error: Swift.Error {
    case startTimeCannotBeTheSameAsEndTime, timeCannotBeLessThanZero
    case cannotResumeNotInitialisedTimer
}}
