//
//  Public+MTime.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

// MARK: - Initialisation
extension MTime {
    public init(hours: Double = 0, minutes: Double = 0, seconds: Double = 0, milliseconds: Int = 0) {
        let hoursInterval = hours * 60 * 60
        let minutesInterval = minutes * 60
        let secondsInterval = seconds
        let millisecondsInterval = Double(milliseconds) / 1000
        
        let timeInterval = hoursInterval + minutesInterval + secondsInterval + millisecondsInterval
        self.init(timeInterval: timeInterval)
    }
    public init(timeInterval: TimeInterval) {
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
    public static var zero: MTime { .init() }
    public static var max: MTime { .init(hours: 60 * 60 * 24 * 365 * 100) }
}

// MARK: - Converting to TimeInterval
extension MTime {
    public func toTimeInterval() -> TimeInterval {
        let hoursAsTimeInterval = 60 * 60 * TimeInterval(hours)
        let minutesAsTimeInterval = 60 * TimeInterval(minutes)
        let secondsAsTimeInterval = 1 * TimeInterval(seconds)
        let millisecondsAsTimeInterval = 0.001 * TimeInterval(milliseconds)

        return hoursAsTimeInterval + minutesAsTimeInterval + secondsAsTimeInterval + millisecondsAsTimeInterval
    }
}

// MARK: - Converting To String
extension MTime {
    /// Converts the object to a string representation. Output can be customised by modifying the formatter block.
    public func toString(_ formatter: (DateComponentsFormatter) -> DateComponentsFormatter = { $0 }) -> String {
        formatter(defaultTimeFormatter).string(from: toTimeInterval()) ?? ""
    }
}
