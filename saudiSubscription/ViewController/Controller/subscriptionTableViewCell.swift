//
//  \'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 11.09.2022.
//

import UIKit


class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet public weak var subscriptionName: UILabel!
    @IBOutlet public weak var subscriptionEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }
    
    private func cellStyle() {
        subscriptionName.textAlignment = .center
        subscriptionName.textColor = .black
        subscriptionEndDate.textAlignment = .center
        subscriptionEndDate.textColor = .black
    }
}
