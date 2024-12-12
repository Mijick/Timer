//
//  FactoryInitializable.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

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
