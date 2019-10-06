//
//  NotesViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 03/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase
class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var documentId: [String] = []
    var notesDictionary : [Note] = []
   var currentid = String()
   var currentNote = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //downloadData()
        //print(self.documentId.count)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
         print(self.documentId.count)
        //dump(documentId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //dump(documentId)
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
        
        
        Firestore.firestore().collection("notes").document(id).collection("note").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    self.documentId.append(document.documentID)
                
                    print(self.documentId.count)
                }
            }
        }
         dump(documentId)
        
      
        }
        
        
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notesDictionary[indexPath.row].note
        return cell
        
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let destination = self.storyboard?.instantiateViewController(withIdentifier: "existingNote") as! ExisitingNoteViewController
        
        self.currentid = documentId[indexPath.row]
        self.currentNote = notesDictionary[indexPath.row].note
        
        print(documentId[indexPath.row])
        print(notesDictionary[indexPath.row].note)
        self.performSegue(withIdentifier: "existingNote", sender: self)
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.destination is ExisitingNoteViewController{
           let vc = segue.destination as! ExisitingNoteViewController
        vc.currentNoteId = self.currentid
        vc.note = self.currentNote
           
       }
       
   }
    
}
