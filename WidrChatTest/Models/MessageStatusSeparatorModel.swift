//
//  MessageStatusSeparatorModel.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

class MessageStatusSeparatorModel: ChatItemProtocol {
    let uid: String
    let type: String = MessageStatusSeparatorModel.chatItemType
    let date: String
    let status: Message.Status

    static var chatItemType: ChatItemType {
        return "statusSeparatorType"
    }

    init(uid: String, date: String, status: Message.Status) {
        self.date = date
        self.uid = uid
        self.status = status
    }
}
