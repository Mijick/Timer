//
//  Public+MTimerError.swift
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. All rights reserved.


import Foundation

public enum MTimerError: Error {
    case publisherTimeCannotBeLessThanZero
    case startTimeCannotBeTheSameAsEndTime, timeCannotBeLessThanZero
    case cannotResumeNotInitialisedTimer
    case timerIsAlreadyRunning, timerIsNotStarted
}
