//
//  Storyboards.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/7/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

enum Storyboards {
    enum Main {
        private static let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)

        static func photoViewerController() -> PhotoViewerController {
            return mainStoryboard.instantiateViewController()
        }
    }
}

extension UIStoryboard {
    func instantiateViewController<T>() -> T {
        guard let controller = self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Cannot instantiate \(T.self). Do you add storyboardID?")
        }

        return controller
    }
}
