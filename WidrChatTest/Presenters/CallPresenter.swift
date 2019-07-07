//
//  CallPresenter.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import UIKit

class CallPresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        let identifier = String(describing: CallCollectionViewCell.self)

        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    private let call: Call

    init(call: Call) {
        self.call = call
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat,
                       decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 98
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = String(describing: CallCollectionViewCell.self)
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath)
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let callCell = cell as? CallCollectionViewCell else {
            fatalError("Invalid cell type. Expected: DateSeparatorCollectionViewCell")
        }

        callCell.isLeftAligned = call.isIncoming
        callCell.statusLabel.text = getStatusText(for: call.status)
        callCell.timeLabel.text = getTimeText(for: call)
        callCell.imageView.layer.borderColor = getBorderColor(for: call.status).cgColor
        callCell.imageView.image = getImage(for: call.status)
    }

    func getImage(for status: Call.Status) -> UIImage {
        switch status {
        case .canceled:
            return UIImage(imageLiteralResourceName: "call_canceled")
        case .missed:
            return UIImage(imageLiteralResourceName: "call_missed")
        case .ended:
            return UIImage(imageLiteralResourceName: "call_ended")
        case .inProgress:
            return UIImage(imageLiteralResourceName: "call_active")
        }
    }

    func getStatusText(for status: Call.Status) -> String {
        switch status {
        case .canceled:
            return "Canceled call"
        case .missed:
            return "Missed call"
        case .ended:
            return "Call ended"
        case .inProgress:
            return "Call..."
        }
    }

    func getTimeText(for call: Call) -> String {
        switch call.status {
        case .canceled, .missed:
            return "at \(call.time.timeString)"
        case .ended(let duration):
            let seconds = Int(duration) % 60
            let minutes = Int(duration) / 60

            let minutesText = minutes > 1 ? "mins" : "min"
            let secondsText = seconds > 1 ? "secs" : "sec"

            return "\(minutes)\(minutesText) \(seconds)\(secondsText)"
        case .inProgress:
            let duration = Date().timeIntervalSince(call.time)
            let seconds = Int(duration) % 60
            let minutes = Int(duration) / 60
            let hours = Int(duration) / 3600

            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    func getBorderColor(for status: Call.Status) -> UIColor {
        switch status {
        case .canceled, .ended:
            return Colors.brownGrey
        case .missed:
            return Colors.lightPeach
        case .inProgress:
            return Colors.paleTurquoise
        }
    }
}

class CallPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem.type == Call.chatItemType
    }

    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        guard let callModel = chatItem as? Call else {
            fatalError("Invalid ChatItem Type: \(chatItem.type). Expected: CallModel")
        }
        return CallPresenter(call: callModel)
    }

    var presenterType: ChatItemPresenterProtocol.Type {
        return CallPresenter.self
    }
}
