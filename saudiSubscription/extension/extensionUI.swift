//
//  extensionUI.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit

extension UIColor {

    public func setGradientBackground(topColor: UIColor, middleColor: UIColor, buttomColor: UIColor, view: UIView) -> UIColor {
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, middleColor, buttomColor]
        gradientLayer.locations = [0.0, 1.0, 0.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at:0)
        
        return UIColor()
    }
    
}

