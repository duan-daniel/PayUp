//
//  ProfilesDetailedViewController.swift
//  PayUp
//
//  Created by Daniel Duan on 7/19/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import UIKit
import RealmSwift

class ProfilesDetailedViewController: UITableViewController {
    
    // var realm: Realm!
    var profile: Profile?
    /*
    var stillOwesYouArray: Results<AnOweToYou>! {
        didSet {
            tableView.reloadData()
        }
    }
    var youStillOweArray: Results<YourOweToSomeone>! {
        didSet {
            tableView.reloadData()
        }
    }
    var clearedOwesArray: Results<ClearedOwe>! {
        didSet {
            tableView.reloadData()
        }
    }
    */
//    var stillOwesYouArray: [AnOweToYou] = []
//    var youStillOweArray: [YourOweToSomeone] = []
//    var clearedOwesArray: [ClearedOwe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        profile!.stillOwesYouArray = RealmHelper.retrieveAnOweToYou()
//        profile!.youStillOweArray = RealmHelper.retrieveYourOweToSomeone()
//        profile!.clearedOweArray = RealmHelper.retrieveClearedOwes()

        self.navigationItem.title = profile?.name
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(profile)
//        stillOwesYouArray = Array(RealmHelper.retrieveAnOweToYou())
//        youStillOweArray = Array(RealmHelper.retrieveYourOweToSomeone())
//        clearedOwesArray = Array(RealmHelper.retrieveClearedOwes())
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerOne = ""
        var headerTwo = ""
        let headerThree = "Debt History:"
        
        if let strOne = profile?.owesYou {
            let stringOne = String(format: "%.2f", strOne)
            headerOne = "Still owes you $\(stringOne):"
        }
        if let strTwo = profile?.youOwe {
            let stringTwo = String(format: "%.2f", strTwo)
            headerTwo = "You still owe $\(stringTwo):"
        }
        
        let sections = [headerOne, headerTwo, headerThree]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        cell.headerLabel.text = sections[section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return profile!.stillOwesYouArray.count
//            return stillOwesYouArray.count
        }
        else if section == 1 {
            return profile!.youStillOweArray.count
//            return youStillOweArray.count
        }
        else {
            return profile!.clearedOweArray.count
//            return clearedOwesArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilesDetailedCell", for: indexPath) as! ProfilesDetailedTableViewCell
        
        if indexPath.section == 0 {
            let owe = profile!.stillOwesYouArray[indexPath.row]
//            let owe = stillOwesYouArray[indexPath.row]
            cell.dateLabel.text = owe.date
            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            cell.amountOwedLabel.text = "$\(oweAmt)"
            cell.purposeLabel.text = owe.purpose
            
        }
        else if indexPath.section == 1 {
            let owe = profile!.youStillOweArray[indexPath.row]
//            let owe = youStillOweArray[indexPath.row]
            cell.dateLabel.text = owe.date
            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            cell.amountOwedLabel.text = "$\(oweAmt)"
            cell.purposeLabel.text = owe.purpose
        }
        else {
            let owe = profile!.clearedOweArray[indexPath.row]
//            let owe = clearedOwesArray[indexPath.row]
            cell.dateLabel.text = owe.date
            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            cell.amountOwedLabel.text = "$\(oweAmt)"
            cell.purposeLabel.text = owe.purpose

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* remove thing
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var removeButton = UITableViewRowAction()
        
        if (indexPath.section == 0 || indexPath.section == 1) {
            let clearButton = UITableViewRowAction(style: .normal, title: "CLEAR") { (rowAction, indexPath) in
                if indexPath.section == 0 {
                    let owe = self.profile?.stillOwesYouArray[indexPath.row]
                    guard let debtStr = owe?.amount as? String else { return }
                    let debt = Double(debtStr)
                    self.profile?.owesYou -= debt!
                    
                    // reorder the row to put it to the bottom
                    self.profile?.stillOwesYouArray.remove(at: indexPath.row)
                    self.profile?.clearedOwes.append(owe!)
                }
                else if indexPath.section == 1 {
                    let owe = self.profile?.youStillOweArray[indexPath.row]
                    guard let debtStr = owe?.amount as? String else { return }
                    let debt = Double(debtStr)
                    self.profile?.youOwe -= debt!
                    
                    self.profile?.youStillOweArray.remove(at: indexPath.row)
                    self.profile?.clearedOwes.append(owe!)
                }
                tableView.reloadData()
            }
            clearButton.backgroundColor = UIColor.green
            return[clearButton]
        }
        else {
            removeButton = UITableViewRowAction(style: .normal, title: "Remove") { (rowAction, indexPath) in
                self.profile?.clearedOwes.remove(at: indexPath.row)
                tableView.reloadData()
            }
            removeButton.backgroundColor = UIColor.red
        }
        return[removeButton]
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        if identifier == "displayOwe" {
            print("displaying owe")
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destination = segue.destination as! DisplayOweViewController
            if indexPath.section == 0 {
                let owe = profile?.stillOwesYouArray[indexPath.row]
                destination.anOweToYou = owe
                destination.profile = self.profile
            }
            else if indexPath.section == 1 {
                let owe = profile?.youStillOweArray[indexPath.row]
                destination.yourOweToSomeone = owe
                destination.profile = self.profile
            }
            
        }
        else if identifier == "addOwe" {
            let destination = segue.destination as! DisplayOweViewController
            destination.profile = self.profile
            print("create owe bar button item tapped")
        }
        else {
            print("unexpected segue identifier")
        }
        
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {

    }
    
}

