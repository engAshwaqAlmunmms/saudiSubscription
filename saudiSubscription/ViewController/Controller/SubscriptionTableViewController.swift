//
//  SubscriptionTableViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit
import Firebase

class SubscriptionTableViewController: UIViewController {
    
    // MARK : - @IBOutlet
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
    
    // MARK : - vairable
    var firebaseReference = Database.database().reference()
    private var endDateSubscription:String?
    private  var dictionaryOfSubscription = [String:String]()
    private var arrayOfSubscription = [Subscription]() {
        willSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getValueToSubscriptionInfo()
        titleVC.flash()
        load()
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: "subscription"),
              let savedSubscription = try? JSONDecoder().decode([Subscription].self, from: data) else { return arrayOfSubscription = [] }
        arrayOfSubscription = savedSubscription
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
        if arrayOfSubscription.count == 0 {
            tableView.isHidden = true
        }
        slideInFromLeft()
    }
    
    private func slideInFromLeft() {
        UIView.animate(withDuration: 9.0, delay: 0, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width/2 , y: self.slideLabel.center.y)
        })
    }
    
    private func getValueToSubscriptionInfo() {
        
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
        
        firebaseReference.child("oldSaudiSubscription").observe(.value, with: { [self] snapshot in
                if let eachDict = snapshot.value as? NSDictionary {
                    let name = eachDict["companyName"] as? String
                    let endDate = eachDict["subscriptionEndDate"] as? String
                    let newSubscription = Subscription(subscriptionName: name, subscriptionDate: endDate)
                        
                    self.dictionaryOfSubscription.updateValue(newSubscription.subscriptionDate ?? "", forKey: newSubscription.subscriptionName ?? "")
                    
                    for (key, value) in dictionaryOfSubscription {
                        var emptyArray = [Subscription]()
                        emptyArray.append(Subscription(subscriptionName: key, subscriptionDate: value))
                        
                        for values in emptyArray {
                            let name = !self.arrayOfSubscription.contains(where: {$0.subscriptionName == values.subscriptionName })
                            
                            let date = !self.arrayOfSubscription.contains(where: {$0.subscriptionDate == values.subscriptionDate })
                            
                            if name && date {
                                self.arrayOfSubscription.insert(values, at: 1)
                            }
                        }
                    }
                    
                    do {
                        let data = try JSONEncoder().encode(self.arrayOfSubscription)
                        UserDefaults.standard.set(data, forKey: "subscription")
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            })
        }
    
    private func calaulateDate() {
        self.slideLabel.textColor = .white
        guard endDateSubscription?.isEmpty == false else {return
            self.slideLabel.text = String("لا يوجد اكتتابات الأن")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let endDate = dateFormatter.date(from:endDateSubscription ?? "") ?? Date()
        let todayDate = Date()
        let calculte = Int((todayDate - endDate).asDays())
        self.slideLabel.text = String("متبقي على نهاية الأكتتاب \(abs(calculte)) يوم")
    }
    
}

extension SubscriptionTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSubscription.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionValue", for: indexPath) as? SubscriptionValueViewCell
        cell?.subscriptionName.text = arrayOfSubscription[indexPath.row].subscriptionName
        cell?.subscriptionEndDate.text = arrayOfSubscription[indexPath.row].subscriptionDate
        return cell ?? UITableViewCell()
    }
}
