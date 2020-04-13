//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit
import CoreData
import JJFloatingActionButton
import UserNotifications


class ListVC: UIViewController, JJFloatingActionButtonDelegate {
    
    var itemsArray = [Task]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var categoryName: String? {
        didSet {
           titleLabel.text = categoryName
        }
    }
    

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Homework"
        label.font = UIFont(name: "MuseoSans-500", size: 24)
        label.textColor = UIColor.mainGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLine: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.mainGrey
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let actionButton = JJFloatingActionButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureActionButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        tableView.register(EventCell.self, forCellReuseIdentifier: "eventCell")
        tableView.register(ReminderCell.self, forCellReuseIdentifier: "reminderCell")
        tableView.separatorStyle = .none
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItem = editButton
        
        
    
    }
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    
    func handleNewTask() {
        impact.impactOccurred()
        let vc = AddTaskVC()
        vc.selectedCategory = selectedCategory
        vc.amountOfCurrentTasks = itemsArray.count
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleNewEvent() {
        impact.impactOccurred()
        let vc = AddEventVC()
        vc.selectedCategory = selectedCategory
        vc.amountOfCurrentTasks = itemsArray.count
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func handleNewReminder() {
        if UserDefaults.standard.bool(forKey: "PremiumPurchased") == false {
            self.showNeedPremiumAlert()
        } else {
            impact.impactOccurred()
            let vc = AddReminderVC()
            vc.selectedCategory = selectedCategory
            vc.amountOfCurrentTasks = itemsArray.count
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    
    func saveOrder() {
        for i in 0...itemsArray.count - 1 {
            itemsArray[i].index = Int16(i)
        }
        
        saveItems()
    }
    
    
    
    
    
    
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    func loadItems(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        itemsArray = []

        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate

        do {
            itemsArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        itemsArray.sort { (a, b) -> Bool in
            a.index < b.index
        }
        
        tableView.reloadData()
    }
    
    func applyTheme() {
        titleLabel.textColor = Theme.current.tint
        
        actionButton.buttonColor = Theme.current.tint
        
        actionButton.configureDefaultItem { item in
            item.titlePosition = .leading
            
            item.titleLabel.font = UIFont(name: "MuseoSans-500", size: 17)
            item.titleLabel.textColor = UIColor.mainGrey
            item.buttonColor = Theme.current.tint
            item.buttonImageColor = .white
            
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0)
            item.layer.shadowRadius = CGFloat(2)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.mainGrey
        let customFont = UIFont(name: "MuseoSans-500", size: 17.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: customFont], for: .normal)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        applyTheme()
    }
    
    
    
    func setupLayout() {
        view.backgroundColor = .white
 
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        topView.addSubview(titleLabel)
        topView.addSubview(titleLine)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 35).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        
        titleLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        titleLine.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 35).isActive = true
        titleLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        titleLine.widthAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(tableView)
        
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
    }
    
    func configureActionButton() {
        actionButton.addItem(title: "Task", image: UIImage(named: "whitePencil")) { (JJActionItem) in
            self.handleNewTask()
        }
        actionButton.addItem(title: "Reminder", image: UIImage(named: "whiteBell")) { (JJActionItem) in
            self.handleNewReminder()
        }
        actionButton.addItem(title: "Event", image: UIImage(named: "whiteCal")) { (JJActionItem) in
            self.handleNewEvent()
        }
        
        actionButton.overlayView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
        actionButton.buttonColor = Theme.current.tint
        actionButton.buttonImageColor = .white
        
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.1)
        actionButton.layer.shadowRadius = CGFloat(4)
        
        actionButton.configureDefaultItem { item in
            item.titlePosition = .leading
            
            item.titleLabel.font = UIFont(name: "MuseoSans-500", size: 17)
            item.titleLabel.textColor = UIColor.mainGrey
            item.buttonColor = Theme.current.tint
            item.buttonImageColor = .white
            
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0)
            item.layer.shadowRadius = CGFloat(2)
        }
        
    }
    
    let impact = UIImpactFeedbackGenerator()
    
    func floatingActionButtonDidOpen(_ button: JJFloatingActionButton) {
        impact.impactOccurred()
    }
    
    
//    
//    // variable to save the last position visited, default to zero
//    private var lastContentOffset: CGFloat = 0
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(self.lastContentOffset > scrollView.contentOffset.y) &&
//            self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height) {
//            // move up
//            
//            UIView.animate(withDuration: 0.1) {
//                self.actionButton.alpha = 1
//            }
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y
//            && scrollView.contentOffset.y > 0) {
//            // move down
//            UIView.animate(withDuration: 0.1) {
//                self.actionButton.alpha = 0
//            }
//
//        }
//        
//        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.y
//    }
//    
    
    
}


extension ListVC: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = itemsArray[indexPath.row]
        
        if task.type == "task" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            cell.title = task.title
            cell.doneImage = task.done ? UIImage(named: "filledDone") : UIImage(named: "emptyDone")
            cell.hasCrossedOut = task.done
            cell.selectionStyle = .none
            cell.layoutSubviews()
            return cell
        }
    
        if task.type == "event" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
            cell.title = task.title
            cell.date = task.date
            cell.allDay = task.allDay
            cell.selectionStyle = .none
            cell.layoutSubviews()
            return cell
        }
        
        if task.type == "reminder" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderCell
            cell.title = task.title
            cell.date = task.date
            cell.selectionStyle = .none
            cell.layoutSubviews()
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "taskCell")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, UIView, complete: @escaping (Bool) -> Void) in
            
            if self.itemsArray[indexPath.row].type == "reminder" {
                let identifiers = self.itemsArray[indexPath.row].notificationId
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifiers!])
            }
            
            self.context.delete(self.itemsArray[indexPath.row])
            self.itemsArray.remove(at: indexPath.row)
            
            
            
            self.saveItems()
            complete(true)
            self.tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = itemsArray[indexPath.row]
        
        if task.type == "task" {
            if task.done == true {
                task.done = false
                impact.impactOccurred()
            } else {
                task.done = true
                impact.impactOccurred()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.saveItems()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let itemToMove = itemsArray[fromIndexPath.row]
        itemsArray.remove(at: fromIndexPath.row)
        itemsArray.insert(itemToMove, at: toIndexPath.row)
        saveOrder()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    
}

