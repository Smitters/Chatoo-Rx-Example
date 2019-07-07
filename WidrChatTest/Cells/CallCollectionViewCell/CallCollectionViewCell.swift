//
//  CallCollectionViewCell.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

class CallCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var leadingConstraint: NSLayoutConstraint! // left
    @IBOutlet private var trailingConstraint: NSLayoutConstraint!  // right
    @IBOutlet private weak var bubbleView: UIView!

    var isLeftAligned: Bool = true {
        didSet {
            leadingConstraint.isActive = isLeftAligned
            trailingConstraint.isActive = !isLeftAligned
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = Colors.brownGrey.cgColor
        imageView.layer.borderWidth = 1

        bubbleView.layer.cornerRadius = 15
    }
}
