//
//  ChatooRxTests.swift
//  ChatooRxTests
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import XCTest
@testable import ChatooRx

class ChatItemsDecoratorTests: XCTestCase {

    let decorator = ChatItemsDecorator()

    func testDecoratedItemsOnEmtyCollection() {
        let decoratedItems = decorator.decorateItems([])
        XCTAssertTrue(decoratedItems.isEmpty)
    }

    func testDecorateItemsWithSingleIncomeMessage() {
        let message = Message(content: .text("Test"), status: .sent, senderId: UUID(), isIncoming: true)
        let decoratedItems = decorator.decorateItems([message])

        XCTAssertEqual(decoratedItems.count, 3)

        let firstItem = decoratedItems.first?.chatItem
        XCTAssertTrue(firstItem is DateSeparatorModel)

        let lastItem = decoratedItems.last?.chatItem
        XCTAssertTrue(lastItem is TimeSeparatorModel, "for income message should be TimeSeparatorModel")
    }

    func testDecoratedItemWithSingleOutcomeMessage() {
        let message = Message(content: .text("Test"), status: .sent, senderId: UUID(), isIncoming: false)
        let decoratedItems = decorator.decorateItems([message])

        XCTAssertEqual(decoratedItems.count, 3)

        let firstItem = decoratedItems.first?.chatItem
        XCTAssertTrue(firstItem is DateSeparatorModel)

        let lastItem = decoratedItems.last?.chatItem
        XCTAssertTrue(lastItem is MessageStatusSeparatorModel, "for outcome message should be MessageStatusSeparatorModel")
    }

    func testDecorateItemsWithTwoMessages() {
        let senderId = UUID()
        let message = Message(content: .text("Test"), status: .sent, senderId: senderId, isIncoming: true)

        let notSeparatedMessage = Message(content: .text("Test"), status: .sent, senderId: senderId, isIncoming: true)

        let decoratedItems = decorator.decorateItems([message, notSeparatedMessage])
        XCTAssertEqual(decoratedItems.count, 4, "Decorated items countshould be 4, cause senderId are equal and time offser less than 60 sec")

        let separatedMessage = Message(content: .text("Test"), status: .sent, senderId: UUID(), isIncoming: false)

        let decoratedItems2 = decorator.decorateItems([separatedMessage, message])
        XCTAssertEqual(decoratedItems2.count, 5, "Decorated items count should be 5, cause senderId aren't equal")
    }

    func testDecoratedItemsWithSingleCall() {
        let call = Call(status: .missed, senderId: UUID(), isIncoming: true)

        let decoratedItems = decorator.decorateItems([call])

        XCTAssertEqual(decoratedItems.count, 2, "Should be two: Date separator at the top and Call item")
    }

    func testDecoratedItemsWithTwoCallsInSameDay() {
        let call = Call(status: .missed, senderId: UUID(), isIncoming: true)
        let callInSameDay = Call(status: .ended(duration: 36), senderId: UUID(), isIncoming: true)

        let decoratedItems = decorator.decorateItems([call, callInSameDay])

        XCTAssertEqual(decoratedItems.count, 3, "Should be 3: Date separator at the top and 2 Call items")
    }

    func testDecoratedItemsWithTwoCallsInDifferentDays() {
        let twoDaysOffset: TimeInterval = -60 * 60 * 24 * 2
        let callWithOffset = Call(status: .missed, senderId: UUID(), isIncoming: true, time: Date().addingTimeInterval(twoDaysOffset))
        let call = Call(status: .ended(duration: 36), senderId: UUID(), isIncoming: true)

        let decoratedItems = decorator.decorateItems([callWithOffset, call])

        XCTAssertEqual(decoratedItems.count, 4, "Should be 4: Date separator | Item | DateSeparator | Item")
    }
}
