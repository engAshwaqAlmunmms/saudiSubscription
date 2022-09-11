//
//  subscriptionTableViewCell.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 11.09.2022.
//

import UIKit

class subscriptionTableViewCell: UITableViewCell {

    @IBOutlet public weak var subscriptionNameLabel: UILabel!
    @IBOutlet public weak var subscriptionEndDateLabel: UILabel!
    @IBOutlet public weak var subscriptionName: UILabel!
    @IBOutlet public weak var subscriptionEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subscriptionNameLabel.textAlignment = .center
        subscriptionNameLabel.textColor = .brown
        subscriptionEndDateLabel.textAlignment = .center
        subscriptionEndDateLabel.textColor = .brown
        subscriptionName.textAlignment = .center
        subscriptionName.textColor = .brown
        subscriptionEndDate.textAlignment = .center
        subscriptionEndDate.textColor = .brown
    }

}
