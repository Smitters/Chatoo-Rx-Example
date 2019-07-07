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

    func testDecoratedItemsOnSingleIncomingItem() {
        let message = Message(content: .text("Test"), status: .sent, senderId: UUID(), isIncoming: true)
        let decoratedItems = decorator.decorateItems([message])

        XCTAssertEqual(decoratedItems.count, 3)
    }

}
