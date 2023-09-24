import XCTest
@testable import MijickTimer

final class TimerTests: XCTestCase {
    var currentTime: TimeInterval = 0


    func testTimerStarts() {
        let expectation = expectation(description: "")

        try! MTimer
            .abc(every: 1) { _ in expectation.fulfill() }
            .start()

        waitForExpectations(timeout: 1.2)
    }
    func testTimerIsCancellable() {
        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start()
        wait(for: 1)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: 1)

        XCTAssertEqual(timeAfterStop, currentTime)
    }
    func testTimerIsResetable() {
        let startTime: TimeInterval = 3

        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: startTime)
        wait(for: 1)

        MTimer.stop()

        var currentRunningTime = MTimer.getRunningTime()
        XCTAssertNotEqual(currentRunningTime, startTime)

        MTimer.reset()

        currentRunningTime = MTimer.getRunningTime()
        XCTAssertEqual(startTime, currentRunningTime)
    }
    func testTimerPublishesStatuses() {
        var statuses: [MTimer.Status: Bool] = [.running: false, .stopped: false]

        try! MTimer
            .abc(every: 0.1) { _ in }
            .onStatusChange { statuses[$0] = true }
            .start()
        wait(for: 0.4)

        MTimer.stop()
        wait(for: 0.4)

        XCTAssertTrue(statuses.values.filter { !$0 }.isEmpty)
    }
    func testTimerStopsAutomatically_WhenGoesForward() {
        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 0, to: 2)
        wait(for: 3)

        XCTAssertEqual(currentTime, 2)
    }
    func testTimerStopsAutomatically_WhenGoesBackward() {
        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 3, to: 1)
        wait(for: 3)

        XCTAssertEqual(currentTime, 1)
    }

    func testCannotInitialiseTimer_LaunchTimerWithoutInitialisation() {
        XCTAssertThrowsError(try MTimer.resume()) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .cannotResumeNotInitialisedTimer)
        }
    }
    func testTimerCanRunBackwards() {
        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 3, to: 1)
        wait(for: 1)

        XCTAssertLessThan(currentTime, 3)
    }
    func testTimerCanBeResumed() {
        try! MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start()
        wait(for: 1)

        MTimer.stop()
        let timeAfterStop = currentTime
        wait(for: 0.4)

        try! MTimer.resume()
        wait(for: 1)

        XCTAssertNotEqual(timeAfterStop, currentTime)
    }
    func testTimerCanHaveMultipleInstances() {

    }




    // + formatowanie Time Interval

}


// MARK: - Initialisation With Wrong Values
extension TimerTests {
    func testTimerDoesNotStart_StartTimeEqualsEndTime() {
        XCTAssertThrowsError(try MTimer.abc(every: 0.2, { _ in }).start(from: 0, to: 0)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .startTimeCannotBeTheSameAsEndTime)
        }
    }
    func testTimerDoesNotStart_StartIntervalIsLessThanZero() {
        XCTAssertThrowsError(try MTimer.abc(every: 0.2, { _ in }).start(from: -10, to: 5)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
    func testTimerDoesNotStart_EndIntervalIsLessThanZero() {
        XCTAssertThrowsError(try MTimer.abc(every: 0.2, { _ in }).start(from: 10, to: -15)) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .timeCannotBeLessThanZero)
        }
    }
}


// MARK: - Helpers
private extension XCTestCase {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}
