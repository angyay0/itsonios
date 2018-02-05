//
//  AppConfigs.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AppConfigs {
    static var EVENT_MODE: Int = 0 //0 = New, 1 = View, 2 = Edit
    
    static let ENVIRONMENT: Int = 0//0 = PROD, 1 = TEST, 2 = DEV
    
    static let MAX_API_TYPES: Int = 6
    
    static var RUNTIME_TOKEN: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2NvbnV0IjoxLCJleHAiOjE0OTM5Mjg2MzB9.v4AoXZ9CitRCFc1MkUEEX6LJlXGZagXZFggCGBVoMN4"
    
    static let RECEIVER_COMMENTS: String = "com.angyay0.itson.comment"
    
    static let GCMMessageID: String = "gcm.message_id"
      
    //Procedimiento para levantar alertas
    static func buildAppDialog(_ viewController : UIViewController,_ message: String) -> Void {
        let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cerrar", style: .destructive))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //Procedimiento para levantar progress dialogs
    static func buildProgressDialog() {
        //TODO
    }
    
}
