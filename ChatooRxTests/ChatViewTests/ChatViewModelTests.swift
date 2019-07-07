//
//  ChatViewModelTests.swift
//  ChatooRxTests
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import XCTest
import RxCocoa
@testable import ChatooRx

class ChatViewModelTests: XCTestCase {

    var mockCoordinator: MockCoordinator!
    var mockModel: MockModel!
    var viewModel: ChatViewModel!

    override func setUp() {
        mockCoordinator = MockCoordinator()
        mockModel = MockModel()
        viewModel = ChatViewModel(coordinator: mockCoordinator, model: mockModel)
    }

    override func tearDown() {
        mockCoordinator = nil
        mockModel = nil
        viewModel = nil
    }

    func testChatItems() {
        XCTAssertTrue(viewModel.chatItemsRelay.value.isEmpty)

        let call = Call(status: .canceled, senderId: UUID(), isIncoming: true)
        let message = Message(content: .text("test"), status: .read, senderId: UUID(), isIncoming: true)

        mockModel.callsRelay.accept([call])
        XCTAssertEqual(viewModel.chatItemsRelay.value.count, 1)

        mockModel.messagesRelay.accept([message])
        XCTAssertEqual(viewModel.chatItemsRelay.value.count, 2)

        mockModel.messagesRelay.accept([message, message, message])
        mockModel.callsRelay.accept([call, call])
        XCTAssertEqual(viewModel.chatItemsRelay.value.count, 5)
    }

    func testLoadData() {
        XCTAssertFalse(mockModel.loadMessagesCalled)
        XCTAssertFalse(mockModel.loadCallsCalled)
        XCTAssertFalse(mockModel.loadUserCalled)

        viewModel.loadData()

        XCTAssertTrue(mockModel.loadMessagesCalled)
        XCTAssertTrue(mockModel.loadCallsCalled)
        XCTAssertTrue(mockModel.loadUserCalled)
    }

    func testSendMessage() {
        XCTAssertNil(mockModel.sendedTex)

        let text = "Test"
        viewModel.send(text: text)

        XCTAssertEqual(mockModel.sendedTex, text)
    }

    func testSendPhoto() {
        XCTAssertNil(mockModel.sendedImage)

        let image = UIImage()
        viewModel.send(image: image)

        XCTAssertEqual(mockModel.sendedImage, image)
    }

    func testSelectPhoto() {
        XCTAssertFalse(mockCoordinator.showPhotoCalled)

        viewModel.select(photo: UIImage())

        XCTAssertTrue(mockCoordinator.showPhotoCalled)
    }
}

class MockCoordinator: ChatCoordinatorType {
    var showPhotoCalled = false
    func showPhoto(_ image: UIImage) {
        showPhotoCalled = true
    }
}

class MockModel: ChatModelType {
    var callsRelay = BehaviorRelay<[Call]>(value: [])
    var messagesRelay = BehaviorRelay<[Message]>(value: [])
    var userRelay = BehaviorRelay<User?>(value: nil)

    var loadMessagesCalled = false
    func loadMessages() {
        loadMessagesCalled = true
    }

    var loadCallsCalled = false
    func loadCalls() {
        loadCallsCalled = true
    }

    var loadUserCalled = false
    func loadUser() {
        loadUserCalled = true
    }

    var sendedTex: String?
    func send(text: String) {
        sendedTex = text
    }

    var sendedImage: UIImage?
    func send(image: UIImage) {
        sendedImage = image
    }
}
