//
//  NutMessage.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation
import SwiftyJSON

class NutMessage{
    var message: String
    var code: Int
    var data: JSON
    
    init(){
        message = ""
        code = 0
        data = nil
    }
    
    init(json: Dictionary<String, Any>){
        message = ""
        code = 0
        data = nil
        
        //Inflate Data With JSON
        self.convertFrom(JSON: json)
    }
    
    func convertFrom(JSON json: Dictionary<String, Any>) {
        message = json["message"] as! String
        code = json["code"] as! Int
        
        if ErrorHandler.isParseable(Code: code){
            if ErrorHandler.isDictionaryRoot(Code: code) {
                data = JSON(json["data"] as! Dictionary<String, Any>)
            }else {
                data = JSON(json["data"] as! Array<Any>)
            }
        }
    }
    
    func toString() -> String {
        return "response: "+message+", code: "+String(code)+", data: "+data.debugDescription
    }
}
