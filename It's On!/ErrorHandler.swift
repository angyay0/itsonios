//
//  ErrorHandler.swift
//  itson
//
//  Created by Eduardo Pérez on 28/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler: NSObject {
    
    enum ErrorType : Int {
        
        case
        internalServerError = 0x01,
        internetConnectionError = 0x02,
        badRequestError = 0x03,
        badCredentials = 0x04,
        unknownAPICode = 0x05,
        emailExists = 0x06,
        userExists = 0x07
    }
    
    // Custom errors
    let internetConnectionRequired = -1
    
    fileprivate var currentErrorCode : ErrorType!
    
    func initializeWithErrorType(_ errorType : ErrorType) {
        
        self.currentErrorCode = errorType
    }
    
    func show(_ viewController : UIViewController, completion: ((_ errorType : ErrorType) -> Void)?) {
        
        let alertController = self.alertControllerWithMessage(self.messageForError(self.currentErrorCode)) { () -> Void in
            
            if completion != nil {
                
                completion!(self.currentErrorCode)
            }
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func alertControllerWithMessage(_ message : String, completion: (() -> Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cerrar", style: .destructive, handler: { (alert) -> Void in
            
            if let completion = completion {
                completion()
            }
        }))
        
        return alertController
    }
    
    fileprivate func messageForError(_ errorType : ErrorType) -> String {
        
        switch errorType {
            
        case .internalServerError:
            return "Por favor intenta mas tarde."
            
        case .internetConnectionError:
            return "Se require conexion a internet para continuar."
            
        case .badCredentials:
            return "Sus credenciales son incorrectas"
        
        case .emailExists:
            return "El correo electrónico ya está registrado!"
        
        case .userExists:
            return "El usuario ya está registrado"
            
        default:
            return "Por favor intenta mas tarde."
        }
    }
    
    static func isParseable(Code code: Int) -> Bool {
        let unparseableCodes = [137,109,107]
        
        return !unparseableCodes.contains(code)
    }
    
    static func isDictionaryRoot(Code code: Int) -> Bool {
        let arrayCodes = [111]
        
        return !arrayCodes.contains(code)
    }
}
