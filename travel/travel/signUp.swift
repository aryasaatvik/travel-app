//
//  signUp.swift
//  travel
//
//  Created by Saatvik Arya on 3/18/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class signUp: UIViewController {
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    var ref: FIRDatabaseReference!
    var handle: FIRAuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = FIRDatabase.database().reference()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: pass.text!)
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: pass.text!)
        self.ref.child("users/\(first.text)/firstName").setValue(first.text)
        self.ref.child("users/\(first.text)/lastName").setValue(last.text)
        self.ref.child("users/\(first.text)/email").setValue(email.text)
        self.performSegue(withIdentifier: "toTripDetails", sender: self)
        print("account created")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
