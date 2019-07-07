//
//  PhotoViewerViewModel.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

protocol PhotoViewerViewModelType {
    var photo: UIImage { get }
    func close()
}

class PhotoViewerViewModel: PhotoViewerViewModelType {
    private let coordinator: PhotoViewerCoordinatorType
    let photo: UIImage

    init(photo: UIImage, coordinator: PhotoViewerCoordinatorType) {
        self.photo = photo
        self.coordinator = coordinator
    }

    func close() {
        coordinator.dismiss()
    }
}
