//
//  TextMessagePresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class TextMessagePresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let incomingTextIdentifier = String(describing: IncomingTextMessageCollectionViewCell.self)
        let textIdentifier = "TextMessageCollectionViewCell"

        collectionView.register(UINib(nibName: incomingTextIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: incomingTextIdentifier)

        collectionView.register(UINib(nibName: textIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: textIdentifier)
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
            let horizontalInsets: CGFloat = 90
            let textWidth = width - horizontalInsets
            let constraintRect = CGSize(width: textWidth, height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: [.usesLineFragmentOrigin, .usesFontLeading],
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
        if message.isIncoming {
            return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IncomingTextMessageCollectionViewCell.self), for: indexPath)
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TextMessageCollectionViewCell", for: indexPath)
        }
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
