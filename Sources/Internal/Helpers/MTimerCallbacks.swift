//
//  MTimerCallbacks.swift
//  MijickTimer
//
//  Created by Alina Petrovska
//    - Mail: alina.petrovska@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2024 Mijick. All rights reserved.

import SwiftUI

class MTimerCallbacks {
    var onRunningTimeChange: ((MTime) -> ())?
    var onTimerStatusChange: ((MTimerStatus) -> ())?
    var onTimerProgressChange: ((Double) -> ())?
}
