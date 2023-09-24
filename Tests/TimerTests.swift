import XCTest
@testable import MijickTimer

final class TimerTests: XCTestCase {
    func testTimerStarts() {

    }
    func testTimerIsCancellable() {

    }
    func testTimerIsResetable() {

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





    func testExample() throws {
        let expectation = expectation(description: "a")



        MTimer.abc(every: 1) { timeInterval in
            expectation.fulfill()
        }
        .start(from: 3, to: 10)

        
        waitForExpectations(timeout: 1.2)



    }
}
