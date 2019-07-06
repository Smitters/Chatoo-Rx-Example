//
//  GradientView.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import UIKit

class GradientView: UIView {

    private var gradientLayer: CAGradientLayer!

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    @IBInspectable var leftColor: UIColor = Colors.darkBlue {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var rightColor: UIColor = Colors.clearBlue {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
    }
}
