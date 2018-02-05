//
//  NutTableViewCell.swift
//  itson
//
//  Created by Angel Eduardo Pérez Cruz on 26/09/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class NutTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView?
    
    @IBOutlet weak var userLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Configure Rounded image.
        self.userImage?.layer.borderWidth = 2.0
        self.userImage?.layer.borderColor = UIColor.white.cgColor
        self.userImage?.layer.cornerRadius = (self.userImage?.frame.size.width)!/2
        self.userImage?.layer.masksToBounds = false
        self.userImage?.clipsToBounds = true
    }
    
    func configureRowFor(_ username:String, with imageUrl:String) {
        userLabel?.text = username
        
        print("Username: "+username)
    }

}
