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
    
    var owe: OweNote?
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
        print("WTFF")
        realm = try! Realm()
        createDatePicker()
        setUpViews()
        purposeTextField.delegate = self

        saveBarButton.isEnabled = false
        [dateTextField, amountOwedTextField, purposeTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let owe = owe {
            dateTextField.text = owe.date

            let junk = Double(owe.amount)
            let oweAmt = String(format: "%.2f", junk!)
            amountOwedTextField.text = "\(oweAmt)"
            purposeTextField.text = owe.purpose
            saveBarButton.isEnabled = true
            segControl.selectedSegmentIndex = owe.originalSegIndex
        } else {
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
    
    // testing some stuff
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

    
    @IBAction func debtorChanged(_ sender: UISegmentedControl) {
        print("switched seg control to \(segControl.selectedSegmentIndex)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("UNFF")
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ProfilesDetailedViewController
            else { return }
        
        let debtor = segControl.selectedSegmentIndex
        
        //you lent --> exisiting owe
        if identifier == "saveOwe" && owe != nil && debtor == 0 {
            
            guard let debtStr = owe?.amount as? String else { return }
            let debt = Double(debtStr)
            
            if segControl.selectedSegmentIndex == owe?.originalSegIndex {
                profile?.owesYou -= debt!
                
                owe?.date = dateTextField.text ?? ""
                owe?.amount = amountOwedTextField.text ?? ""
                owe?.purpose = purposeTextField.text ?? ""
                
                let debtString: String = (owe?.amount)!
                let newDebt: Double = Double(debtString)!
                profile?.owesYou += newDebt
            }
            else {
                profile?.youOwe -= debt!
                destination.profile?.youStillOweArray = (destination.profile?.youStillOweArray.filter { $0 !== owe})!
                
                
                let revisedOwe = OweNote()
                revisedOwe.originalSegIndex = 0
                revisedOwe.date = dateTextField.text ?? ""
                revisedOwe.amount = amountOwedTextField.text ?? ""
                revisedOwe.purpose = purposeTextField.text ?? ""
                
                profile?.owesYou += Double(revisedOwe.amount)!
                
                // add the owe to the array
                destination.profile?.stillOwesYouArray.append(revisedOwe)
            }

            
        }
        // you lent --> new one
        else if identifier == "saveOwe" && owe == nil && debtor == 0{
            print("HOLY FUUCK")
            let owe = OweNote()
            print("1")
            owe.originalSegIndex = 0
            owe.date = dateTextField.text ?? ""
            owe.amount = amountOwedTextField.text ?? ""
            owe.purpose = purposeTextField.text ?? ""
            print("2")
            
            profile?.owesYou += Double(owe.amount)!

            print("3")
            /*
            try! self.realm.write {
                self.realm.add(owe)
                print("got here")
                destination.profile?.stillOwesYouArray.append(owe)
            }
            */
            print("4")

            try! destination.realm.write {
                destination.realm.add(owe)
                destination.profile?.stillOwesYouArray.append(owe)
            }
            
            // add the owe to the array
            destination.profile?.stillOwesYouArray.append(owe)
        }
            
        // you owe --> exisiting owe
        else if identifier == "saveOwe" && owe != nil && debtor == 1 {
            
            guard let debtStr = owe?.amount as? String else { return }
            let debt = Double(debtStr)
            
            if segControl.selectedSegmentIndex == owe?.originalSegIndex {
                profile?.youOwe -= debt!
                
                owe?.date = dateTextField.text ?? ""
                owe?.amount = amountOwedTextField.text ?? ""
                owe?.purpose = purposeTextField.text ?? ""
                
                let debtString: String = (owe?.amount)!
                let newDebt: Double = Double(debtString)!
                profile?.youOwe += newDebt
            }
            else {
                profile?.owesYou -= debt!
                destination.profile?.stillOwesYouArray = (destination.profile?.stillOwesYouArray.filter { $0 !== owe})!
                
                
                let revisedOwe = OweNote()
                revisedOwe.originalSegIndex = 1
                revisedOwe.date = dateTextField.text ?? ""
                revisedOwe.amount = amountOwedTextField.text ?? ""
                revisedOwe.purpose = purposeTextField.text ?? ""
                
                profile?.youOwe += Double(revisedOwe.amount)!
                
                // add the owe to the array
                destination.profile?.youStillOweArray.append(revisedOwe)

            }
            
        }
        else if identifier == "saveOwe" && owe == nil && debtor == 1 {
            let owe = OweNote()
            owe.originalSegIndex = 1
            owe.date = dateTextField.text ?? ""
            owe.amount = amountOwedTextField.text ?? ""
            owe.purpose = purposeTextField.text ?? ""
            
            // add the owe to the profile's array of owes
            // profile?.profileOwes.append(owe)
            profile?.youOwe += Double(owe.amount)!
            
            // add the owe to the array
            destination.profile?.youStillOweArray.append(owe)
            owe.originalSegIndex = 1
        }
        else {
            print("unexpected segue identifier hMMMMM")
        }
        
        destination.tableView.reloadData()
        
    }
    
}
