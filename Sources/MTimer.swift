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

    private static let shared: MTimer = .init()
}

// MARK: - Timer Controls
extension MTimer {
    public static func start(timeInterval: TimeInterval, _ completion: @escaping (TimeInterval) -> ()) { DispatchQueue.main.async {
        guard !shared.running else { return }



        appStateBinding()

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


        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    public static func reset() {
        shared.runningTime = 0
        shared.completion(shared.runningTime)
    }
}

extension MTimer {
    
}

extension MTimer {
    @objc fileprivate static func didEnterBackgroundNotification() {
        shared.internalTimer.invalidate()
        shared.backgroundDate = .init()
    }

    @objc fileprivate static func willEnterForegroundNotification() {
        if shared.running {
            shared.runningTime += Date().timeIntervalSince(shared.backgroundDate!)
        }
        shared.completion(shared.runningTime)

        shared.internalTimer = .scheduledTimer(withTimeInterval: shared.timeInterval, repeats: true, block: { a in
            shared.runningTime += shared.timeInterval
            shared.completion(shared.runningTime)
        })


        shared.backgroundDate = nil
    }
}

extension MTimer {
    fileprivate static func appStateBinding() {

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

