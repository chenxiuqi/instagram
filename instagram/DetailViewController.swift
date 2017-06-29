//
//  DetailViewController.swift
//  instagram
//
//  Created by Xiu Chen on 6/28/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            print(post)
            
            let imageURL = post["media"] as? PFFile
            captionLabel.text = post["caption"] as? String
            let user = post["author"] as? PFUser
            usernameLabel.text = user?.username
            
            if let date = user?.createdAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let dateString = dateFormatter.string(from: date)
                print(dateString) // Prints: Jun 28, 2017, 2:08 PM
                timestampLabel.text = dateString
            }
            
            imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
                self.postedImage.image = UIImage(data:imageData)
                
            }
        }
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
