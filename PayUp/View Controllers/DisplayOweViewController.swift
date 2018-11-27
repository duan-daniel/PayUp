//
//  DisplayOweViewController.swift
//  PayUp
//
//  Created by Daniel Duan on 7/23/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DisplayOweViewController: UIViewController, UITextFieldDelegate {
    
    var anOweToYou: AnOweToYou?
    var yourOweToSomeone: YourOweToSomeone?
    
    var profile: Profile?
    var realm: Realm!
    var youLent = true
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountOwedTextField: UITextField!
    @IBOutlet weak var purposeTextField: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        createDatePicker()
        setUpViews()
        purposeTextField.delegate = self
        saveBarButton.isEnabled = false
        [dateTextField, amountOwedTextField, purposeTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    // UI Stuff
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let date = dateTextField.text, !date.isEmpty,
            let amt = amountOwedTextField.text, !amt.isEmpty,
            let purpose = purposeTextField.text, !purpose.isEmpty
            else {
                saveBarButton.isEnabled = false
                return
        }
        saveBarButton.isEnabled = true
    }
    func setUpViews() {
        topView.layer.shadowOffset = CGSize(width: 0, height: 0)
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowRadius = 10
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.masksToBounds = true
        topView.layer.cornerRadius = 8
        
        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 8
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = #colorLiteral(red: 0.4549019608, green: 0.7490196078, blue: 0.8392156863, alpha: 1)
    }
    @objc func dismissKeyboard() {
        purposeTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        purposeTextField.resignFirstResponder()
        return true
    }
    func createDatePicker() {
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        amountOwedTextField.inputAccessoryView = toolbar
    }
    @objc func doneClicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if purposeTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let owe = anOweToYou {
            dateTextField.text = owe.date
            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            amountOwedTextField.text = "\(oweAmt)"
            purposeTextField.text = owe.purpose
            saveBarButton.isEnabled = true
            segControl.selectedSegmentIndex = owe.originalSegIndex
        }
        else if let owe = yourOweToSomeone {
            dateTextField.text = owe.date
            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            amountOwedTextField.text = "\(oweAmt)"
            purposeTextField.text = owe.purpose
            saveBarButton.isEnabled = true
            segControl.selectedSegmentIndex = owe.originalSegIndex
        }
        else {
            dateTextField.text = ""
            amountOwedTextField.text = ""
            purposeTextField.text = ""
        }
        
        // testing keyboard scrolling out
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func debtorChanged(_ sender: UISegmentedControl) {
        print("switched seg control to \(segControl.selectedSegmentIndex)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ProfilesDetailedViewController
            else { return }
        
        let debtor = segControl.selectedSegmentIndex
        print("debtor: \(debtor)")
        
        // you lent --> exisiting owe
        if identifier == "saveOwe" && anOweToYou != nil && debtor == 0 {
            print("changing an existing youLent owe")
            guard let profile = profile else { return }
            guard let debtStr = anOweToYou?.amount as? String else { return }
            let debt = Double(debtStr)
            
            print("selectedSegment Index: \(segControl.selectedSegmentIndex)")
            if debtor == anOweToYou?.originalSegIndex { // sticking with You Lent
                try! realm.write() {
                    profile.owesYou -= debt!
                    anOweToYou?.date = dateTextField.text ?? ""
                    anOweToYou?.amount = amountOwedTextField.text ?? ""
                    anOweToYou?.purpose = purposeTextField.text ?? ""
                }
                
                let debtString: String = (anOweToYou?.amount)!
                let newDebt: Double = Double(debtString)!
                
                try! realm.write() {
                    profile.owesYou += newDebt
                }
            }
            else {  // changed to You Owe
                print ("doing this shit")
                let indexOfOwe = profile.stillOwesYouArray.index(of: anOweToYou!)
                try! realm.write() {
                    profile.owesYou -= debt!
                    profile.stillOwesYouArray.remove(at: indexOfOwe!)
                }
        
                let revisedOwe = YourOweToSomeone()
                revisedOwe.originalSegIndex = 1
                revisedOwe.date = dateTextField.text ?? ""
                revisedOwe.amount = amountOwedTextField.text ?? ""
                revisedOwe.purpose = purposeTextField.text ?? ""
                
                
                // add the owe to the array
//                destination.profile?.stillOwesYouArray.append(revisedOwe)
                RealmHelper.addToYouOweSomeone(owe: revisedOwe, profile: profile)
            }
            
        }
        
        // you lent --> new one
        // THIS SHIT JUST GOT REALM-ED
        else if identifier == "saveOwe" && anOweToYou == nil && debtor == 0 {
            guard let profile = profile else { return }
            let owe = AnOweToYou()
            owe.originalSegIndex = 0
            owe.date = dateTextField.text ?? ""
            owe.amount = amountOwedTextField.text ?? ""
            owe.purpose = purposeTextField.text ?? ""
            RealmHelper.addAnOweToYou(owe: owe, profile: profile)
        }
        
        // you owe --> existing owe
        else if identifier == "saveOwe" && yourOweToSomeone != nil && debtor == 1 {
            print ("changing an existing You Still Owe")
            guard let profile = profile else { return }
            guard let debtStr = yourOweToSomeone?.amount as? String else { return }
            let debt = Double(debtStr)
            
            print("selectedSegment Index: \(segControl.selectedSegmentIndex)")
            if debtor == yourOweToSomeone?.originalSegIndex { // sticking with you owe
                try! realm.write() {
                    profile.youOwe -= debt!
                    yourOweToSomeone?.date = dateTextField.text ?? ""
                    yourOweToSomeone?.amount = amountOwedTextField.text ?? ""
                    yourOweToSomeone?.purpose = purposeTextField.text ?? ""
                }
                
                let debtString: String = (yourOweToSomeone?.amount)!
                let newDebt: Double = Double(debtString)!
                
                try! realm.write() {
                    profile.youOwe += newDebt
                }
            }
            else { //changed to You Lent
                print("this should be printing")
                let indexOfOwe = profile.youStillOweArray.index(of: yourOweToSomeone!)
                try! realm.write() {
                    profile.youOwe -= debt!
                    profile.youStillOweArray.remove(at: indexOfOwe!)
                }
                
                
                let revisedOwe = AnOweToYou()
                revisedOwe.originalSegIndex = 0
                revisedOwe.date = dateTextField.text ?? ""
                revisedOwe.amount = amountOwedTextField.text ?? ""
                revisedOwe.purpose = purposeTextField.text ?? ""
                

                // add the owe to the array
                // destination.profile?.youStillOweArray.append(revisedOwe)
                RealmHelper.addAnOweToYou(owe: revisedOwe, profile: profile)
                
            }
            
        }
        
        // you owe --> new owe
        else if identifier == "saveOwe" && yourOweToSomeone == nil && debtor == 1 {
            guard let profile = profile else { return }
            print("creating a brand new you owe")
            let owe = YourOweToSomeone()
            owe.originalSegIndex = 1
            owe.date = dateTextField.text ?? ""
            owe.amount = amountOwedTextField.text ?? ""
            owe.purpose = purposeTextField.text ?? ""

            RealmHelper.addToYouOweSomeone(owe: owe, profile: profile)

        }
        else {
            print("this should not print")
        }
        
        destination.tableView.reloadData()
        
    }
    
}
