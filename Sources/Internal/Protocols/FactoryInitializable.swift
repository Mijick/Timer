//
//  FactoryInitializable.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 15.11.2024.
//

import SwiftUI

@MainActor public protocol FactoryInitializable {
    init(_ id: MTimerID)
}

extension FactoryInitializable where Self: MTimer {
     public init(_ id: MTimerID) {
         let timer = MTimer(identifier: id)
         let registeredTimer = MTimerContainer.register(timer)
         self = registeredTimer as! Self
    }
}
