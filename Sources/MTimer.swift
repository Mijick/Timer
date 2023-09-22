//
//  MTimer.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

public class MTimer {
    private var internalTimer: Timer!

    private var status: TimerStatus = .paused
    private var startDate: Date? = nil
    private var runningTime: TimeInterval = 0

    private static let shared: MTimer = .init()
}

// MARK: - Timer Controls
extension MTimer {
    public static func start(_ ac: @escaping () -> ()) { DispatchQueue.main.async {
        shared.startDate = .init()
        shared.internalTimer = .scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { a in
            ac()
        })
        RunLoop.current.add(shared.internalTimer, forMode: .common)
    }}
    public static func stop() {
        shared.internalTimer.invalidate()
        shared.startDate = nil
    }
    public static func pause() {
        
    }
    public static func reset() {

    }
}

extension MTimer {

}
















enum TimerStatus { case working, paused }
