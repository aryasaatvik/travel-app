//
//  myTrips.swift
//  travel
//
//  Created by Saatvik Arya on 3/18/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class myTrips: UIViewController {
    //MARK: Properties
    @IBOutlet weak var status: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        status.text = "Welcome" + 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
