import XCTest
@testable import MijickTimer

final class TimerTests: XCTestCase {
    var currentTime: TimeInterval = 0
}

// MARK: - Basics
extension TimerTests {
    func testTimerStarts() {
        let expectation = expectation(description: "")

        try! MTimer
            .publish(every: 0.1) { _ in expectation.fulfill() }
            .start()

        waitForExpectations(timeout: 0.4)
    }
    func testTimerIsCancellable() {
        try! defaultTimer.start()
        wait(for: defaultWaitingTime)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: defaultWaitingTime)

        XCTAssertEqual(timeAfterStop, currentTime)
    }
    func testTimerIsResetable() {
        let startTime: TimeInterval = 3

        try! defaultTimer.start(from: startTime)
        wait(for: defaultWaitingTime)

        MTimer.stop()

        var currentRunningTime = currentTime
        XCTAssertNotEqual(currentRunningTime, startTime)

        MTimer.reset()

        currentRunningTime = currentTime
        XCTAssertEqual(startTime, currentRunningTime)
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
extension TimerTests {
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
        //XCTAssert(false)
    }
}


// MARK: - Text Formatting
extension TimerTests {

}

// MARK: - Errors
extension TimerTests {
    func testTimerDoesNotStart_StartTimeEqualsEndTime() {
        XCTAssertThrowsError(try defaultTimer.start(from: 0, to: 0)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .startTimeCannotBeTheSameAsEndTime)
        }
    }
    func testTimerDoesNotStart_StartIntervalIsLessThanZero() {
        XCTAssertThrowsError(try defaultTimer.start(from: -10, to: 5)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testTimerDoesNotStart_EndIntervalIsLessThanZero() {
        XCTAssertThrowsError(try defaultTimer.start(from: 10, to: -15)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testCannotInitialiseTimer_LaunchTimerWithoutInitialisation() {
        XCTAssertThrowsError(try MTimer.resume()) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .cannotResumeNotInitialisedTimer)
        }
    }
}


// MARK: - Helpers
private extension TimerTests {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}
private extension TimerTests {
    var defaultWaitingTime: TimeInterval { 0.15 }
    var defaultTimer: MTimer { .publish(every: 0.05) { self.currentTime = $0 } }
}
