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
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var biographyLabel: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var postsPFObject: [PFObject]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchPosts()
        
        //nameLabel.text = PFUser.current()?
        populateFields()
    }
    
    func populateFields(){
        let user = PFUser.current()!
        nameLabel.text = user["name"] as? String
        usernameLabel.text = PFUser.current()?.username
        biographyLabel.text = user["biography"] as? String
        
        
        let imageURL = user["profile_picture"] as? PFFile
        
        imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            self.profileImage.image = UIImage(data:imageData)
            
            self.profileImage.layer.cornerRadius = (self.profileImage.frame.size.width / 2)
            self.profileImage.layer.masksToBounds = true
    }
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
        PFUser.logOutInBackground { (error: Error?) in
        }
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object:nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionView" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let post = postsPFObject?[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
        }
        else if segue.identifier == "EditProfile" {
            // update later
            
        }
    }
}
