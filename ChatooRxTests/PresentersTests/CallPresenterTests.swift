//
//  CallPresenterTests.swift
//  ChatooRxTests
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import XCTest
@testable import ChatooRx

class CallPresenterTests: XCTestCase {

    var callPresenter: CallPresenter!

    override func setUp() {
        callPresenter = CallPresenter(call: Call(status: .canceled, senderId: UUID(), isIncoming: true))
    }

    override func tearDown() {
        callPresenter = nil
    }

    func testTimeTextForCanceledCall() {
        let components = DateComponents(calendar: .current, timeZone: .current, year: 2000, month: 1, day: 1, hour: 1, minute: 25)
        let time = components.date ?? Date()
        let call = Call(status: .canceled, senderId: UUID(), isIncoming: false, time: time)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "at 1:25 AM")
    }

    func testTimeTextForMissedCall() {
        let components = DateComponents(calendar: .current, timeZone: .current, year: 2000, month: 1, day: 1, hour: 15, minute: 45)
        let time = components.date ?? Date()
        let call = Call(status: .missed, senderId: UUID(), isIncoming: false, time: time)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "at 3:45 PM")
    }

    func testTimeTextForEndedCall() {
        let duration: TimeInterval = (60 * 35) + 25  // 35:25
        let call = Call(status: .ended(duration: duration), senderId: UUID(), isIncoming: false)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "35 mins 25 secs")

        let singularFormDuration: TimeInterval = 61  // 1:01
        let shortCall = Call(status: .ended(duration: singularFormDuration), senderId: UUID(), isIncoming: false)

        XCTAssertEqual(callPresenter.getTimeText(for: shortCall), "1 min 1 sec")
    }

    func testTimeForCallInProgress() {
        let offset: TimeInterval = TimeInterval(60 * 60 * 2 + 60 * 45 + 23)  // 02:45:23
        let time = Date().addingTimeInterval(-offset)
        let call = Call(status: .inProgress, senderId: UUID(), isIncoming: false, time: time)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "02:45:23")
    }
}
