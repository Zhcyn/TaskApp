//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit


class PremiumVC: UIViewController {
    
    let crownImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "crown")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let taskPremiumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MuseoSans-500", size: 20)
        label.text = "TASK PREMIUM"
        label.textColor = .mainGrey
        label.addCharacterSpacing()
        return label
    }()
    
    let premiumFeaturesImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "premiumFeaturesLess")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Purchase Task Premium", for: .normal)
        button.backgroundColor = .mainGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "MuseoSans-500", size: 14)
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        return button
    }()
    
    let purchaseDisclaimer: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: "MuseoSans-500", size: 11)
        tv.text = "Task Premium Is A One Time Purchase And Is Not Subscription Based."
        tv.isSelectable = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textColor = .mainGrey
        tv.textAlignment = .center
        return tv
    }()
    
    @objc func handlePurchase() {
        if UserDefaults.standard.bool(forKey: "PremiumPurchased") == false {
            UserDefaults.standard.set(true, forKey: "PremiumPurchased")
        } else {
            UserDefaults.standard.set(false, forKey: "PremiumPurchased")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        
    }
    
    
    
    
    
    
    
    
    
    
    func setupLayout() {
        view.addSubview(crownImageView)
        crownImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        crownImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        crownImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        crownImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(taskPremiumLabel)
        taskPremiumLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 16).isActive = true
        taskPremiumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(premiumFeaturesImageView)
        premiumFeaturesImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        premiumFeaturesImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        premiumFeaturesImageView.topAnchor.constraint(equalTo: taskPremiumLabel.bottomAnchor, constant: 48).isActive = true
        premiumFeaturesImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        view.addSubview(purchaseDisclaimer)
        purchaseDisclaimer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        purchaseDisclaimer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        purchaseDisclaimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purchaseDisclaimer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(purchaseButton)
        purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purchaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: purchaseDisclaimer.topAnchor, constant: -8).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

}

