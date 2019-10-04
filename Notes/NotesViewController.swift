//
//  NotesViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 03/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase
class NotesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        downloadData()
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Action
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    func downloadData() {
        
        guard let id = Auth.auth().currentUser?.uid else {
                          print("you're horrible, sorry")
                          return
                      }
        print("download data triggered")
        
        Firestore.firestore().collection("notes").document(id).collection("note").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(querySnapshot?.count)
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
            
            
        }

    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
