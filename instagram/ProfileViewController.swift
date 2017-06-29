//
//  ProfileViewController.swift
//  instagram
//
//  Created by Xiu Chen on 6/28/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    
    var postsPFObject: [PFObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchPosts()
        
        
        usernameLabel.text = PFUser.current()?.username
   
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if postsPFObject == nil {
            return 0
        } else {
            return postsPFObject!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = postsPFObject![indexPath.item]
        
        let imageURL = post["media"] as? PFFile
        
  
        
        imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.photoImage.image = UIImage(data:imageData)
        }
        
        return cell
    }
    
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.addDescendingOrder("_created_at")
        query.includeKey("author")
        
        query.findObjectsInBackground { (post: [PFObject]?, error: Error?) in
            self.postsPFObject = post
            self.collectionView.reloadData()
        }
    }

    
    @IBAction func onLogout(_ sender: UIButton) {
        print("hello")
        PFUser.logOutInBackground { (error: Error?) in
        }
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object:nil)
    }

    
    
    /*@IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        print("User logged out successfully")
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object:nil)
    }
*/
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
