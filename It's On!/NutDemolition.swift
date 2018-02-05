//
//  NutDemolition.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation

class NutDemolition {
    var id: Int
    var reminder: Int
    var status: Int
    
    init(){
        id = 0
        reminder = 0
        status = 0
    }
    
    init(set: Int,with: Int,forId: Int){
        id = forId
        reminder = set
        status = with
    }
}
