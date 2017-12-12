//
//  BonusStoreTableViewController.swift
//  Sun Switch
//
//  Created by student on 12/11/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class BonusStoreTableViewController: UITableViewController {

    var bonuses: [BonusModel] = []
    @IBOutlet weak var units: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        units.text = "Credits:" + String(UserDataHolder.shared.wallet)
        let center = units.center
        units.sizeToFit()
        units.center = center
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "5kHalfWide"))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        bonuses = UserDataHolder.shared.getLockedBonuses()
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
        return bonuses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BonusCell", for: indexPath) as! BonusStoreTableViewCell

        // Configure the cell...
        cell.useBonus(bonuses[indexPath.row])
        cell.layer.cornerRadius = 10
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BonusStoreTableViewCell
        let currency = UserDataHolder.shared.wallet
        let cost = Int(cell.bonusCost.text)!
        
        if cost <= currency {
            cell.purchase()
            bonuses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            removeCurrencyAnimation(old: currency, current: currency, new: currency-cost, ix:50)
        }
    }
 
    func removeCurrencyAnimation(old: Int, current: Int, new: Int, ix: Int) {
        if current - ix >= new {
            UIView.animate(withDuration: 1, animations: {
                self.units.text = "Credits:" + String(current-ix)
                self.units.setNeedsLayout()
            }, completion: { finished in
                self.removeCurrencyAnimation(old: old, current: current - ix, new: new, ix: ix)
            })
        }
        else if ix < 5 {
            self.removeCurrencyAnimation(old: old, current: current-1, new: new, ix: 1)
        }
        else if current != new {
            self.removeCurrencyAnimation(old: old, current: current-ix/5, new: new, ix: ix/5)
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
