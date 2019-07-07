//
//  ChatDataSource.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

final class ChatDataSource: ChatDataSourceProtocol {

    weak var delegate: ChatDataSourceDelegateProtocol?
    var hasMoreNext = false
    var hasMorePrevious = false
    var chatItems: [ChatItemProtocol] = []

    func loadNext() { }
    func loadPrevious() { }
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        completion(false)
    }

    func update(with items: [ChatItemProtocol]) {
        chatItems = items
        delegate?.chatDataSourceDidUpdate(self)
    }
}
