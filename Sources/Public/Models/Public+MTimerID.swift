//
//  Public+MTimerID.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

/// Unique id that enables an access to the registered timer from any location.
public struct MTimerID: Equatable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
}
