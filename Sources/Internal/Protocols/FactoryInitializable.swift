//
//  FactoryInitializable.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 15.11.2024.
//

import SwiftUI

@MainActor public protocol FactoryInitializable { }

extension FactoryInitializable where Self: MTimer {
    /// Registers or returns registered Timer
     public init(_ id: MTimerID) {
         let timer = MTimer(identifier: id)
         let registeredTimer = MTimerContainer.register(timer)
         self = registeredTimer as! Self
    }
}
