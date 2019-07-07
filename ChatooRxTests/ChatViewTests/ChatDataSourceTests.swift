//
//  ChatDataSourceTests.swift
//  ChatooRxTests
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import XCTest
import Chatto
@testable import ChatooRx

class ChatDataSourceTests: XCTestCase {

    let dataSource = ChatDataSource()
    let delegate = MockDelegate()

    func testUpdate() {
        dataSource.delegate = delegate

        XCTAssertTrue(dataSource.chatItems.isEmpty)
        XCTAssertFalse(delegate.chatDataSourceDidUpdateCalled)

        dataSource.update(with: [Call(status: .canceled, senderId: UUID(), isIncoming: true)])

        XCTAssertEqual(dataSource.chatItems.count, 1)
        XCTAssertTrue(delegate.chatDataSourceDidUpdateCalled)
    }
}

class MockDelegate: ChatDataSourceDelegateProtocol {
    var chatDataSourceDidUpdateCalled = false
    func chatDataSourceDidUpdate(_ chatDataSource: ChatDataSourceProtocol) {
        chatDataSourceDidUpdateCalled = true
    }

    func chatDataSourceDidUpdate(_ chatDataSource: ChatDataSourceProtocol, updateType: UpdateType) {
        chatDataSourceDidUpdateCalled = true
    }
}
