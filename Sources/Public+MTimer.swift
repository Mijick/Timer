//
//  Public+MTimer.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

// MARK: - Creating Timer
extension MTimer {
    public static func publish(every time: TimeInterval, _ completion: @escaping (_ currentTime: TimeInterval) -> ()) -> MTimer {
        shared.publisherTime = time
        shared.completion = completion
        return shared
    }
}



extension MTimer {
    public func onStatusChange(_ action: @escaping (_ newStatus: Status) -> ()) -> MTimer {
        onStatusChange = action
        return self
    }
}
