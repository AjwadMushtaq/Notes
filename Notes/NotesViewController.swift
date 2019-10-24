//
//  NotesViewController.swift
//  Notes
//
//  Created by Ajwad Mushtaq on 03/10/2019.
//  Copyright © 2019 Techinsfoish. All rights reserved.
//

import UIKit
import Firebase
class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
   
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var documentId: [String] = []
    var notesArray : [Note] = []
    var filterredNotesArray : [Note] = []
    var currentid = String()
    var currentNote = String()
    

    @IBOutlet var notesTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        notesTv.tableHeaderView = searchController.searchBar
        
        
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
                    
                    let newNote = Note(date: document["date"] as! String, note: document["note"] as!String, id: document["noteId"] as! String)
                    
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
        
        if isFiltering(){
            return filterredNotesArray.count
        }
        
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let  notes :  [Note]

        if isFiltering(){
            notes = filterredNotesArray
            
        }
        else{
            notes = notesArray
        }
        cell.textLabel?.text = notes[indexPath.row].note
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if isFiltering(){
            self.currentid = filterredNotesArray[indexPath.row].id
            self.currentNote = filterredNotesArray[indexPath.row].note
            self.filterredNotesArray.removeAll()
            
        } else {
            self.currentid = notesArray[indexPath.row].id
            self.currentNote = notesArray[indexPath.row].note
            self.notesArray.removeAll()
            
        }
        
//        print(documentId[indexPath.row])
//        print(notesArray[indexPath.row].note)
        
        self.performSegue(withIdentifier: "existingNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       let deleteAction = UIContextualAction(style: .normal, title: "delete") { (action, view, completionHandler) in
        
        guard let id = Auth.auth().currentUser?.uid else {
            print("you're horrible, sorry")
            return
        }
        
       
        var item = self.notesArray[indexPath.row].id
        
        if self.isFiltering(){
            item = self.filterredNotesArray[indexPath.row].id
            
        }
        
        
      
        
        Firestore.firestore().collection("notes").document(id).collection("note").document(item).delete()
        
       print("delete")
       completionHandler(true)
        self.downloadNotesData()
       }
       
       return UISwipeActionsConfiguration(actions: [deleteAction])
       }
    
    
    
    
    
    // Function to specify what to filter data by
    // scope set to all checks if there is any string in the search bar
    // --------------------------------------------------------------------------
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        
        filterredNotesArray = notesArray.filter({ (Note) -> Bool in
            return Note.note.lowercased().lowercased().contains(searchText.lowercased())
        })
   
            
           
       
        
        notesTv.reloadData()
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Function used to detremine which array to dislay filetred array or normal array
    // ------------------------------------------------------------------
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ExisitingNoteViewController{
            let vc = segue.destination as! ExisitingNoteViewController
            vc.currentNoteId = self.currentid
            vc.note = self.currentNote
            
        }
        
    }
    
    
    
    
}
