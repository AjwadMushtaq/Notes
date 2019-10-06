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
    var notesArray : [Note] = []
    var currentid = String()
    var currentNote = String()
    
    
    
    
    @IBOutlet var notesTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.downloadNotesData()
        
    }
    
    
    
    
    
    
    // MARK: - Action
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    func downloadNotesData() {
        
        
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        self.documentId = []
        self.notesArray = []
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
                print(self.notesArray.count)
                self.notesTv.reloadData()
            }
        }
        
        
    }
    
    
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].note
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.currentid = documentId[indexPath.row]
        self.currentNote = notesArray[indexPath.row].note
        
        print(documentId[indexPath.row])
        print(notesArray[indexPath.row].note)
        self.notesArray.removeAll()
        self.performSegue(withIdentifier: "existingNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       
                
        
       let deleteAction = UIContextualAction(style: .normal, title: "delete") { (action, view, completionHandler) in
        
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        let item = self.documentId[indexPath.row]
        
        Firestore.firestore().collection("notes").document(id).collection("note").document(item).delete()
        
        
        
        
       print("delete")
       completionHandler(true)
        self.downloadNotesData()
       }
       
       return UISwipeActionsConfiguration(actions: [deleteAction])
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ExisitingNoteViewController{
            let vc = segue.destination as! ExisitingNoteViewController
            vc.currentNoteId = self.currentid
            vc.note = self.currentNote
            
        }
        
    }
    
    
    
    
}
