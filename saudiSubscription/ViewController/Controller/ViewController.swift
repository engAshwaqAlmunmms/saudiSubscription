//
//  ViewController.swift
//  saudiSubscription
//
//  Created by Ashwaq Alghamdi on 15.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var subscriptionStartDate: UILabel!
    @IBOutlet weak var subscriptionEndDate: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var subscriptionState: UILabel!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var subscriptionViewModel = SubscriptionViewModel()
    var endDateSubscription:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        
        setGradientBackgroundForCard()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        slideInFromLeft()
        
        let nibFirstCell = UINib(nibName: "SubscriptionTableViewCell", bundle: nil)
        tableView.register(nibFirstCell, forCellReuseIdentifier: "infoEndDateSubscription")
        let nibSecondCell = UINib(nibName: "SubscriptionTitleTableViewCell", bundle: nil)
        tableView.register(nibSecondCell, forCellReuseIdentifier: "subscriptionTitle")
        
        subscriptionViewModel.getValueToSubscriptionInfo(info: .companyName, value: self.companyName)
        subscriptionViewModel.getValueToSubscriptionInfo(info: .subscriptionStartDate, value: self.subscriptionStartDate)
        subscriptionViewModel.getValueToSubscriptionInfo(info: .subscriptionEndDate, value: self.subscriptionEndDate)
        subscriptionViewModel.getValueToSubscriptionInfo(info: .bankName, value: self.bankName)
        subscriptionViewModel.getValueToSubscriptionInfo(info: .subscriptionState, value: self.subscriptionState)
        }
    
    private func setGradientBackgroundForCard() {
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
    
    private func calaulateDate() {
        let isoDate = endDateSubscription ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "ar")
        let endDate = dateFormatter.date(from:isoDate) ?? Date()
        let todayDate = Date()
        if todayDate > endDate {
            self.slideLabel.text = "\(endDate)"
        }
    }
    
    private func slideInFromLeft() {
        UIView.animate(withDuration: 10.0, delay: 0, options: ([.curveEaseInOut, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: 0 - self.slideLabel.bounds.size.width / 2, y: self.slideLabel.center.y)
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // name subscription count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionTitle", for: indexPath) as? SubscriptionTitleTableViewCell
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoEndDateSubscription", for: indexPath) as? SubscriptionTableViewCell
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
        
    }
    
}
