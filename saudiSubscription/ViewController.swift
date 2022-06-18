//
//  ViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackgroundForCard()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slideLabel.text = "hi ashwaq said"
        slideInFromLeft()
    }
    
    public func setGradientBackgroundForCard() {
        let gradientLayer = CAGradientLayer()
        let middleColor = #colorLiteral(red: 0.5960784314, green: 0.6862745098, blue: 0.737254902, alpha: 1).cgColor
        let buttomColor = #colorLiteral(red: 0.9215686275, green: 0.6980392157, blue: 0.4, alpha: 1).cgColor
      //  let middleColor = #colorLiteral(red: 0.2509803922, green: 0.1294117647, blue: 0.2078431373, alpha: 1).cgColor
       // let buttomColor = #colorLiteral(red: 0.8509803922, green: 0.3882352941, blue: 0.2823529412, alpha: 1).cgColor
        gradientLayer.colors = [ buttomColor, middleColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.frame
        gradientLayer.frame.size = self.view.frame.size
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func slideInFromLeft() {
        UIView.animate(withDuration: 10.0, delay: 0, options: ([.curveEaseInOut, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width / 2, y: self.slideLabel.center.y)
        })
    }
}
