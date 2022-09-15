//
//  SubscriptionTitleTableViewCell.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.09.2022.
//

import UIKit

class SubscriptionTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriptionEndDate: UILabel!
    @IBOutlet weak var subscriptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subscriptionEndDate.textAlignment = .center
        subscriptionEndDate.textColor = .black
        subscriptionEndDate.text = "أنتهئ الأكتتاب منذ تاريخ"
        subscriptionName.textAlignment = .center
        subscriptionName.textColor = .black
        subscriptionName.text = "أسم الأكتتاب"


    }
}
