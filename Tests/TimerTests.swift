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
        var startTime: TimeInterval = 3

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

    }
    func testTimerStopsAutomatically() {

    }
    func testCannotInitialiseTimerWithWrongValues() {

    }
    func testTimerCanRunBackwards() {

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
