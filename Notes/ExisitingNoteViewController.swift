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

     
    var id = String()
    var note = String()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(id)
        print(note)
        
        // Do any additional setup after loading the view.
        textView.text = self.note
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        print("Existing VC - bacxk buttton pressed")
    }
    

}
