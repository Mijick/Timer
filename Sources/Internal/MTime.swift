//
//  MTime.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

public struct MTime: Equatable {
    public let hours: Int
    public let minutes: Int
    public let seconds: Int
    public let milliseconds: Int
}

// MARK: - Helpers
extension MTime {
    var defaultTimeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()

        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.maximumUnitCount = 0
        formatter.allowsFractionalUnits = false
        formatter.collapsesLargestUnit = false

        return formatter
    }
}
