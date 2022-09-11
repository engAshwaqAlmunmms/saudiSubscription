//
//  SubscriptionViewModel.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 12.09.2022.
//

import Foundation
import Firebase

class SubscriptionViewModel {
    
    enum SubscriptionInfo {
        case companyName
        case subscriptionStartDate
        case subscriptionEndDate
        case bankName
        case subscriptionState
    }

    var firebaseReference = Database.database().reference()
    var value: String?
    
    func getValueToSubscriptionInfo(info: SubscriptionInfo) {
        
        switch info {
        case .companyName:
            let data = firebaseReference.child("saudiSubscription").child("companyName")
            data.observe(.value) { (snap: DataSnapshot) in
                self.value = snap.value as? String ?? "-"
            }
        case .subscriptionStartDate:
            let data = firebaseReference.child("saudiSubscription").child("subscriptionStartDate")
            data.observe(.value) { (snap: DataSnapshot) in
                self.value = snap.value as? String ?? "-"
            }
        case .subscriptionEndDate:
            let data = firebaseReference.child("saudiSubscription").child("subscriptionEndDate")
            data.observe(.value) { (snap: DataSnapshot) in
                self.value = snap.value as? String ?? "-"
            }
        case .bankName:
            let data = firebaseReference.child("saudiSubscription").child("bankName")
            data.observe(.value) { (snap: DataSnapshot) in
                self.value = snap.value as? String ?? "-"
            }
        case .subscriptionState:
            let data = firebaseReference.child("saudiSubscription").child("subscriptionState")
            data.observe(.value) { (snap: DataSnapshot) in
                self.value = snap.value as? String ?? "-"
            }
        }
    }
}
