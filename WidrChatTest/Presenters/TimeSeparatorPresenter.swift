//
//  TimeSeparatorPresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class TimeSeparatorPresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let identifier = String(describing: TimeSeparatorCollectionViewCell.self)

        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    private let timeModel: TimeSeparatorModel

    init(timeModel: TimeSeparatorModel) {
        self.timeModel = timeModel
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 22
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeSeparatorCollectionViewCell.self), for: indexPath)
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let timeCell = cell as? TimeSeparatorCollectionViewCell else {
            fatalError("Invalid cell type. Expected: DateSeparatorCollectionViewCell")
        }

        timeCell.timeLabel.text = timeModel.date
    }
}

class TimeSeparatorPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == TimeSeparatorModel.chatItemType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let timeModel = chatItem as? TimeSeparatorModel else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: TimeSeparatorModel")
        }
        return TimeSeparatorPresenter(timeModel: timeModel)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return TimeSeparatorPresenter.self
    }
}
