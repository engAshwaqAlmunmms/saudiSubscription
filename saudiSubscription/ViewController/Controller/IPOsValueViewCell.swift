//
//  IPOsValueViewCell.swift
//  saudiIPOs
//
//  Created by Ashwaq Alghamdi on 11.09.2022.
//

import UIKit

class IPOsValueViewCell: UITableViewCell {

    @IBOutlet public weak var offerEndDate: UILabel!
    @IBOutlet public weak var offerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8629946677)
        offerEndDate.textAlignment = .center
        offerEndDate.textColor = .black
        offerName.textAlignment = .center
        offerName.textColor = .black
    }
}
