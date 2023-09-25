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

// MARK: - Converting to String
extension MTime {
    public func toString(using units: Unit..., separator: String = ":") -> String {
        fatalError()
    }
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

private extension MTime {

}







extension MTime { public enum Unit {
    case milliseconds, seconds, minutes, hours
}}
