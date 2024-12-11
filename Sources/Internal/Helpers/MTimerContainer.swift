//
//  MTimerContainer.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

@MainActor class MTimerContainer {
    private static var timers: [MTimer] = []
}

extension MTimerContainer {
    static func register(_ timer: MTimer) -> MTimer  {
        if let timer = getTimer(timer.id) { return timer }
        timers.append(timer)
        return timer
    }
}
private extension MTimerContainer {
    static func getTimer(_ id: MTimerID) -> MTimer? {
        timers.first(where: { $0.id == id })
    }
}

extension MTimerContainer {
    static func resetAll() { timers.forEach { $0.reset() }}
}
