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
    
    
    var createNoteDictionary = [String: Any]() {
              didSet {
                  print("Current data: \(createNoteDictionary)")
              }
          }
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentNoteId)
        print(note)
        
        // Do any additional setup after loading the view.
        textView.text = self.note
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard let id = Auth.auth().currentUser?.uid else {
                          print("you're horrible, sorry")
                          return
                      }
               
        createNoteDictionary.updateValue(Date().description, forKey: "date")
        createNoteDictionary.updateValue(textView.text, forKey: "note")
        Firestore.firestore().collection("notes").document(id).collection("note").document(self.currentNoteId).setData(createNoteDictionary) { (error) in
                          if error != nil {
                              print("Current Note VC -  Error saving curent note data: \(error!.localizedDescription)")
                          } else {
                              print("Current Note VC - All good, saved the current note")
                              self.navigationController?.dismiss(animated: true, completion: nil)
                              self.navigationController?.popViewController(animated: true)
                          }

                      }
        
        print("Existing VC - bacxk buttton pressed")
    }
    

}
