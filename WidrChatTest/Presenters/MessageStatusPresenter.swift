//
//  MessageStatusPresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class MessageStatusPresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let identifier = String(describing: MessageStatusCollectionViewCell.self)

        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    private let statusModel: MessageStatusSeparatorModel

    init(statusModel: MessageStatusSeparatorModel) {
        self.statusModel = statusModel
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 22
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MessageStatusCollectionViewCell.self), for: indexPath)
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let statusCell = cell as? MessageStatusCollectionViewCell else {
            fatalError("Invalid cell type. Expected: DateSeparatorCollectionViewCell")
        }

        statusCell.dateLabel.text = statusModel.date
        statusCell.statusImageView.image = image(for: statusModel.status)
    }

    private func image(for status: Message.Status) -> UIImage {
        switch status {
        case .delivered:
            return UIImage(imageLiteralResourceName: "delivered")
        case .error:
            return UIImage(imageLiteralResourceName: "error")
        case .read:
            return UIImage(imageLiteralResourceName: "read")
        case .sending:
            return UIImage(imageLiteralResourceName: "sending")
        case .sent:
            return UIImage(imageLiteralResourceName: "sent")
        }
    }
}

class MessageStatusPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == MessageStatusSeparatorModel.chatItemType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let statusModel = chatItem as? MessageStatusSeparatorModel else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: TimeSeparatorModel")
        }
        return MessageStatusPresenter(statusModel: statusModel)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return MessageStatusPresenter.self
    }
}
