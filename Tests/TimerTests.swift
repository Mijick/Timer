import XCTest
@testable import MijickTimer

final class TimerTests: XCTestCase {
    var currentTime: TimeInterval = 0



    func testTimerPublishesStatuses() {
        var statuses: [MTimer.Status: Bool] = [.running: false, .stopped: false]

        try! timer
            .onStatusChange { statuses[$0] = true }
            .start()
        wait(for: waitingTime)

        MTimer.stop()
        wait(for: waitingTime)

        XCTAssertTrue(statuses.values.filter { !$0 }.isEmpty)
    }
    func testTimerStopsAutomatically_WhenGoesForward() {
        try! timer.start(from: 0, to: 0.25)
        wait(for: 0.8)

        XCTAssertEqual(currentTime, 0.25)
    }
    func testTimerStopsAutomatically_WhenGoesBackward() {
        try! timer.start(from: 3, to: 2.75)
        wait(for: 0.8)

        XCTAssertEqual(currentTime, 2.75)
    }

    func testTimerCanRunBackwards() {
        try! timer.start(from: 3, to: 1)
        wait(for: waitingTime)

        XCTAssertLessThan(currentTime, 3)
    }

    func testTimerCanHaveMultipleInstances() {

    }
}




// MARK: - Basic Functions
extension TimerTests {
    func testTimerStarts() {
        let expectation = expectation(description: "")

        try! MTimer
            .abc(every: 0.1) { _ in expectation.fulfill() }
            .start()

        waitForExpectations(timeout: 0.4)
    }
    func testTimerIsCancellable() {
        try! timer.start()
        wait(for: waitingTime)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: waitingTime)

        XCTAssertEqual(timeAfterStop, currentTime)
    }
    func testTimerIsResetable() {
        let startTime: TimeInterval = 3

        try! timer.start(from: startTime)
        wait(for: waitingTime)

        MTimer.stop()

        var currentRunningTime = MTimer.getRunningTime()
        XCTAssertNotEqual(currentRunningTime, startTime)

        MTimer.reset()

        currentRunningTime = MTimer.getRunningTime()
        XCTAssertEqual(startTime, currentRunningTime)
    }
    func testTimerCanBeResumed() {
        try! timer.start()
        wait(for: waitingTime)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: waitingTime)

        try! MTimer.resume()
        wait(for: waitingTime)

        XCTAssertNotEqual(timeAfterStop, currentTime)
    }
}

// MARK: - Text Formatting
extension TimerTests {

}

// MARK: - Errors
extension TimerTests {
    func testTimerDoesNotStart_StartTimeEqualsEndTime() {
        XCTAssertThrowsError(try timer.start(from: 0, to: 0)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .startTimeCannotBeTheSameAsEndTime)
        }
    }
    func testTimerDoesNotStart_StartIntervalIsLessThanZero() {
        XCTAssertThrowsError(try timer.start(from: -10, to: 5)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testTimerDoesNotStart_EndIntervalIsLessThanZero() {
        XCTAssertThrowsError(try timer.start(from: 10, to: -15)) { error in
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


    var waitingTime: TimeInterval { 0.15 }


    var timer: MTimer { .abc(every: 0.05) { self.currentTime = $0 } }
}
