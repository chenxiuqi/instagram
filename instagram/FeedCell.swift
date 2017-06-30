//
//  FeedCell.swift
//  instagram
//
//  Created by Xiu Chen on 6/28/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UITextView!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var usernameLabel1: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
