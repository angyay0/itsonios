//
//  Fruit.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation
import SwiftyJSON

class Fruit {
    var expired: Bool
    var fruit: Any?
    var reminders = Array<NutDemolition>()
    var hanged = Array<Nut>()
    var comments = Array<NutComment>()
    
    init(){
        expired = false
    }
    
    func convertFrom(JSON json: Dictionary<String, Any>){
        expired = json["expired"] as! Bool
        if !expired {
            fruit = json["fruit"] as? Dictionary<String, Any>
            reminders = obtainReminders(arr: json["reminders"] as! Array<Dictionary<String, Any>>)
            hanged = obtainNuts(arr: json["hanged"] as! Array<Dictionary<String, Any>>)
            comments = obtainComments(arr: json["comments"] as! Array<Dictionary<String,Any>>)
        }else {
            fruit = json["fruit"] as? String
        }
    }
    
    func obtainReminders(arr: Array<Dictionary<String,Any>>) -> [NutDemolition] {
        var reminders: Array<NutDemolition> = []
        for a in arr {
            let nutdm = NutDemolition(set: a["reminder"] as! Int,with: a["status"] as! Int,forId: a["id"] as! Int)
            
            reminders.append(nutdm)
        }
        
        return reminders
    }
    
    func obtainComments(arr: Array<Dictionary<String,Any>>) -> [NutComment] {
        var comments: Array<NutComment> = []
        for a in arr {
            let comment = NutComment(with: a["comment"] as! String, on: a["date"] as! String, by: a["nut"] as! String)
            
            comments.append(comment)
        }
        
        return comments
    }
    
    func obtainNuts(arr: Array<Dictionary<String, Any>>) -> [Nut] {
        var nuts : Array<Nut> = []
        for n in arr {
            let n = Nut(with: n["name"] as! String)
            nuts.append(n)
        }
        
        return nuts
    }
    
}
