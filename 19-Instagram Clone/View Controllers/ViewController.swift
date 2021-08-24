//
//  ViewController.swift
//  19-Instagram Clone
//
//  Created by Selcuk Baki on 23/8/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signupClick(_ sender: Any) {
        
    }
    @IBAction func signinClick(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
        
    }
    
}

