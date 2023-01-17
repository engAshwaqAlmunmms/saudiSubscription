//
//  SubscriptionTitleTableViewCell.swift
//  saudiIPOs
//
//  Created by Ashwaq Alghamdi on 15.09.2022.
//

import UIKit

class IPOsTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var offerEndDate: UILabel!
    @IBOutlet weak var offerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524881325)
        offerEndDate.textAlignment = .center
        offerEndDate.textColor = .black
        offerEndDate.text = "أنتهى الأكتتاب منذ تاريخ"
        offerName.textAlignment = .center
        offerName.textColor = .black
        offerName.text = "أسم الأكتتاب"
    }
}
