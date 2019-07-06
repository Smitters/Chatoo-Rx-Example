//
//  ChatItemsDecorator.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto

class ChatItemsDecorator: ChatItemsDecoratorProtocol {
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        guard !chatItems.isEmpty else { return [] }

        let calendar = Calendar.current
        var decoratedItems: [DecoratedChatItem] = []

        if let firstMessage = chatItems.first as? Message {
            let dateSeparator = DateSeparatorModel(uid: firstMessage.uid + "date_separator", date: firstMessage.time.dateString)
            decoratedItems.append(DecoratedChatItem(chatItem: dateSeparator, decorationAttributes: nil))
        }

        for (index, item) in chatItems.enumerated() {
            guard let currentItem = item as? Message else { continue }

            if index > chatItems.startIndex, let previousItem = chatItems[index - 1] as? Message,
               !calendar.isDate(currentItem.time, inSameDayAs: previousItem.time) {

                let dateSeparator = DateSeparatorModel(uid: currentItem.uid + "date_separator", date: currentItem.time.dateString)
                decoratedItems.append(DecoratedChatItem(chatItem: dateSeparator, decorationAttributes: nil))
            }

            decoratedItems.append(DecoratedChatItem(chatItem: item, decorationAttributes: nil))

//            // Bottom separator (Time + Statuses)
//            if index == chatItems.endIndex {
//
//            } else {
//
//            }
        }

        return decoratedItems
    }
}
