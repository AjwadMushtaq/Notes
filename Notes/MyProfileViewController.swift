//
//  MyProfileViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 02/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase
class MyProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let properties = ["firstName" , "lastName", "email", "phoneNumber" ]
    let descriptions = ["First Name" , "Last Name" ,"Email", "Phone Number"]
    
    let firestore = Firestore.firestore()
    var authListener : AuthStateDidChangeListenerHandle?
    var profileListener : ListenerRegistration?
    
    @IBOutlet weak var profileTV: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    
    var currentUser : User? {
        didSet {
            
            if profileListener == nil {
                if let id = currentUser?.uid {
                    firestore.collection("profiles").document(id).addSnapshotListener { (snapshot, error) in
                        if error != nil {
                            print("HomeVC - error listening to profile changes")
                        } else if let data = snapshot?.data() {
                            self.currentUserProfile = data
                        }
                    }
                }
            }
            getUserProfile()
            
        }
    }
    
    
    
    var currentUserProfile : [String:Any]? {
        didSet {
            
            profileTV?.reloadData()
            //nameLabel?.text = "Welcome " + (currentUserProfile?["firstName"] as! String)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if authListener == nil {
                  authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
                      self.currentUser = user
                      if let user = user {
                          print("MyProfileVC - user signed in: \(user.uid)")
                          
                      } else {
                          print("MyProfileVC - no user!")
                          
                      }
                      
                  }
              }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Functions
    func getUserProfile() {
        if let user = currentUser {
            firestore.collection("profiles").document(user.uid).getDocument { (snapshot, error) in
                if error != nil {
                    print("Myprofile fetch Error: \(error!.localizedDescription)")
                } else {
                    if let profile = snapshot?.data() {
                        self.currentUserProfile = profile
                        
                    } else {
                        print("We don't have this profile, create it...")
                    }
                }
            }
        }
    }
    
    
    
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CreateProfileTableViewCell
        cell.cellOkButton.isHidden = true
        cell.cellLabel.text = descriptions[indexPath.row]
        cell.cellTF.text = currentUserProfile?[properties[indexPath.row]] as? String ?? "unknown"
        return cell
    }
    
    
    
}
