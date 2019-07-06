//
//  Message.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

class Message: ChatItemProtocol {
    let uid: String
    let content: Content
    let senderId: UUID
    let isIncoming: Bool

    var status: Status
    var time: Date

    init(uid: String = UUID().uuidString, content: Content, status: Status, senderId: UUID, isIncoming: Bool, time: Date = Date()) {
        self.uid = uid
        self.content = content
        self.status = status
        self.time = time
        self.senderId = senderId
        self.isIncoming = isIncoming
    }

    var type: ChatItemType {
        switch content {
        case .photo:
            return Message.photoMessageType
        case .text:
            return Message.textMessageType
        }
    }
}

extension Message {

    static let photoMessageType = "photo_message"
    static let textMessageType = "text_message"

    enum Content {
        case text(String)
        case photo(UIImage)
    }

    enum Status {
        case sending
        case error
        case sent
        case delivered
        case read
    }
}
