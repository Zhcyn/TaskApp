//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController, MFMailComposeViewControllerDelegate {

    var sectionNames = ["Premium", "App Settings", "About"]
    let sectionOneItems = ["Go Premium"]
    let sectionTwoItems = ["List Delete Confirmation", "App Theme"]
    let sectionThreeItems = ["Rate Task", "Show Help", "Credit", "Any Questions?"]
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.getVersion()
        label.font = UIFont(name: "MuseoSans-500", size: 12)
        label.textColor = UIColor.mainGrey
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
        loadTableViewPrefs()
        
        self.title = "Settings"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "Version: \(version)"
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["lukerobertsapps@gmail.com"])
            mail.setSubject("Task - Feedback / Question")
            present(mail, animated: true)
        } else {
            self.showEmailErrorAlert()
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    fileprivate func rateApp(appId: String = "") {
        openUrl("itms-apps://itunes.apple.com/app/" + appId)  //change when have license
    }
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setupLayout() {
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(versionLabel)
        versionLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableViewPrefs() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "MuseoSans-500", size: 16)
        cell.textLabel?.textColor = UIColor.mainGrey
        
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = sectionOneItems[indexPath.row]
        case 1:
            cell.textLabel?.text = sectionTwoItems[indexPath.row]
        case 2:
            cell.textLabel?.text = sectionThreeItems[indexPath.row]
        default:
            cell.textLabel?.text = "Other"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return sectionOneItems.count
        }
        if section == 1 {
            return sectionTwoItems.count
        }
        if section == 2 {
            return sectionThreeItems.count
        }
        
        return 1
    }
    

    //might need to move label outside and apply theme when viewwillappear
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        view.addSubview(label)
        label.text = sectionNames[section]
        label.frame = CGRect(x: 14, y: 5, width: 100, height: 30)
        label.font = UIFont(name: "MuseoSans-500", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Theme.current.tint
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
        v.backgroundColor = .separatorGrey
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section) {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 {
                let vc = PremiumVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                showDeleteConfirmation()
            }
            if indexPath.row == 1 {
                
                if UserDefaults.standard.bool(forKey: "PremiumPurchased") == true {
                    let vc = SelectThemeVC()
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showNeedPremiumAlert()
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case 2:
            if indexPath.row == 0 {
                rateApp()
            }
            if indexPath.row == 1 {
                self.showOnboarding()
            }
            if indexPath.row == 2 {
                self.showCreditAlert()
            }
            if indexPath.row == 3 {
                sendEmail()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
}
