//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UIViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let impact = UIImpactFeedbackGenerator()
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.bgGrey
        return view
    }()
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saturday, 28th"
        label.font = UIFont(name: "MuseoSans-500", size: 22)
        label.textColor = Theme.current.tint
        return label
    }()
    
    var monthLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "August"
        label.font = UIFont(name: "MuseoSans-500", size: 17)
        label.textColor = UIColor.mainGrey
        return label
    }()
    
    var listLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 Ongoing Lists"
        label.font = UIFont(name: "MuseoSans-500", size: 14)
        label.textColor = UIColor.mainGrey
        label.textAlignment = .right
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.mainGreen
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "MuseoSans-500", size: 40)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lists"
        label.font = UIFont(name: "MuseoSans-500", size: 20)
        label.textColor = UIColor.mainGreen
        return label
    }()
    
    
    func applyTheme() {
        titleLabel.textColor = Theme.current.tint
        addButton.backgroundColor = Theme.current.tint
        dateLabel.textColor = Theme.current.tint
        
        
    }
    
    let editBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        addButton.addTarget(self, action: #selector(handleNewCategory), for: .touchUpInside)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        editBtn.title = "Edit"
        editBtn.style = .plain
        editBtn.target = self
        editBtn.action = #selector(toggleEditing)
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [settingsButton, editBtn]

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    
    
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
        editBtn.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        applyTheme()
        
        if UserDefaults.standard.object(forKey: "onboardingShown") == nil {
            self.showOnboarding()
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    
    @objc func handleNewCategory() {
        impact.impactOccurred()
        let vc = AddCategoryVC()
        vc.numberOfCategories = categoryArray.count
        vc.categoryArray = categoryArray
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSettings() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func saveOrder() {
        for i in 0...categoryArray.count - 1 {
            categoryArray[i].index = Int32(i)
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
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        categoryArray.sort { (a, b) -> Bool in
            a.index < b.index
        }
        
        tableView.reloadData()
        updateUI()
    }
    
    //Mark: - Updating UI
    func updateUI() {
        if categoryArray.count > 1 || categoryArray.count == 0 {
            listLabel.text = "\(categoryArray.count) Ongoing Lists"
        } else {
            listLabel.text = "\(categoryArray.count) Ongoing List"
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let result = formatter.string(from: date)
        monthLabel.text = ("\(result)")

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "EEEE, dd"
        let result2 = formatter2.string(from: date)
        dateLabel.text = ("\(result2)")
        
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
        
        bottomView.addSubview(tableView)
        tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.9).isActive = true
        
        bottomView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        topView.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 20).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 1).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
        
        topView.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 20).isActive = true
        monthLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
        
        topView.addSubview(listLabel)
        listLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16).isActive = true
        listLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 10).isActive = true
        listLabel.leftAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        
        
        view.addSubview(addButton)
        addButton.centerYAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        addButton.layer.cornerRadius = self.view.frame.width * 0.125
    }




}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    //Mark: - TableView Data Source Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        let category = categoryArray[indexPath.row]
        cell.name = category.name
        cell.colour = category.colour
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Mark: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destination = ListVC()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray[indexPath.row]
            destination.categoryName = categoryArray[indexPath.row].name
            navigationController?.pushViewController(destination, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, UIView, complete: @escaping (Bool) -> Void) in
            
            if UserDefaults.standard.object(forKey: "showDeleteAlert") != nil {
                if UserDefaults.standard.bool(forKey: "showDeleteAlert") == false {
                    self.context.delete(self.categoryArray[indexPath.row])
                    self.categoryArray.remove(at: indexPath.row)
                    self.saveItems()
                    complete(true)
                    self.tableView.reloadData()
                    self.updateUI()
                    
                } else {
                    let alert = UIAlertController(title: "Are You Sure?", message: "All Tasks Inside This List Will Be Deleted. Proceed With Caution", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                        complete(false)
                    })
                    let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                        self.context.delete(self.categoryArray[indexPath.row])
                        self.categoryArray.remove(at: indexPath.row)
                        self.saveItems()
                        complete(true)
                        self.tableView.reloadData()
                        self.updateUI()
                    })
                    alert.view.tintColor = UIColor.mainGreen
                    alert.addAction(cancel)
                    alert.addAction(delete)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Are You Sure?", message: "All Tasks Inside This List Will Be Deleted. Proceed With Caution", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                    complete(false)
                })
                let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    self.context.delete(self.categoryArray[indexPath.row])
                    self.categoryArray.remove(at: indexPath.row)
                    self.saveItems()
                    complete(true)
                    self.tableView.reloadData()
                    self.updateUI()
                })
                alert.view.tintColor = UIColor.mainGreen
                alert.addAction(cancel)
                alert.addAction(delete)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let itemToMove = categoryArray[fromIndexPath.row]
        categoryArray.remove(at: fromIndexPath.row)
        categoryArray.insert(itemToMove, at: toIndexPath.row)
        saveOrder()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    
}
