//
//  ViewController.swift
//  instagram
//
//  Created by Xiu Chen on 6/26/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var postsPFObject: [PFObject]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        fetchPosts()
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postsPFObject == nil {
            return 0
        } else {
            return postsPFObject!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let post = postsPFObject![indexPath.row]
        
        let imageURL = post["media"] as? PFFile
        let caption = post["caption"] as? String
        let user = post["author"] as? PFUser
        let userProfileImageURL = user?["profile_picture"] as? PFFile
        
        cell.usernameLabel.text = user?.username
        cell.usernameLabel1.text = user?.username
        cell.captionLabel.text = caption
        
        imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.postedImage.image = UIImage(data:imageData) }
        
        if let date = user?.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: date)
            cell.timestampLabel.text = dateString
        }
        
        userProfileImageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.userImage.image = UIImage(data:imageData)
            cell.userImage.layer.cornerRadius = (cell.userImage.frame.size.width / 2)
            cell.userImage.layer.masksToBounds = true
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
            self.tableView.reloadData()
        }
    }
    
    // pull-to-refresh
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        fetchPosts()
        
        // Reload the tableView now that there is new data
        tableView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // passing information through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = postsPFObject?[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = post
        }
        
    }
    
    
}


