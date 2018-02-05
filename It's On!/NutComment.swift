//
//  NutComment.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation

class NutComment {
    var comment: String
    var date: String
    var nut: String
    
    init(){
        comment = ""
        date = ""
        nut = ""
    }
    
    init(with: String,on: String,by: String){
        comment = with
        date = on
        nut = by
    }
    
    func convertFrom(JSON json: Dictionary<String, Any>){
        nut = json["nut"] as! String
        date = json["date"] as! String
        comment = json["comment"] as! String
    }
}
