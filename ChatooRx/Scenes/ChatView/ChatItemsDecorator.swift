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

        if let firstMessage = chatItems.first as? TimedChatItem {
            let dateSeparator = DateSeparatorModel(uid: firstMessage.uid + "date_separator", date: firstMessage.time.dateString)
            decoratedItems.append(DecoratedChatItem(chatItem: dateSeparator, decorationAttributes: nil))
        }

        for (index, item) in chatItems.enumerated() {
            guard let currentItem = item as? TimedChatItem else { continue }

            // Top separators (Date)
            if index > chatItems.startIndex, let previousItem = chatItems[index - 1] as? TimedChatItem,
               !calendar.isDate(currentItem.time, inSameDayAs: previousItem.time) {

                let dateSeparator = DateSeparatorModel(uid: currentItem.uid + "date_separator", date: currentItem.time.dateString)
                decoratedItems.append(DecoratedChatItem(chatItem: dateSeparator, decorationAttributes: nil))
            }

            decoratedItems.append(DecoratedChatItem(chatItem: item, decorationAttributes: nil))

            // Bottom separator (Time + Statuses)

            guard let currentMessageItem = item as? Message else { continue }

            if index == chatItems.endIndex - 1{
                decoratedItems.append(createBottomDecoratedItem(for: currentMessageItem))
            } else if let nextItem = chatItems[index + 1] as? Message,
                          nextItem.senderId != currentItem.senderId ||
                          currentMessageItem.status == .error ||
                          currentMessageItem.status == .sending ||
                          nextItem.time.timeIntervalSince(currentItem.time) > 60 {

                    decoratedItems.append(createBottomDecoratedItem(for: currentMessageItem))
            } else if chatItems[index + 1] is Call {
                decoratedItems.append(createBottomDecoratedItem(for: currentMessageItem))
            }
        }

        return decoratedItems
    }

    private func createBottomDecoratedItem(for item: Message) -> DecoratedChatItem {
        if item.isIncoming {
            let timeSeparator = TimeSeparatorModel(uid: item.uid + "time_separator",
                                                   date: item.time.timeString)

            return DecoratedChatItem(chatItem: timeSeparator, decorationAttributes: nil)
        } else {
            let statusSeparator = MessageStatusSeparatorModel(uid: item.uid + "status_separator",
                                                              date: item.time.timeString,
                                                              status: item.status)

            return DecoratedChatItem(chatItem: statusSeparator, decorationAttributes: nil)
        }
    }
}
