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

fileprivate typealias TimeIntervalCompletion = (TimeInterval) -> ()
fileprivate typealias StatusCompletion = (MTimer.Status) -> ()

public class MTimer {
    private static let shared: MTimer = .init()

    // Current State
    private var internalTimer: Timer!
    private var status: Status = .stopped
    private var runningTime: TimeInterval = 0
    private var backgroundDate: Date? = nil

    // Configuration
    private var initialTime: (start: TimeInterval, end: TimeInterval) = (0, 1)
    private var timeInterval: TimeInterval = 0
    private var completion: TimeIntervalCompletion!
    private var onStatusChange: StatusCompletion = { _ in }
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
    public static func abc(every seconds: TimeInterval, _ completion: @escaping (TimeInterval) -> ()) -> MTimer {


        shared.completion = completion
        shared.timeInterval = seconds
        return shared
    }
    public func onStatusChange(_ action: @escaping (Status) -> ()) -> MTimer {
        onStatusChange = action

        return self
    }
}
private extension MTimer {
    func startTimer() { 
        guard status == .stopped else { return }

        updateStatus(to: .running)

        addObservers()




        DispatchQueue.main.async { [self] in
        internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] a in
            let newTime = runningTime + timeInterval * timerType.rawValue


            let test = (newTime - initialTime.end) * timerType.rawValue
            if test >= 0 {
                completion(initialTime.end)
                stopTimer()
                return
            }

            runningTime = newTime
            completion(runningTime)
        })
        RunLoop.current.add(internalTimer, forMode: .common)
    }}
    func stopTimer() {
        internalTimer.invalidate()
        updateStatus(to: .stopped)


        removeObservers()
    }
}

private extension MTimer {
    func updateStatus(to newStatus: Status) {
        status = newStatus
        DispatchQueue.main.async { [self] in onStatusChange(newStatus) }
    }
}


// MARK: - Notification Center
private extension MTimer {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
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
