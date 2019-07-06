//
//  Coordinator.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

protocol AppCoordinatorType {
    func startApplication()
}

protocol ChatCoordinatorType {
    func showPhoto(_ image: UIImage)
}

class Coordinator {

    private let window: UIWindow?
    private let navigationController: UINavigationController?

    private var topViewController: UIViewController? {
        if let presented = navigationController?.presentedViewController {
            return presented
        } else {
            return navigationController?.topViewController
        }
    }

    init(window: UIWindow?) {
        self.window = window
        self.navigationController = window?.rootViewController as? UINavigationController
    }
}

extension Coordinator: AppCoordinatorType {
    func startApplication() {
        if let chatViewController = navigationController?.children.first as? ChatViewController {
            let model = MockChatModel()
            let viewModel = ChatViewModel(coordinator: self, model: model)

            chatViewController.dataSource = ChatDataSource()
            chatViewController.viewModel = viewModel
        }
    }
}

extension Coordinator: ChatCoordinatorType {
    func showPhoto(_ image: UIImage) {
        #warning("TODO: show detailed photo with zoom")
    }
}
