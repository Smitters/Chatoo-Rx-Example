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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }

    private func configureGradient() {
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
    }
}
