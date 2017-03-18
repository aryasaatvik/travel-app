//
//  Auth.swift
//  travel
//
//  Created by Saatvik Arya on 3/17/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import Firebase

class Auth: UIViewController {
    //MARK: Properties
    @IBOutlet weak var email: TextField!
    @IBOutlet weak var password: TextField!
    @IBOutlet weak var status: UILabel!
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
            self.performSegue(withIdentifier: "toMyTrips", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func logIn(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!)
    }
    @IBAction func signUp(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!)
        
    }
    
    
}

