//
//  ViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 23/09/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var menuTV: UITableView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    
    
    var currentUser : User?
    var authListener : AuthStateDidChangeListenerHandle?
       
    
    
    var menuItems : [String] = ["Log In","About" , "Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if authListener == nil {
            authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
                self.currentUser = user
                if let user = user {
                    print("HomeVC - user signed in: \(user.uid)")
                    
                    
                    self.menuItems = ["About" ,"Notes" ,"Log Out"]
                    //self.menuItems = ["Log out" , "About" , "My profile" , "Post box","Support"]
                   
                } else {
                    print("HomeVC - no user!")
                    self.menuItems = ["Log In", "About"]
                }
                self.menuTV.reloadData()
            }
        }
        
        
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
    
    func about()  {
        performSegue(withIdentifier: "createProfile", sender: self)
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
            about()
        case "Log Out":
            logOut()
        default:
            break
        }
        showAndHideMenu()
    }
    
    
    
    
    
}

