//
//  PhotoCollectionViewCell.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    var selectionCallback: (() -> Void)?
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        photoImageView.addGestureRecognizer(tapRecognizer)
    }

    @objc private func onTap() {
        selectionCallback?()
    }
}
