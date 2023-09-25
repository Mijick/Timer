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

public struct MTime {
    public let hours: Int
    public let minutes: Int
    public let seconds: Int
    public let milliseconds: Int
}
extension MTime {
    init(_ timeInterval: TimeInterval) {
        let millisecondsInt = Int(timeInterval * 1000)

        let hoursDiv = 1000 * 60 * 60
        let minutesDiv = 1000 * 60
        let secondsDiv = 1000
        let millisecondsDiv = 1

        hours = millisecondsInt / hoursDiv
        minutes = (millisecondsInt % hoursDiv) / minutesDiv
        seconds = (millisecondsInt % hoursDiv % minutesDiv) / secondsDiv
        milliseconds = (millisecondsInt % hoursDiv % minutesDiv % secondsDiv) / millisecondsDiv
    }
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
