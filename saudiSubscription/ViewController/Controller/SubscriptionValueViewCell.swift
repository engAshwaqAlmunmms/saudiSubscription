//
//  SubscriptionValueViewCell.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 11.09.2022.
//

import UIKit

class SubscriptionValueViewCell: UITableViewCell {

    @IBOutlet public weak var subscriptionEndDate: UILabel!
    @IBOutlet public weak var subscriptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }
    
    private func cellStyle() {
        subscriptionEndDate.textAlignment = .center
        subscriptionEndDate.textColor = .black
        subscriptionName.textAlignment = .center
        subscriptionName.textColor = .black
    }
}
