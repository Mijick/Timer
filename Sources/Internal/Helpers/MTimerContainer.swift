//
//  MTimerContainer.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

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
