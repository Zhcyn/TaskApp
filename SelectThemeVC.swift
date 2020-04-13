//  Task
//
//  Created by Luke Roberts on 11/08/2018.
//  Copyright © 2018 Definitive Apps. All rights reserved.
//

import UIKit

class SelectThemeVC: UITableViewController {

    var colorArray = ["Aluminium", "Amethyst", "Coral", "Fog", "Leaf", "Ocean", "Pine", "Tangerine", "Viola"]
    let CELL_ID = "colorCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.title = "Select Theme"
        
        tableView.register(ColorCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.separatorStyle = .none
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
        switch (indexPath.row) {
        case 0:
            Theme.current = AluminiumTheme()
            UserDefaults.standard.set("aluminium", forKey: "chosenTheme")
        case 1:
            Theme.current = AmethystTheme()
            UserDefaults.standard.set("amethyst", forKey: "chosenTheme")
        case 2:
            Theme.current = CoralTheme()
            UserDefaults.standard.set("coral", forKey: "chosenTheme")
        case 3:
            Theme.current = FogTheme()
            UserDefaults.standard.set("fog", forKey: "chosenTheme")
        case 4:
            Theme.current = LeafTheme()
            UserDefaults.standard.set("leaf", forKey: "chosenTheme")
        case 5:
            Theme.current = OceanTheme()
            UserDefaults.standard.set("ocean", forKey: "chosenTheme")
        case 6:
            Theme.current = PineTheme()
            UserDefaults.standard.set("pine", forKey: "chosenTheme")
        case 7:
            Theme.current = TangerineTheme()
            UserDefaults.standard.set("tangerine", forKey: "chosenTheme")
        case 8:
            Theme.current = ViolaTheme()
            UserDefaults.standard.set("viola", forKey: "chosenTheme")
        default:
            Theme.current = LeafTheme()
            UserDefaults.standard.set("leaf", forKey: "chosenTheme")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.popToRootViewController(animated: true)
        
    }

}
