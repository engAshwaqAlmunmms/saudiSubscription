//
//  IPOsTableViewController.swift
//  saudiIPOs
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit
import Firebase

class IPOsTableViewController: UIViewController {
    
    // MARK : - @IBOutlet
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var offeringDate: UILabel!
    @IBOutlet weak var offeringCloseDate: UILabel!
    @IBOutlet weak var offeringBankName: UILabel!
    @IBOutlet weak var offeringPrice: UILabel!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleVC: UILabel!
    
    // MARK : - variable
    var firebaseReference = Database.database().reference()
    private var closeDateOffering:String?
    private  var dictionaryOfOffering = [String:String]()
    private var arrayOfOffering = [SaudiOffering]() {
        willSet{
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        load()
        titleVC.flash()
        getValueToOfferingInformationView()
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: "IPOs"),
              let savedOffer = try? JSONDecoder().decode([SaudiOffering].self, from: data) else { return arrayOfOffering = [] }
        arrayOfOffering = savedOffer
    }
    
    private func setUpView() {
        self.motherView.setGradientBackgroundForCard()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8629946677)
        let nibFirstCell = UINib(nibName: "IPOsValueViewCell", bundle: nil)
        tableView.register(nibFirstCell, forCellReuseIdentifier: "IPOValue")
        let nibSecondCell = UINib(nibName: "IPOsTitleTableViewCell", bundle: nil)
        tableView.register(nibSecondCell, forCellReuseIdentifier: "IPOTitle")
        if arrayOfOffering.count == 0 {
            tableView.isHidden = true
        }
        slideInFromLeft()
    }
    
    private func slideInFromLeft() {
        UIView.animate(withDuration: 9.0, delay: 0, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width/2 , y: self.slideLabel.center.y)
        })
    }
    
    private func getValueToOfferingInformationView() {
        
        firebaseReference.child("KSA_IPOs").child("COMPANY_NAME").observe(.value) { (snap: DataSnapshot) in
            self.companyName.text = snap.value as? String
        }
        
        firebaseReference.child("KSA_IPOs").child("OFFERING_DATE").observe(.value) { (snap: DataSnapshot) in
            self.offeringDate.text = snap.value as? String
        }
        
        firebaseReference.child("KSA_IPOs").child("CLOSING_DATE").observe(.value) { (snap: DataSnapshot) in
            self.offeringCloseDate.text = snap.value as? String
            self.closeDateOffering = snap.value as? String
        }
        
        firebaseReference.child("KSA_IPOs").child("OFFERING_BANK").observe(.value) { (snap: DataSnapshot) in
            self.offeringBankName.text = snap.value as? String
        }
        
        firebaseReference.child("KSA_IPOs").child("OFFERING_PRICE").observe(.value) { (snap: DataSnapshot) in
            self.offeringPrice.text = snap.value as? String
            self.calaulateDate()
        }
        
        firebaseReference.child("OLD_IPOs").observe(.value, with: { [self] snapshot in
            if let eachDict = snapshot.value as? NSDictionary {
                let name = eachDict["OFFERING_BANKS"] as? String
                let endDate = eachDict["CLOSING_DATE"] as? String
                let newSubscription = SaudiOffering(offeringName: name, offeringDate: endDate)
                
                self.dictionaryOfOffering.updateValue(newSubscription.offeringDate ?? "", forKey: newSubscription.offeringName ?? "")
                for (key, value) in dictionaryOfOffering {
                    var emptyArray = [SaudiOffering]()
                    emptyArray.append(SaudiOffering(offeringName: key, offeringDate: value))
                    for values in emptyArray {
                        let name = !self.arrayOfOffering.contains(where: {$0.offeringName == values.offeringName })
                        let date = !self.arrayOfOffering.contains(where: {$0.offeringDate == values.offeringDate })
                        if  name && date {
                            self.arrayOfOffering.insert(values, at: 1)
                        } else {
                            return
                        }
                    }
                }
                self.save()
            }
        })
        
        firebaseReference.child("removeOffer").observe(.value) { (snap: DataSnapshot) in
            if snap.value as? String != "" {
                self.arrayOfOffering.removeFirst()
                self.save()
            }
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self.arrayOfOffering)
            UserDefaults.standard.set(data, forKey: "IPOs")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func calaulateDate() {
        self.slideLabel.textColor = .white
        guard closeDateOffering?.isEmpty == false else {return
            self.slideLabel.text = String("لا يوجد اكتتابات الأن")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let endDate = dateFormatter.date(from:closeDateOffering ?? "") ?? Date()
        let todayDate = Date()
        let calculte = Int((todayDate - endDate).asDays())
        self.slideLabel.text = String("متبقي على نهاية الأكتتاب \(abs(calculte)) يوم")
    }
    
}

extension IPOsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfOffering.isEmpty {
            return 1
        }
        return arrayOfOffering.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            tableView.layer.cornerRadius = 10
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            tableView.layer.cornerRadius = 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IPOTitle", for: indexPath) as? IPOsTitleTableViewCell
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IPOValue", for: indexPath) as? IPOsValueViewCell
        cell?.offerName.text = arrayOfOffering[indexPath.row].offeringName
        cell?.offerEndDate.text = arrayOfOffering[indexPath.row].offeringDate
        return cell ?? UITableViewCell()
    }
}
