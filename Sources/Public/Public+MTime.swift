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
    public func toString(_ formatter: (DateComponentsFormatter) -> DateComponentsFormatter = { $0 }) -> String {
        formatter(defaultTimeFormatter).string(from: toTimeInterval()) ?? ""
    }
}
