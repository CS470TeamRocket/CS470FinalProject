//
//  AbilityStoreTableViewController.swift
//  SSP
//
//  Created by student on 11/24/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class AbilityStoreTableViewController: UITableViewController {
    var abilities: [AbilityModel] = []
    @IBOutlet weak var units: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        units.text = "units:" + String(UserDefaults.standard.integer(forKey: UserDataHolder.shared.TOTAL_CURRENCY))
        let center = units.center
        units.sizeToFit()
        units.center = center
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "5kHalfWide"))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //Generating dummy data
        abilities = UserDataHolder.shared.getAbilities()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return abilities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityCell", for: indexPath) as! AbilityStoreTableViewCell

        // Configure the cell...
        cell.useAbility(ability: abilities[indexPath.row])
        cell.layer.cornerRadius = 10
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AbilityStoreTableViewCell
        let currency = UserDefaults.standard.integer(forKey: UserDataHolder.shared.TOTAL_CURRENCY)
        let cost = Int(cell.AbilityCost.text)!
        if cost <= currency {
            cell.purchase()
            abilities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            let new  = UserDefaults.standard.integer(forKey: UserDataHolder.shared.TOTAL_CURRENCY) - cost
            removeCurrencyAnimation(old: currency, current: currency, new: new, ix: 50)
            //self.viewDidLoad()
        }
    }
    
    func removeCurrencyAnimation(old: Int, current: Int, new: Int, ix: Int) {
        if current - ix >= new {
            UIView.animate(withDuration: 1, animations: {
                //print(current-ix)
                self.units.text = "units:" + String(current-ix)
                UserDefaults.standard.set(current-ix, forKey: UserDataHolder.shared.TOTAL_CURRENCY)
                self.units.setNeedsLayout()
                }, completion: { finished in
                    //self.viewDidLoad()
                    self.removeCurrencyAnimation(old: old, current: current - ix, new: new, ix: ix)
            })
        }
        else if ix < 5 {
            self.removeCurrencyAnimation(old: old, current: current - 1, new: new, ix: 1)
        }
        else if current != new {
            self.removeCurrencyAnimation(old: old, current: current - ix/5, new: new, ix: ix/5)
        }

        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
