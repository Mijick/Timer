//
//  MTimerCallbacks.swift
//  MijickTimer
//
//  Created by Alina Petrovska on 11.11.2024.
//

import SwiftUI

class MTimerCallbacks {
    var onRunningTimeChange: ((MTime) -> ())?
    var onTimerActivityChange: ((MTimerStatus) -> ())?
    var onTimerProgressChange: ((Double) -> ())?
}
