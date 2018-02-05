//
//  NutAuth.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation
import SwiftyJSON

class NutAuth {
    var nut: Dictionary<String, String>?
    var pref: Dictionary<String, Bool>?
    var token: String
    
    init(){
        token = ""
    }
    
    init(with token: String){
        self.token = token
    }
    
    func buildFrom(json: JSON) {
        self.token = json["token"].stringValue
        self.nut = json["nut"].dictionaryObject as? Dictionary<String, String>
        self.pref = json["pref"].dictionaryObject as? Dictionary<String, Bool>
    }
}
