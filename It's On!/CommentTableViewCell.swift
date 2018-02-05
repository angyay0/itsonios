//
//  CommentTableViewCell.swift
//  itson
//
//  Created by Angel Eduardo Pérez Cruz on 26/09/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nutLabel: UILabel?
    
    @IBOutlet weak var commentLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellFor(Nut:String,a Comment:String,on Date: String) {
        nutLabel?.text = Nut
        commentLabel?.text = Comment
        dateLabel?.text = Date
    }

}
