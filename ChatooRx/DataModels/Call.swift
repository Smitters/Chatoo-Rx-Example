//
//  Call.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

class Call: TimedChatItem {
    static let chatItemType: ChatItemType = "Call_Type"

    let type: ChatItemType = chatItemType
    let uid: String
    let senderId: UUID
    let isIncoming: Bool
    let time: Date
    let status: Status

    init(uid: String = UUID().uuidString, status: Status, senderId: UUID, isIncoming: Bool, time: Date = Date()) {
        self.uid = uid
        self.status = status
        self.senderId = senderId
        self.isIncoming = isIncoming
        self.time = time
    }
}

extension Call {
    enum Status {
        case ended(duration: TimeInterval)
        case missed
        case canceled
        case inProgress
    }
}
