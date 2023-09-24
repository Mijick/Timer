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

    private var running: Bool = false
    private var increasing: Bool = true
    private var backgroundDate: Date? = nil
    private var runningTime: TimeInterval = 0
    private var maxTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var completion: (TimeInterval) -> () = { _ in }
    private var onStatusChange: (String) -> () = { _ in }

    private static let shared: MTimer = .init()
}

// MARK: - Timer Controls
extension MTimer {
    public static func stop() {
        shared.stopTimer()
    }
    public static func reset() {
        shared.runningTime = 0
        shared.completion(shared.runningTime)
    }
}

extension MTimer {
    public static func onStatusChange(_ action: @escaping (String) -> ()) {
        shared.onStatusChange = action
    }
}

extension MTimer {
    @objc fileprivate func didEnterBackgroundNotification() {
        internalTimer.invalidate()
        backgroundDate = .init()
    }

    @objc fileprivate func willEnterForegroundNotification() {
        if running {
            let newTime = max(0, runningTime + Date().timeIntervalSince(backgroundDate!) * increasing.toNumber())

            let test = (newTime - maxTime) * increasing.toNumber()
            if test >= 0 {
                completion(maxTime)
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

extension MTimer {
    fileprivate func appStateBinding() {

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}





extension MTimer {
    public func start(from: TimeInterval = .infinity, to: TimeInterval = .infinity) { DispatchQueue.main.async { [self] in
        onStatusChange("Start")
        appStateBinding()

        running = true

        runningTime = from
        maxTime = to

        increasing = to > from


        startTimer()
    }}
    public static func abc(every seconds: TimeInterval, _ completion: @escaping (TimeInterval) -> ()) -> MTimer {


        shared.completion = completion
        shared.timeInterval = seconds
        return shared
    }
}
private extension MTimer {
    func startTimer() {
        internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] a in
            let newTime = runningTime + timeInterval * increasing.toNumber()


            let test = (newTime - maxTime) * increasing.toNumber()
            if test >= 0 {
                completion(maxTime)
                stopTimer()
                return
            }

            runningTime = newTime
            completion(runningTime)
        })
        RunLoop.current.add(internalTimer, forMode: .common)
    }
    func stopTimer() {
        internalTimer.invalidate()
        running = false

        onStatusChange("Stop")


        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}



extension Bool {
    func toNumber() -> Double { self ? 1 : -1 }
}
