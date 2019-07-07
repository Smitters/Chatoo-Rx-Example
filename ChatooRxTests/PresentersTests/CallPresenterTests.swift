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
        let time = Date(timeIntervalSince1970: 0)
        let call = Call(status: .canceled, senderId: UUID(), isIncoming: false, time: time)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "at 3:00 AM")
    }

    func testTimeTextForMissedCall() {
        let time = Date(timeIntervalSince1970: 60 * 60 * 2)
        let call = Call(status: .missed, senderId: UUID(), isIncoming: false, time: time)
        let timeText = callPresenter.getTimeText(for: call)

        XCTAssertEqual(timeText, "at 5:00 AM")
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
