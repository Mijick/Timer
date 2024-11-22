//
//  MTimerTests.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import XCTest
@testable import MijickTimer

@MainActor final class MTimerTests: XCTestCase {
    var currentTime: TimeInterval = 0

    override func setUp() async throws {
        MTimerContainer.shared.resetAll()
    }
}

// MARK: - Basics
extension MTimerTests {
    func testTimerStarts() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)
        
        XCTAssertGreaterThan(currentTime, 0)
        XCTAssertEqual(.inProgress, timer.timerState)
    }
    func testTimerIsCancellable() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        timer.cancel()
        wait(for: defaultWaitingTime)

        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        XCTAssertEqual(timeAfterStop, currentTime)
        XCTAssertEqual(.cancelled, timer.timerState)
    }
    func testTimerIsResetable() {
        let startTime: TimeInterval = 3
        try! defaultTimer.start(from: startTime)
        wait(for: defaultWaitingTime)
        
        XCTAssertNotEqual(currentTime, startTime)
        
        wait(for: defaultWaitingTime)
        timer.reset()
        wait(for: defaultWaitingTime)
        
        XCTAssertEqual(0, currentTime)
        XCTAssertEqual(0, timer.timerProgress)
        XCTAssertEqual(.notStarted, timer.timerState)
    }
    func testTimerIsSkippable() {
        let endTime: TimeInterval = 3
    
        try! defaultTimer.start(to: endTime)
        wait(for: defaultWaitingTime)
        timer.skip()
        wait(for: defaultWaitingTime)

        XCTAssertEqual(endTime, currentTime)
        XCTAssertEqual(1, timer.timerProgress)
        XCTAssertEqual(.finished, timer.timerState)
    }
    func testTimerCanBeResumed() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        timer.pause()
        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        try! timer.resume()
        wait(for: defaultWaitingTime)

        XCTAssertNotEqual(timeAfterStop, currentTime)
        XCTAssertEqual(.inProgress, timer.timerState)
    }
}

// MARK: - Additional Basics
extension MTimerTests {
    func testTimerShouldPublishAccurateValuesWithZeroTolerance() {
        try! timer
            .publish(every: 0.1, tolerance: 0.0) { self.currentTime = $0.toTimeInterval() }
            .start()
        wait(for: 0.6)

        XCTAssertEqual(currentTime, 0.6)
    }
    func testTimerShouldPublishInaccurateValuesWithNonZeroTolerance() {
        try! defaultTimer.start()
        wait(for: 1)
        
        // usually returns 1.0000000000000002 that is equal to 1.0
        // OLD test XCTAssertNotEqual(currentTime, 1)
        XCTAssertEqual(currentTime, 1)
    }
    func testTimerCanRunBackwards() {
        try! defaultTimer.start(from: 3, to: 1)
        wait(for: defaultWaitingTime)

        XCTAssertLessThan(currentTime, 3)
    }
    func testTimerPublishesStatuses() {
        var statuses: [MTimerStatus: Bool] = [.inProgress: false, .cancelled: false]

        try! defaultTimer
            .onTimerActivityChange { statuses[$0] = true }
            .start()
        wait(for: defaultWaitingTime)

        timer.cancel()
        wait(for: defaultWaitingTime)

        XCTAssertTrue(statuses.values.filter { !$0 }.isEmpty)
    }
    func testTimerIncreasesTimeCorrectly_WhenGoesForward() {
        try! defaultTimer.start(from: 0, to: 10)
        wait(for: 0.8)

        XCTAssertGreaterThan(currentTime, 0)
        XCTAssertLessThan(currentTime, 10)
    }
    func testTimerIncreasesTimeCorrectly_WhenGoesBackward() {
        try! defaultTimer.start(from: 10, to: 0)
        wait(for: 0.8)

        XCTAssertGreaterThan(currentTime, 0)
        XCTAssertLessThan(currentTime, 10)
    }
    func testTimerStopsAutomatically_WhenGoesForward() {
        try! defaultTimer.start(from: 0, to: 0.25)
        wait(for: 0.8)

        XCTAssertEqual(currentTime, 0.25)
    }
    func testTimerStopsAutomatically_WhenGoesBackward() {
        try! defaultTimer.start(from: 3, to: 2.75)
        wait(for: 0.8)

        XCTAssertEqual(currentTime, 2.75)
    }
    func testTimerStopsAutomatically_WhenGoesBackward_DoesNotExceedZero() {
        try! defaultTimer.start(from: 0.25, to: 0)
        wait(for: 1.2)

        XCTAssertEqual(currentTime, 0)
    }
    func testTimerCanHaveMultipleInstances() {
        var newTime: TimeInterval = 0

        let newTimer = MTimer(.multipleInstancesTimer)
        try! newTimer
            .publish(every: 0.3) { newTime = $0.toTimeInterval() }
            .start(from: 10, to: 100)
        try! defaultTimer.start(from: 0, to: 100)

        wait(for: 1)

        XCTAssertGreaterThan(newTime, 10)
        XCTAssertGreaterThan(currentTime, 0)
        XCTAssertNotEqual(newTime, currentTime)
    }
    func testNewInstanceTimerCanBeStopped() {
        let newTimer = MTimer(.stoppableTimer)

        try! newTimer
            .publish(every: 0.1) { print($0); self.currentTime = $0.toTimeInterval() }
            .start()
        wait(for: defaultWaitingTime)

        newTimer.cancel()
        wait(for: defaultWaitingTime)

        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        XCTAssertEqual(currentTime, 0)
        XCTAssertEqual(timeAfterStop, currentTime)
    }
}

// MARK: - Progress
extension MTimerTests {
    func testTimerProgressCountsCorrectly_From0To10() {
        var progress: Double = 0

        try! timer
            .publish(every: 0.5, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .onTimerProgressChange { progress = $0 }
            .start(from: 0, to: 10)
        wait(for: 1)

        XCTAssertEqual(progress, 0.1)
    }
    func testTimerProgressCountsCorrectly_From10To29() {
        var progress: Double = 0

        try! timer
            .publish(every: 0.5, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .onTimerProgressChange { progress = $0 }
            .start(from: 10, to: 29)
        wait(for: 1)

        XCTAssertEqual(progress, 1/19)
    }
    func testTimerProgressCountsCorrectly_From31To100() {
        var progress: Double = 0

        try! timer
            .publish(every: 0.5, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .onTimerProgressChange { progress = $0 }
            .start(from: 31, to: 100)
        wait(for: 1)

        XCTAssertEqual(progress, 1/69)
    }
    func testTimerProgressCountsCorrectly_From100To0() {
        var progress: Double = 0

        try! timer
            .publish(every: 0.5, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .onTimerProgressChange { progress = $0 }
            .start(from: 100, to: 0)
        wait(for: 1.5)

        XCTAssertEqual(progress, 1.5/100)
    }
    func testTimerProgressCountsCorrectly_From31To14() {
        var progress: Double = 0

        try! timer
            .publish(every: 0.25, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .onTimerProgressChange { progress = $0 }
            .start(from: 31, to: 14)
        wait(for: 1)

        XCTAssertEqual(progress, 1/17)
        XCTAssertEqual(timer.timerProgress, 1/17)
    }
    func timerShouldPublishStatusUpdateAtTheEndIfPublishersNotSetUpped() {
        let timer = MTimer(.timerWithoutPublishers)
        try! timer.start(to: 1)
        wait(for: 1)
        
        XCTAssertEqual(1.0, timer.timerTime.toTimeInterval())
    }
}

// MARK: - Errors
extension MTimerTests {
    func testTimerCannotBeInitialised_PublishTimeIsTooLess() {
        XCTAssertThrowsError(try timer.publish(every: 0.0001, { _ in })) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .publisherTimeCannotBeLessThanOneMillisecond)
        }
    }
    func testTimerDoesNotStart_StartTimeEqualsEndTime() {
        XCTAssertThrowsError(try defaultTimer.start(from: 0, to: 0)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .startTimeCannotBeTheSameAsEndTime)
        }
    }
    func testTimerDoesNotStart_StartTimeIsLessThanZero() {
        XCTAssertThrowsError(try defaultTimer.start(from: -10, to: 5)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testTimerDoesNotStart_EndTimeIsLessThanZero() {
        XCTAssertThrowsError(try defaultTimer.start(from: 10, to: -15)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testCannotResumeTimer_WhenTimerIsNotInitialised() {
        XCTAssertThrowsError(try timer.resume()) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .cannotResumeNotInitialisedTimer)
        }
    }
    func testCannotStartTimer_WhenTimerIsRunning() {
        try! defaultTimer.start()

        XCTAssertThrowsError(try defaultTimer.start()) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timerIsAlreadyRunning)
        }
    }
}


// MARK: - Helpers
private extension MTimerTests {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}
private extension MTimerTests {
    var defaultWaitingTime: TimeInterval { 0.15 }
    var defaultTimer: MTimer { try! timer.publish(every: 0.05, tolerance: 0.5) { self.currentTime = $0.toTimeInterval() } }
    var timer: MTimer { .init(.testTimer) }
}
fileprivate extension MTimerID {
    @MainActor static let testTimer: MTimerID = .init(rawValue: "Test timer")
    @MainActor static let timerWithoutPublishers: MTimerID = .init(rawValue: "Timer Without Publishers")
    @MainActor static let stoppableTimer: MTimerID = .init(rawValue: "Stoppable Timer")
    @MainActor static let multipleInstancesTimer: MTimerID = .init(rawValue: "Multiple Instances")
}
