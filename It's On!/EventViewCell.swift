//
//  EventViewCell.swift
//  itson
//
//  Created by Eduardo Pérez on 26/06/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var platformLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
