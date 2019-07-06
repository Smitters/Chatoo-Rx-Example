//
//  Presenters.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class TextMessagePresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let identifier = String(describing: IncomingTextMessageCollectionViewCell.self)

        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    private let message: Message

    init(message: Message) {
        self.message = message
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {

        if case .text(let text) = message.content {
            let horizontalInsets: CGFloat = 85
            let textWidth = width - horizontalInsets
            let constraintRect = CGSize(width: textWidth, height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)],
                                                context: nil)

            let textHeight = ceil(boundingBox.height)
            let verticalInsets: CGFloat = 25
            return textHeight + verticalInsets
        } else {
            return 0
        }
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IncomingTextMessageCollectionViewCell.self), for: indexPath)
        return cell
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let textCell = cell as? IncomingTextMessageCollectionViewCell else {
            fatalError("Invalid cell type. Expected: IncomingTextMessageCollectionViewCell")
        }

        if case .text(let text) = message.content {
            textCell.textLabel.text = text
        }
    }
}

class TextMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == Message.textMessageType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let message = chatItem as? Message else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: Message.")
        }
        return TextMessagePresenter(message: message)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return TextMessagePresenter.self
    }
}
