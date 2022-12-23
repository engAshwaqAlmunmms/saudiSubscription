//
//  SubscriptionTableViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit
import Firebase

class SubscriptionTableViewController: UIViewController {
    
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var subscriptionStartDate: UILabel!
    @IBOutlet weak var subscriptionEndDate: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var subscriptionState: UILabel!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleVC: UILabel!
    
    var oldSubscriptionDictionary: [String: String] = [:] {
        willSet {
            self.tableView.reloadData()
        }
    }

    var endDateSubscription:String?
    var firebaseReference = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getValueToSubscriptionInfo()
        titleVC.flash()
    }
    
    private func setUpView() {
        
        self.motherView.setGradientBackgroundForCard()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        let nibFirstCell = UINib(nibName: "SubscriptionValueViewCell", bundle: nil)
        tableView.register(nibFirstCell, forCellReuseIdentifier: "SubscriptionValue")
        let nibSecondCell = UINib(nibName: "SubscriptionTitleTableViewCell", bundle: nil)
        tableView.register(nibSecondCell, forCellReuseIdentifier: "subscriptionTitle")
        slideInFromLeft()
        tableView.reloadData()
    }
    
    private func slideInFromLeft() {
        UIView.animate(withDuration: 9.0, delay: 0, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width/2 , y: self.slideLabel.center.y)
        })
    }
    
    public func getValueToSubscriptionInfo() {
        
        firebaseReference.child("saudiSubscription").child("companyName").observe(.value) { (snap: DataSnapshot) in
            self.companyName.text = snap.value as? String
        }
        
        firebaseReference.child("saudiSubscription").child("subscriptionStartDate").observe(.value) { (snap: DataSnapshot) in
            self.subscriptionStartDate.text = snap.value as? String
        }
        
        firebaseReference.child("saudiSubscription").child("subscriptionEndDate").observe(.value) { (snap: DataSnapshot) in
            self.subscriptionEndDate.text = snap.value as? String
            self.endDateSubscription = snap.value as? String
        }
        
        firebaseReference.child("saudiSubscription").child("bankName").observe(.value) { (snap: DataSnapshot) in
            self.bankName.text = snap.value as? String
        }
        
        firebaseReference.child("saudiSubscription").child("subscriptionState").observe(.value) { (snap: DataSnapshot) in
            self.subscriptionState.text = snap.value as? String
            self.calaulateDate()
        }
        
        firebaseReference.child("oldSaudiSubscription").observe(.value) {(snapshot) in
            if let eachDict = snapshot.value as? NSDictionary {
                let name = eachDict["companyName"] as? String
                let endDate = eachDict["subscriptionEndDate"] as? String
                self.getSubscription(subscriptionName: name ?? "", subscriptionDate: endDate ?? "")
            }
        }
    }
    
    private func getSubscription(subscriptionName: String, subscriptionDate: String) {
        DispatchQueue.main.async {
            self.oldSubscriptionDictionary[subscriptionName] = subscriptionDate
        }
    }
    
    private func calaulateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let endDate = dateFormatter.date(from:endDateSubscription ?? "") ?? Date()
        let todayDate = Date()
        let calculte = Int((todayDate - endDate).asDays())
        self.slideLabel.text = String("متبقي على نهاية الأكتتاب \(calculte) يوم")
    }
}

extension SubscriptionTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if oldSubscriptionDictionary.count == 0 {
            return 1
        }
        return oldSubscriptionDictionary.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 0
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.layer.cornerRadius = 10
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            cell.layer.cornerRadius = 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionTitle", for: indexPath) as? SubscriptionTitleTableViewCell
            cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524881325)
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionValue", for: indexPath) as? SubscriptionValueViewCell
        cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8629946677)
            let arrayOfKeys = Array(self.oldSubscriptionDictionary.keys.sorted(by: { $0 > $1 }))
            let arrayOfValues = Array(self.oldSubscriptionDictionary.values.sorted(by: { $0 > $1 }))
            cell?.subscriptionName.text = arrayOfKeys[indexPath.row]
            cell?.subscriptionEndDate.text = arrayOfValues[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
