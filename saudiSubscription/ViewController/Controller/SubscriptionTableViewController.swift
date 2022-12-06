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
        slideLabel.text = "lklk"
        slideInFromLeft()
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
        UIView.animate(withDuration: 5.0, delay: 0, options: ([.allowAnimatedContent, .repeat]), animations: {() -> Void in
            self.slideLabel.center = CGPoint(x: -300 , y: self.slideLabel.center.y)
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
        }
    }
}

extension SubscriptionTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // old subscription count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        switch indexPath.row {
        case 0:
            cell.layer.maskedCorners =
            [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case 1:
            cell.layer.maskedCorners =  [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionTitle", for: indexPath) as? SubscriptionTitleTableViewCell
            return cell ?? UITableViewCell()
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionValue", for: indexPath) as? SubscriptionValueViewCell
            
            firebaseReference.child("oldSaudiSubscription").child("companyName").observe(.value) { (snap: DataSnapshot) in
                cell?.subscriptionName.text = snap.value as? String
            }
            
            firebaseReference.child("oldSaudiSubscription").child("subscriptionEndDate").observe(.value) { (snap: DataSnapshot) in
                    cell?.subscriptionEndDate.text = snap.value as? String
            }
            
            return cell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
}

extension UIView {
    public func setGradientBackgroundForCard() {
        let gradientLayer = CAGradientLayer()
        let middleColor = #colorLiteral(red: 0.5960784314, green: 0.6862745098, blue: 0.737254902, alpha: 1).cgColor
        let buttomColor = #colorLiteral(red: 0.9215686275, green: 0.6980392157, blue: 0.4370376483, alpha: 0.7763005945).cgColor
        gradientLayer.colors = [buttomColor, middleColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.frame
        gradientLayer.frame.size = self.frame.size
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension UILabel {

    func flash() {
        // Take as snapshot of the button and render as a template
        let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: snapshot)
        // Add it image view and render close to white
        imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
        guard let image = imageView.snapshot  else { return }
        let width = image.size.width
        let height = image.size.height
        // Create CALayer and add light content to it
        let shineLayer = CALayer()
        shineLayer.contents = image.cgImage
        shineLayer.frame = bounds

        // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
        // Adjust gradient to increase width and angle of highlight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.35, 0.50, 0.65, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        gradientLayer.frame = CGRect(x: -width, y: 0, width: width, height: height)
        // Create CA animation that will move mask from outside bounds left to outside bounds right
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        // How long it takes for glare to move across button
        animation.duration = 5
        // Repeat forever
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer

        // Add animation
        gradientLayer.add(animation, forKey: "shine")
    }
}

extension UIView {
    // Helper to snapshot a view
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
}
