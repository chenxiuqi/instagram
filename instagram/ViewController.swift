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
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchPosts), userInfo: nil, repeats: true)
        
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
        cell.usernameLabel.text = user?.username
        cell.captionLabel.text = caption
        
        imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.postedImage.image = UIImage(data:imageData)
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
    
//    @IBAction func onLogout(_ sender: Any) {
//        print("hello")
//        PFUser.logOutInBackground { (error: Error?) in
//        }
//        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object:nil)
//    }
    

    
    
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


