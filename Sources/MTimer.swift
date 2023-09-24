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
    private var internalTimer: Timer!

    private var status: Status = .stopped
    private var increasing: Bool = true
    private var backgroundDate: Date? = nil
    private var runningTime: TimeInterval = 0
    private var fromTime: TimeInterval = 0
    private var toTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var completion: ((TimeInterval) -> ())!
    private var onStatusChange: (Status) -> () = { _ in }

    private static let shared: MTimer = .init()
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
        shared.runningTime = shared.fromTime
        shared.completion(shared.runningTime)
    }
}

extension MTimer {

}





extension MTimer {
    public func start(from: TimeInterval = 0, to: TimeInterval = .infinity) {
        guard from != to else { return }



        fromTime = from
        runningTime = from
        toTime = to

        increasing = to > from


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


        status = .running

        DispatchQueue.main.async {
            self.onStatusChange(.running)
        }

        addObservers()




        DispatchQueue.main.async { [self] in
        internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] a in
            let newTime = runningTime + timeInterval * increasing.toNumber()


            let test = (newTime - toTime) * increasing.toNumber()
            if test >= 0 {
                completion(toTime)
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
        status = .stopped

        DispatchQueue.main.async {
            self.onStatusChange(.stopped)
        }


        removeObservers()
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
            let newTime = max(0, runningTime + Date().timeIntervalSince(backgroundDate!) * increasing.toNumber())

            let test = (newTime - toTime) * increasing.toNumber()
            if test >= 0 {
                completion(toTime)
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



extension Bool {
    func toNumber() -> Double { self ? 1 : -1 }
}




// MARK: - For Testing
extension MTimer {
    static func getRunningTime() -> TimeInterval { shared.runningTime }


    
}




extension MTimer { public enum Status {
    case running, stopped
}}



extension MTimer { public enum Error: Swift.Error {
    case cannotResumeNotInitialisedTimer
}}
