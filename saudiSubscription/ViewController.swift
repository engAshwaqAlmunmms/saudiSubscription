//
//  ViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var subscriptionStartDate: UILabel!
    @IBOutlet weak var subscriptionEndDate: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var subscriptionState: UILabel!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var subscription: Subscription?
    var ref = Database.database().reference(withPath: "bankName")
    var refObservers: [DatabaseHandle] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackgroundForCard()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slideLabel.text = "hi ashwaq said"
        slideInFromLeft()
        fetchDataOfFirebase()
    }
    
    func itemInFirebase() {
        
        let items = Subscription(
            companyName: subscription?.companyName ?? "" ,
            startDate: subscription?.startDate ?? "",
            endDate: subscription?.endDate ?? "",
            bankName: subscription?.bankName ?? "",
            state: subscription?.state ?? false)
    }
    
    func fetchDataOfFirebase() {
        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            print(snapshot.value ?? "")
            let value = snapshot.value as? NSDictionary
            let name = value?["bankName"] as? String ?? ""
            print("\(name)")
            self.companyName.text = value?["bankName"] as? String ?? ""
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func setGradientBackgroundForCard() {
        let gradientLayer = CAGradientLayer()
        let middleColor = #colorLiteral(red: 0.5960784314, green: 0.6862745098, blue: 0.737254902, alpha: 1).cgColor
        let buttomColor = #colorLiteral(red: 0.9215686275, green: 0.6980392157, blue: 0.4, alpha: 1).cgColor
        gradientLayer.colors = [ buttomColor, middleColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.frame
        gradientLayer.frame.size = self.view.frame.size
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func slideInFromLeft() {
        UIView.animate(withDuration: 10.0, delay: 0, options: ([.curveEaseInOut, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width / 2, y: self.slideLabel.center.y)
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

