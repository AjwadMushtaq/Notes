//
//  ViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 23/09/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CreateProfileProtocol {
    
    
    
    
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var menuTV: UITableView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    
    lazy var firestore = Firestore.firestore()
    var authListener : AuthStateDidChangeListenerHandle?
    var profileListener : ListenerRegistration?
    
    var documentId: [String] = []
    var notesArray : [Note] = []
    
    
    var currentUserProfile : [String:Any]? {
        didSet {
            print("HomeVC - currentUserProfile SET")
            setupUserProfileData()
        }
    }
    
    var currentUser : User?{
        didSet {
            nameLable?.text = currentUser?.uid ?? "none"
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
    
    
    
    var menuItems : [String] = ["Log In","About", "Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if authListener == nil {
            authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
                self.currentUser = user
                if let user = user {
                    print("HomeVC - user signed in: \(user.uid)")
                    
                    
                    self.menuItems = ["About" , "My Profile","Notes" ,"Log Out"]
                    //self.downloadNotesData()
                } else {
                    print("HomeVC - no user!")
                    self.menuItems = ["Log In", "About"]
                }
                self.menuTV.reloadData()
            }
        }
        
        
    }
    
    //MARK: - Delegate
    
    func doneCreatingProfile(profile: [String : Any]?, sender: UIViewController?) {
        
        if profile != nil {
            print("Woohooo, profile created")
        } else {
            print("This is bad, profile creation cancelled")
        }
        
        sender?.dismiss(animated: true, completion: {
            
        })
    }
    
    //MARK: - ACTIONS
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        showAndHideMenu()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        showAndHideMenu()
    }
    
    //MARK: - FUNCTIONS
    func showAndHideMenu() {
        print("HomeVC - showAndHideMenu")
        if menuLeadingConstraint.constant == -240 {
            menuLeadingConstraint.constant = 0
        } else {
            menuLeadingConstraint.constant = -240
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getUserProfile() {
        if let user = currentUser {
            firestore.collection("profiles").document(user.uid).getDocument { (snapshot, error) in
                if error != nil {
                    print("HomeVC profile fetch Error: \(error!.localizedDescription)")
                } else {
                    if let profile = snapshot?.data() {
                        self.currentUserProfile = profile
                    } else {
                        print("We don't have this profile, create it...")
                        
                        self.performSegue(withIdentifier: "createProfile", sender: self)
                    }
                }
            }
        }
    }
    
    func setupUserProfileData() {
        nameLable.text = currentUserProfile?["firstName"] as? String ?? "noname"
    }
    
    
    func downloadNotesData() {
        
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        
        
        Firestore.firestore().collection("notes").document(id).collection("note").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Notes documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let newNote = Note(date: document["date"] as! String, note: document["note"] as!String)
                    
                    self.notesArray.append(newNote)
                    
                    
                    
                    
                    self.documentId.append(document.documentID)
                    
                }
            }
        }
        
    }
    
    func logIn() {
        //if Auth.auth().currentUser == nil {
        performSegue(withIdentifier: "toSignUp", sender: self)
        //}
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("HomeVC - Succesfully Signed Out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func myProfile()  {
        performSegue(withIdentifier: "myProfile", sender: self)
    }
    
    
    func notes()  {
        performSegue(withIdentifier: "toNotes", sender: self)
    }
    
    //MARK: - TABLE VIEW FUNCTIONS (SIDE BAR MENU)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch menuItems[indexPath.row] {
        case "Log In":
            logIn()
        case "About":
            break
        case "Log Out":
            logOut()
        case "Notes":
            notes()
        case "My Profile":
            myProfile()
        default:
            break
        }
        showAndHideMenu()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toNotes" {
//            if let destination = segue.destination as? NotesViewController {
//                destination.documentId = self.documentId
//                destination.notesDictionary = self.notesDictionary
//            }
//        }
//    }
    
    
    
    
    
    
}

