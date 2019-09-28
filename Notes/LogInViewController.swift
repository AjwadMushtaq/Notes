//
//  LogInViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 26/09/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase

enum ActionType {
    case Loaded
    case SignUp
    case EmailLogIn
}


class LogInViewController: UIViewController {

    @IBOutlet var headingDetaiLable: UILabel!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    
    
    var currentAction = ActionType.Loaded {
        
        didSet {
            updateUI()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentAction = .Loaded
        
    }
    
    //MARK: - FUNCTIONS

    
    
    
    
    
    
    
    
    
    func updateUI()  {
         switch currentAction {
               case .Loaded:
                headingDetaiLable.text = "Select"
                emailField.alpha = 0
                passwordField.alpha = 0
                logInButton.alpha = 1
                signUpButton.alpha = 1
                   
               case .SignUp:
                headingDetaiLable.text = "Sign Up"
                emailField.alpha = 1
                passwordField.alpha = 1
                logInButton.alpha = 0
                signUpButton.alpha = 1

               case .EmailLogIn:
            
                headingDetaiLable.text = "Log In"
                emailField.alpha = 1
                passwordField.alpha = 1
                logInButton.alpha = 1
                signUpButton.alpha = 0
                 
                   
               }
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    

}
