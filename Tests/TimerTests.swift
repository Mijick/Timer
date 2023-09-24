import XCTest
@testable import MijickTimer

final class TimerTests: XCTestCase {
    var currentTime: TimeInterval = 0


    func testTimerStarts() {
        let expectation = expectation(description: "")

        MTimer
            .abc(every: 1) { _ in expectation.fulfill() }
            .start()

        waitForExpectations(timeout: 1.2)
    }
    func testTimerIsCancellable() {
        MTimer
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

        MTimer
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

        MTimer
            .abc(every: 0.1) { _ in }
            .onStatusChange { statuses[$0] = true }
            .start()
        wait(for: 0.4)

        MTimer.stop()
        wait(for: 0.4)

        XCTAssertTrue(statuses.values.filter { !$0 }.isEmpty)
    }
    func testTimerStopsAutomatically_WhenGoesForward() {
        MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 0, to: 2)
        wait(for: 3)

        XCTAssertEqual(currentTime, 2)
    }
    func testTimerStopsAutomatically_WhenGoesBackward() {
        MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 3, to: 1)
        wait(for: 3)

        XCTAssertEqual(currentTime, 1)
    }
    func testDoesNotStart_StartTimeEqualsEndTime() {
        MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 0, to: 0)
        wait(for: 1)

        XCTAssertEqual(currentTime, 0)
    }
    func testCannotInitialiseTimer_LaunchTimerWithoutInitialisation() {
        XCTAssertThrowsError(try MTimer.resume()) { error in
            let error = error as! MTimer.Error
            XCTAssertEqual(error, .cannotResumeNotInitialisedTimer)
        }
    }
    func testTimerCanRunBackwards() {
        MTimer
            .abc(every: 0.2) { self.currentTime = $0 }
            .start(from: 3, to: 1)
        wait(for: 1)

        XCTAssertLessThan(currentTime, 3)
    }
    func testTimerCanBeResumed() {

    }
    func testTimerCanStartFromNonZeroValue() {

    }
    func testTimerCanHaveMultipleInstances() {

    }
    func testTimerCountsTimeWhenAppReturnsFromBackground() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)

        let myApp = XCUIApplication()
        myApp.activate() // bring to foreground
    }




    // + formatowanie Time Interval

}


extension TimerTests {

}




extension XCTestCase {

    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
