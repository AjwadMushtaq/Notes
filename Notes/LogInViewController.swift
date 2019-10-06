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
    @IBOutlet var goButton: UIButton!
    
   
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
    
    //MARK: - Actions
    
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        currentAction = .SignUp
    }
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        currentAction = .EmailLogIn
    }
    
    

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        
        switch currentAction {
        case .SignUp:
            if let email = emailField.text,  let password = passwordField.text  {
                
                emailSignUp(email: email, password: password)
                //self.performSegue(withIdentifier: "toHome", sender: self)
                self.navigationController?.popViewController(animated: true)
            }
        case .EmailLogIn:
            
            if let email = emailField.text,  let password = passwordField.text  {
                
                emailLogIn(email: email, password: password)
                //self.performSegue(withIdentifier: "toHome", sender: self)
                self.navigationController?.popViewController(animated: true)
            }
            
            
        default:
            break
        }
    }
    
    //MARK: - Functions
    
    func updateUI()  {
         switch currentAction {
         case .Loaded:
             headingDetaiLable.text = "Select"
             emailField.alpha = 0
             passwordField.alpha = 0
             logInButton.alpha = 1
             signUpButton.alpha = 1
             goButton.alpha = 0
         case .SignUp:
             headingDetaiLable.text = "Sign Up"
             emailField.alpha = 1
             passwordField.alpha = 1
             logInButton.alpha = 0
             signUpButton.alpha = 0
             goButton.alpha = 1
         case .EmailLogIn:
             headingDetaiLable.text = "Log In"
             emailField.alpha = 1
             passwordField.alpha = 1
             logInButton.alpha = 0
             signUpButton.alpha = 0
             goButton.alpha = 1
             
             
         }
     }
    
    func emailSignUp(email : String , password : String)  {
        
        let count = email.count
        if email.contains("@") &&  count>6 {
            Auth.auth().createUser(withEmail: email, password: password) { (success, error) in
                if error != nil {
                    print("LoginVc - New User Not Created ")
                } else{
                    print("LoginVC -  New User Created")
                }
            }
        } else{
            let alert = UIAlertController(title: "Alert", message: "Email Syntax Not Correct", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    @IBAction func emailTextFieldDidEndOnExit(_ sender: UITextField) {
    }
    
    @IBAction func passwordTextFieldDidEndOnExit(_ sender: UITextField) {
    }
    
    
    
    
    
    
    func emailLogIn(email : String , password : String)  {
        
        let count = email.count
        if email.contains("@") &&  count>6 {
            
            Auth.auth().signIn(withEmail: email, password: password) { (success, error) in
                if error != nil {
                    print("LoginVc - User Not Logged In")
                }else{
                    print("LoginVC - User Logged In")
                
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Alert", message: "Email Syntax Not Correct", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
 
    
    
}
