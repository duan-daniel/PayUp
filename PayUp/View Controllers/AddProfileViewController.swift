//
//  AddProfileViewController.swift
//  PayUp
//
//  Created by Daniel Duan on 7/21/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// hi
// hello there my name is Daniel

class AddProfileViewController: UIViewController, UITextFieldDelegate {
    
    var realm: Realm!
        
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        nameTextField.delegate = self
        saveBarButton.isEnabled = false
        [nameTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let name = nameTextField.text, !name.isEmpty
        
            else {
                self.saveBarButton.isEnabled = false
                return
        }
        saveBarButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "saveNewProfile":
            let profile = Profile()
            
            profile.name = nameTextField.text ?? ""
            profile.owesYou = 0.00
            profile.youOwe = 0.00
            profile.stillOwesYouArray = [OweNote]()
            profile.youStillOweArray = [OweNote]()
            profile.clearedOwes = [OweNote]()
            
            let destination = segue.destination as! ProfilesTableViewController
            
            // pre realm:
            // destination.profiles.append(profile)
            
            // realm:
            try! self.realm.write {
                self.realm.add(profile)
            }
            
            destination.profile = profile
            destination.realm = realm
            
        case "cancelNewProifle":
            print("cancel bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }

}
