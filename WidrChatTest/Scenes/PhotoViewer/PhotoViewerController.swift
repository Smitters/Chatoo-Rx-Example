//
//  ViewPhotoViewController.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoView: UIImageView!

    var viewModel: PhotoViewerViewModelType? {
        didSet {
            if isViewLoaded {
                connectViewModel()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        connectViewModel()
    }

    private func setupUI() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTaps))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }

    private func connectViewModel() {
        photoView.image = viewModel?.photo
    }

    @objc private func handleTaps() {
        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(4, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    @IBAction private func closeTapped(_ sender: Any) {
        viewModel?.close()
    }
}

extension PhotoViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
}
