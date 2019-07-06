//
//  IncomingTextMessageCollectionViewCell.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

class IncomingTextMessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 15
        textLabel.font = UIFont.systemFont(ofSize: 18)
    }
}
