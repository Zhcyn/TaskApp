//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit

protocol ColorSelection {
    func colorChosen(color: String)
}


class SelectColorController: UITableViewController {
    
    
    
    var colorArray = ["Aluminium", "Amethyst", "Coral", "Fog", "Leaf", "Ocean", "Pine", "Tangerine", "Viola"]
    let CELL_ID = "colorCell"
    
    var delegate: ColorSelection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(ColorCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.separatorStyle = .none
        
        if UserDefaults.standard.bool(forKey: "PremiumPurchased") == true {
            colorArray = ["Aluminium", "Amethyst", "Coral", "Fog", "Leaf", "Ocean", "Pine", "Tangerine", "Viola", "Blush", "Charcoal", "Indigo", "Mineral", "Mustard", "Oak", "Powder"]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ColorCell
        
        cell.name = colorArray[indexPath.row]
        cell.color = colorArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.colorChosen(color: colorArray[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}
