//
//  subsucription.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 25.06.2022.
//

import Foundation

struct Subscription {
    
    let ref: String?
    let companyName: String?
    let startDate: String?
    let endDate: String?
    let bankName: String?
    let state: Bool?
    
    init(companyName: String, startDate: String, endDate: String, bankName: String, state: Bool) {
        self.ref = nil
        self.companyName = companyName
        self.startDate = startDate
        self.endDate = endDate
        self.bankName = bankName
        self.state = state
    }
}
