//
//  LunchViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 6.12.2022.
//

import UIKit

class LunchViewController: UIViewController {
    
    @IBOutlet weak var lunchTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lunchTitle.flash()
        self.view.setGradientBackgroundForCard()
    }
}
