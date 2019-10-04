//
//  CurrentNoteViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 03/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase

class CurrentNoteViewController: UIViewController {

    @IBOutlet var topLable: UILabel!
    @IBOutlet var dateLable: UILabel!
    @IBOutlet var noteTextView: UITextView!
    
    
    
    
    var createNoteDictionary = [String: Any]() {
           didSet {
               print("Current data: \(createNoteDictionary)")
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateLable.text = Date().description
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard let id = Auth.auth().currentUser?.uid else {
                   print("you're horrible, sorry")
                   return
               }
        
        createNoteDictionary.updateValue(dateLable.text, forKey: "date")
       createNoteDictionary.updateValue(noteTextView.text, forKey: "notes")
        Firestore.firestore().collection("notes").document(id).collection("note").document().setData(createNoteDictionary) { (error) in
                   if error != nil {
                       print("Current Note VC -  Error saving curent note data: \(error!.localizedDescription)")
                   } else {
                       print("Current Note VC - All good, saved the current note")
                       self.navigationController?.dismiss(animated: true, completion: nil)
                       self.navigationController?.popViewController(animated: true)
                   }

               }
 
    }
    
    

}
