//
//  Public+MTimerID.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

/// Unique id that enables an access to the registered timer from any location.
public struct MTimerID: Equatable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
}
