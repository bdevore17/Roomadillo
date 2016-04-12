//
//  MatchTableViewCell.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/5/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var photoView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2
        self.photoView.clipsToBounds = true
        self.photoView.layer.borderColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0).CGColor
        self.photoView.layer.borderWidth = 4.0
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
