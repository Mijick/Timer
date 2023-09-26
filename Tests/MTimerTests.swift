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

final class MTimerTests: XCTestCase {
    var currentTime: TimeInterval = 0

    override func setUp() { MTimer.stop() }
}

// MARK: - Basics
extension MTimerTests {
    func testTimerStarts() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        XCTAssertGreaterThan(currentTime, 0)
    }
    func testTimerIsCancellable() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        MTimer.stop()
        wait(for: defaultWaitingTime)

        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        XCTAssertEqual(timeAfterStop, currentTime)
    }
    func testTimerIsResetable() {
        let startTime: TimeInterval = 3

        try! defaultTimer.start(from: startTime)
        wait(for: defaultWaitingTime)

        XCTAssertNotEqual(currentTime, startTime)

        wait(for: defaultWaitingTime)
        MTimer.reset()
        wait(for: defaultWaitingTime)

        XCTAssertEqual(startTime, currentTime)
    }
    func testTimerCanBeResumed() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        try! MTimer.resume()
        wait(for: defaultWaitingTime)

        XCTAssertNotEqual(timeAfterStop, currentTime)
    }
}

// MARK: - Additional Basics
extension MTimerTests {
    func testTimerShouldPublishAccurateValuesWithZeroTolerance() {
        try! MTimer
            .publish(every: 0.1, tolerance: 0) { self.currentTime = $0.toTimeInterval() }
            .start()
        wait(for: 0.6)

        XCTAssertEqual(currentTime, 0.6)
    }
    func testTimerShouldPublishInaccurateValuesWithNonZeroTolerance() {
        try! defaultTimer.start()
        wait(for: 0.6)

        XCTAssertNotEqual(currentTime, 0.6)
    }
    func testTimerCanRunBackwards() {
        try! defaultTimer.start(from: 3, to: 1)
        wait(for: defaultWaitingTime)

        XCTAssertLessThan(currentTime, 3)
    }
    func testTimerPublishesStatuses() {
        var statuses: [Bool: Bool] = [true: false, false: false]

        try! defaultTimer
            .onTimerActivityChange { statuses[$0] = true }
            .start()
        wait(for: defaultWaitingTime)

        MTimer.stop()
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

        let newTimer = MTimer.createNewInstance()
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
        let newTimer = MTimer.createNewInstance()

        try! newTimer
            .publish(every: 0.1) { self.currentTime = $0.toTimeInterval() }
            .start()
        wait(for: defaultWaitingTime)

        newTimer.stop()
        wait(for: defaultWaitingTime)

        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        XCTAssertGreaterThan(currentTime, 0)
        XCTAssertEqual(timeAfterStop, currentTime)
    }
}

// MARK: - Errors
extension MTimerTests {
    func testTimerCannotBeInitialised_PublishTimeIsTooLess() {
        XCTAssertThrowsError(try MTimer.publish(every: 0.0001, { _ in })) { error in
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
        XCTAssertThrowsError(try MTimer.resume()) { error in
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
    var defaultTimer: MTimer { try! .publish(every: 0.05, tolerance: 0.5) { self.currentTime = $0.toTimeInterval() } }
}
