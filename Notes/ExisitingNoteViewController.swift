//
//  ExisitingNoteViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 05/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase

class ExisitingNoteViewController: UIViewController {
    
    
    var currentNoteId = String()
    var note = String()
    @IBOutlet var textView: UITextView!
    
    
    var createNoteDictionary = [String: Any]() {
        didSet {
            print("Current data: \(createNoteDictionary)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentNoteId)
        print(note)
        // Do any additional setup after loading the view.
        textView.text = self.note
    }
    
    // MARK: - Action
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        
        guard let note = textView.text else {
                   print("you're horrible, sorry")
                   return
               }
        
        createNoteDictionary.updateValue(Date().description, forKey: "date")
        createNoteDictionary.updateValue(note, forKey: "note")
        createNoteDictionary.updateValue(self.currentNoteId, forKey: "noteId")
        Firestore.firestore().collection("notes").document(id).collection("note").document(self.currentNoteId).setData(createNoteDictionary) { (error) in
            if error != nil {
                print("ExistingNoteVC -  Error saving curent note data: \(error!.localizedDescription)")
            } else {
                print("ExistingNote VC  - All good, Existing Note Updated")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        print("ExistingNote VC - bacx buttton pressed")
    }
    
    
}
