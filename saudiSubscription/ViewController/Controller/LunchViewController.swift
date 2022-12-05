//
//  LunchViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 6.12.2022.
//

import UIKit

class LunchViewController: UIViewController {
    
    @IBOutlet weak var lunchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackgroundForCard()
    }
}
