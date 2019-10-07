//
//  CreateProfileViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 02/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase



protocol CreateProfileProtocol {
    func doneCreatingProfile(profile:[String:Any]?, sender:UIViewController?)
}

class CreateProfileViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    var delegate : CreateProfileProtocol?
    
    @IBOutlet var cancleButton: UIButton!
    @IBOutlet var profileTV: UITableView!
    @IBOutlet var saveButton: UIButton!
    
    
    
    var createAccountDictionary = [String: Any]() {
        didSet {
            print("Current data: \(createAccountDictionary)")
        }
    }
    
    let properties = ["firstName" , "lastName", "email", "phoneNumber" ]
    let descriptions = ["First Name" , "Last Name" ,"Email", "Phone Number"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        
        
        Firestore.firestore().collection("profiles").document(id).setData(createAccountDictionary) { (error) in
            if error != nil {
                print("Error saving profile data: \(error!.localizedDescription)")
            } else {
                print("All good, saved the profile")
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.delegate?.doneCreatingProfile(profile: self.createAccountDictionary, sender: self)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    @IBAction func cancleButtonPressed(_ sender: UIButton) {
        
        delegate?.doneCreatingProfile(profile: nil, sender: self)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // did end on exit
    @IBAction func textField(_ sender: Any) {
    }
    
    
    
    // MARK: - FUNCTIONS
    
    func checkSaveButton() {
        saveButton.isEnabled = true
        properties.forEach { (one) in
            if createAccountDictionary[one] == nil {
                saveButton.isEnabled = false
            }
        }
    }
    
    
    
    
    //MARK: - DELEAGE CALLS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let cell = profileTV.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? CreateProfileTableViewCell {
            cell.cellOkButton.isHidden = false
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = profileTV.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? CreateProfileTableViewCell {
            cell.cellOkButton.isHidden = true
            createAccountDictionary[properties[textField.tag]] = cell.cellTF.text
            checkSaveButton()
        }
        checkSaveButton()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CreateProfileTableViewCell
        cell.cellLabel.text = descriptions[indexPath.row]
        cell.cellOkButton.tag = indexPath.row
        cell.cellTF.tag = indexPath.row
        cell.cellOkButton.isHidden = true
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return properties.count
        
    }
    
}
