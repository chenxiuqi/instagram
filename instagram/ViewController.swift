//
//  ViewController.swift
//  instagram
//
//  Created by Xiu Chen on 6/26/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


