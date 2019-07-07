//
//  DateSeparatorModel.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

class DateSeparatorModel: ChatItemProtocol {
    let uid: String
    let type: String = DateSeparatorModel.chatItemType
    let date: String

    static var chatItemType: ChatItemType {
        return "dateSeparatorType"
    }

    init(uid: String, date: String) {
        self.date = date
        self.uid = uid
    }
}
