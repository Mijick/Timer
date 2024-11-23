//
//  MTimerID.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

public struct MTimerID: Equatable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
}
