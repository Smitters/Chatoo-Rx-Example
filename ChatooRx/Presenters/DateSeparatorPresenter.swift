//
//  DateSeparatorPresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class DateSeparatorPresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let identifier = String(describing: DateSeparatorCollectionViewCell.self)

        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    private let dateModel: DateSeparatorModel

    init(dateModel: DateSeparatorModel) {
        self.dateModel = dateModel
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 30
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DateSeparatorCollectionViewCell.self), for: indexPath)
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let dateCell = cell as? DateSeparatorCollectionViewCell else {
            fatalError("Invalid cell type. Expected: DateSeparatorCollectionViewCell")
        }

        dateCell.dateLabel.text = dateModel.date
    }
}

class DateSeparatorPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == DateSeparatorModel.chatItemType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let dateModel = chatItem as? DateSeparatorModel else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: DateSeparatorModel")
        }
        return DateSeparatorPresenter(dateModel: dateModel)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return DateSeparatorPresenter.self
    }
}
