//
//  ViewController.swift
//  travel
//
//  Created by Saatvik Arya on 3/17/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func logIn(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            self.status.text = "Logged In"
        }
    }
    @IBAction func signUp(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            self.status.text = "Signed Up"
        }
    }
    
    
}

