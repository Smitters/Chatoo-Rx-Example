//
//  PhotoMessagePresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class PhotoMessagePresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let incomingPhotoIdentifier = "IncomingPhotoCollectionViewCell"
        let photoIdentifier = "PhotoCollectionViewCell"

        collectionView.register(UINib(nibName: photoIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: photoIdentifier)

        collectionView.register(UINib(nibName: incomingPhotoIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: incomingPhotoIdentifier)
    }

    private let message: Message
    private let photoSelectionCallback: (UIImage) -> Void

    init(message: Message, photoSelectionCallback: @escaping (UIImage) -> Void) {
        self.message = message
        self.photoSelectionCallback = photoSelectionCallback
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {

        if case .photo(let image) = message.content {
            let aspectRatio = image.size.width / image.size.height
            let horizontalOffset: CGFloat = 65
            let verticalInsets: CGFloat = 4

            let photoWidth = width - horizontalOffset
            let photoHeight = photoWidth / aspectRatio

            return photoHeight + verticalInsets
        } else {
            return 0
        }
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if message.isIncoming {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingPhotoCollectionViewCell", for: indexPath)
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath)
        }
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            fatalError("Invalid cell type. Expected: PhotoCollectionViewCell")
        }

        if case .photo(let image) = message.content {
            photoCell.photoImageView.image = image

            photoCell.selectionCallback = { [unowned self] in
                self.photoSelectionCallback(image)
            }
        }
    }
}

class PhotoMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {

    private let photoSelectionCallback: (UIImage) -> Void

    init(photoSelectionCallback: @escaping (UIImage) -> Void) {
        self.photoSelectionCallback = photoSelectionCallback
    }

    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == Message.photoMessageType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let message = chatItem as? Message else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: Message.")
        }
        return PhotoMessagePresenter(message: message, photoSelectionCallback: photoSelectionCallback)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return PhotoMessagePresenter.self
    }
}
