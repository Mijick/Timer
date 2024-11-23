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
    static func getTimer(_ id: MTimerID) -> MTimer? { timers.first(where: { $0.id == id }) }
    static func register(_ timer: MTimer)  { if getTimer(timer.id) == nil { timers.append(timer) }}
}

extension MTimerContainer {
    static func resetAll() { timers.forEach { $0.reset() }}
}
