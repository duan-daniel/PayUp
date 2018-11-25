//
//  ProfilesTableViewController.swift
//  PayUp
//
//  Created by Daniel Duan on 7/18/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//  testing!

import UIKit
import RealmSwift

class ProfilesTableViewController: UITableViewController {
    
    var realm: Realm!
    private let image = UIImage(named: "add_profile")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Favorites"
    private let bottomMessage = "You don't have any favorites yet. All your favorites will show up here."
    
    // realm - 11/22/2018
    var profiles: Results<Profile> {
        get {
            return realm.objects(Profile.self)
        }
    }
    
    var summ: Summary?
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        setupEmptyBackgroundView()
        
    }
    
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        tableView.backgroundView = emptyBackgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if !tableView.visibleCells.isEmpty {
            tableView.backgroundView?.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilesTableViewCell", for: indexPath) as! ProfilesTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero

        let profile = profiles[indexPath.row]
        
        cell.profileNameLabel.text = profile.name
        
        print(profile.name + "\(profile.stillOwesYouArray.count)")
        let pendingDebts = profile.stillOwesYouArray.count + profile.youStillOweArray.count

        if pendingDebts == 1 {
            cell.owesYouLabel.text = "\(pendingDebts) pending debt"
        }
        else {
            cell.owesYouLabel.text = "\(pendingDebts) pending debts"
        }
        
        let clearedDebts = profile.clearedOweArray.count
        
        if clearedDebts == 1 {
            cell.youOweLabel.text = "\(clearedDebts) cleared debt"
        }
        else {
            cell.youOweLabel.text = "\(clearedDebts) cleared debts"
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDeets":
        
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            profile = profiles[indexPath.row]
            
            let destination = segue.destination as! ProfilesDetailedViewController
            destination.profile = profile            
            print("showing detailed view")
            
        case "cancelNewProfile":
            print("cancel bar button item tapped")
            
        default:
            print("dammit")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {

    }


}
