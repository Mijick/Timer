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
    private var backgroundDate: Date? = nil
    private var runningTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var completion: (TimeInterval) -> () = { _ in }
    private var onStatusChange: (String) -> () = { _ in }

    private static let shared: MTimer = .init()
}

// MARK: - Timer Controls
extension MTimer {
    public static func start(timeInterval: TimeInterval, _ completion: @escaping (TimeInterval) -> ()) { DispatchQueue.main.async {
        guard !shared.running else { return }



        shared.onStatusChange("Start")
        //appStateBinding()

        shared.running = true
        shared.completion = completion

        shared.timeInterval = timeInterval
        shared.internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { a in
            shared.runningTime += timeInterval
            completion(shared.runningTime)
        })
        RunLoop.current.add(shared.internalTimer, forMode: .common)
    }}
    public static func stop() {
        shared.internalTimer.invalidate()
        shared.running = false

        shared.onStatusChange("Stop")


        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
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
            runningTime += Date().timeIntervalSince(backgroundDate!)
        }
        completion(runningTime)

        internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] a in
            runningTime += timeInterval
            completion(runningTime)
        })


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

        internalTimer = .scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] a in
            runningTime += timeInterval
            completion(runningTime)
        })
        RunLoop.current.add(internalTimer, forMode: .common)
    }}
    public static func abc(every seconds: TimeInterval, _ completion: @escaping (TimeInterval) -> ()) -> MTimer {


        shared.completion = completion
        shared.timeInterval = seconds
        return shared
    }
}
