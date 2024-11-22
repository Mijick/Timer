//
//  MTimerContainer.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

@MainActor class MTimerContainer {
    private var timers: [MTimer] = []
    static let shared = MTimerContainer()
    
    private init() { }
}

extension MTimerContainer {
    func getTimer(_ id: MTimerID) -> MTimer? { timers.first(where: { $0.id == id }) }
    func register(_ timer: MTimer)  { if getTimer(timer.id) == nil { timers.append(timer) }}
}

extension MTimerContainer {
    func resetAll() { timers.forEach { $0.reset() }}
}
