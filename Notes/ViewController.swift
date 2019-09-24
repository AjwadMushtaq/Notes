//
//  ViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 23/09/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var menuTV: UITableView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    
     var menuItems : [String] = ["Log In","About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    //MARK: - TABLE VIEW FUNCTIONS (SIDE BAR MENU)
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return menuItems.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           cell.textLabel?.text = menuItems[indexPath.row]
           return cell
       }
    
   
    
    

}

