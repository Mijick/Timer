//
//  MTimeTests.swift of Timer
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import XCTest
@testable import MijickTimer

final class MTimeTests: XCTestCase {}

// MARK: - Initialisation from TimeInterval
extension MTimeTests {
    func testTimeInitialisesCorrectly_1second() {
        let time = MTime(1)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 1)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_59seconds120milliseconds() {
        let time = MTime(59.12)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 59)
        XCTAssertEqual(time.milliseconds, 120)
    }
    func testTimeInitialisesCorrectly_21minutes37seconds() {
        let time = MTime(1297)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 21)
        XCTAssertEqual(time.seconds, 37)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_1hour39minutes17seconds140milliseconds() {
        let time = MTime(5957.14)

        XCTAssertEqual(time.hours, 1)
        XCTAssertEqual(time.minutes, 39)
        XCTAssertEqual(time.seconds, 17)
        XCTAssertEqual(time.milliseconds, 140)
    }
}

// MARK: - Initialisation from Values
extension MTimeTests {
    func testTimeInitialisesCorrectly_140milliseconds() {
        let time = MTime(milliseconds: 140)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 0)
        XCTAssertEqual(time.milliseconds, 140)
    }
    func testTimeInitialisesCorrectly_0point3seconds() {
        let time = MTime(seconds: 0.3)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 0)
        XCTAssertEqual(time.milliseconds, 300)
    }
    func testTimeInitialisesCorrectly_31seconds() {
        let time = MTime(seconds: 31.0)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 31)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_31point5seconds() {
        let time = MTime(seconds: 31.5)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 0)
        XCTAssertEqual(time.seconds, 31)
        XCTAssertEqual(time.milliseconds, 500)
    }
    func testTimeInitialisesCorrectly_107seconds() {
        let time = MTime(seconds: 107.0)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 1)
        XCTAssertEqual(time.seconds, 47)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_1point5minutes() {
        let time = MTime(minutes: 1.5)

        XCTAssertEqual(time.hours, 0)
        XCTAssertEqual(time.minutes, 1)
        XCTAssertEqual(time.seconds, 30)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_69minutes() {
        let time = MTime(minutes: 69.0)

        XCTAssertEqual(time.hours, 1)
        XCTAssertEqual(time.minutes, 9)
        XCTAssertEqual(time.seconds, 0)
        XCTAssertEqual(time.milliseconds, 0)
    }
    func testTimeInitialisesCorrectly_3hours72minutes21seconds14milliseconds() {
        let time = MTime(hours: 3.0, minutes: 72.0, seconds: 21.0, milliseconds: 14)

        XCTAssertEqual(time.hours, 4)
        XCTAssertEqual(time.minutes, 12)
        XCTAssertEqual(time.seconds, 21)
        XCTAssertEqual(time.milliseconds, 14)
    }
}

// MARK: - Converting to TimeInterval
extension MTimeTests {
    func testTimeConvertsCorrectly_ToTimeInterval_13milliseconds() {
        let time = MTime(hours: 0, minutes: 0, seconds: 0, milliseconds: 13)

        XCTAssertEqual(time.toTimeInterval(), 0.013, accuracy: 0.001)
    }
    func testTimeConvertsCorrectly_ToTimeInterval_33seconds() {
        let time = MTime(hours: 0, minutes: 0, seconds: 33, milliseconds: 0)

        XCTAssertEqual(time.toTimeInterval(), 33, accuracy: 0.001)
    }
    func testTimeConvertsCorrectly_ToTimeInterval_1minute9seconds() {
        let time = MTime(hours: 0, minutes: 0, seconds: 69, milliseconds: 0)

        XCTAssertEqual(time.toTimeInterval(), 69, accuracy: 0.001)
    }
    func testTimeConvertsCorrectly_ToTimeInterval_1hour13minutes14seconds() {
        let time = MTime(hours: 1, minutes: 13, seconds: 14, milliseconds: 0)

        XCTAssertEqual(time.toTimeInterval(), 4394, accuracy: 0.001)
    }
    func testTimeConvertsCorrectly_ToTimeInterval_33hours58minutes32seconds141milliseconds() {
        let time = MTime(hours: 33, minutes: 58, seconds: 32, milliseconds: 141)

        XCTAssertEqual(time.toTimeInterval(), 122312.141, accuracy: 0.001)
    }
}

// MARK: - Converting to String
extension MTimeTests {
    func testTimeConvertsCorrectly_ToString_3seconds() {
        let time = MTime(hours: 0, minutes: 0, seconds: 3, milliseconds: 0)

        XCTAssertEqual(time.toString(), "00:00:03")
    }
    func testTimeConvertsCorrectly_ToString_12minutes_33seconds() {
        let time = MTime(hours: 0, minutes: 12, seconds: 33, milliseconds: 0)

        XCTAssertEqual(time.toString(), "00:12:33")
    }
    func testTimeConvertsCorrectly_ToString_1hour_3minutes_17seconds() {
        let time = MTime(hours: 1, minutes: 3, seconds: 17, milliseconds: 0)

        XCTAssertEqual(time.toString(), "01:03:17")
    }
    func testTimeConvertsCorrectly_ToString_31hours_1minute_21seconds() {
        let time = MTime(hours: 31, minutes: 1, seconds: 21, milliseconds: 0)

        XCTAssertEqual(time.toString(), "31:01:21")
    }
}
