//
//  FieldsValidator.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation

class FieldsValidator {
    static let sharedInstance = FieldsValidator()
    
    /** REGEX VAlidations **/
    let EMAIL_REGEX: String = "^[a-zA-Z0-9#_~!$&'()*+,;=:.\"(),:;<>@\\[\\]\\\\]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*$"
    //let PASSWORD_PATTERN: String = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,12}$"
    let PASSWORD_PATTERN: String = "^.{6,12}$"
    let NAME_PATTERN: String = "^[A-Za-z\\s]+$"
    let USERNAME_PATTERN: String = "^[a-zA-Z0-9.@!?#$_-]+$"
    let STATUS_PATTERN: String = "^[a-zA-Z0-9.'@!?#$/_\\s]+$"
    let COMMENT_PATTERN: String = "^[a-zA-Z0-9.'@!?#$/_:,\\-\\s]+$"
    /** **/
    
    static func getInstance() -> FieldsValidator {
        return sharedInstance
    }
    
    func isValidComment(comment: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", COMMENT_PATTERN).evaluate(with: comment)
    }
    
    func isValidStatus(status: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", STATUS_PATTERN).evaluate(with: status)
    }
    
    func isValidUsername(username: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", USERNAME_PATTERN).evaluate(with: username)
    }
    
    func isValidName(name: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", STATUS_PATTERN).evaluate(with: name)
    }
    
    func isValidPassword(password: String) -> Bool {
            return NSPredicate(format: "SELF MATCHES %@", PASSWORD_PATTERN).evaluate(with: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX).evaluate(with: email)
    }
    
    func isValidSignupForm(name: String,last: String,email: String,user: String,pwd: String) -> Int {
        var field = 0
        
        if(isValidName(name: name)){
            if(isValidName(name: last)){
                if(isValidEmail(email: email)){
                    if(isValidUsername(username: user)){
                        if(isValidPassword(password: pwd)){
                            field = 0
                        }else{
                            field = 7
                        }
                    }else{
                        field = 11
                    }
                }else{
                    field = 13
                }
            }else{
                field = 17
            }
        }else{
            field = 19
        }
        
        return field
    }
    
    func isValidFruitForm(title: String,game: String,platform: String,promise: String) -> Int {
        var field = 0
        
        if(isValidStatus(status: title)){
            if(isValidStatus(status: game)){
                if(isValidStatus(status: platform)){
                    if(isValidComment(comment: promise)){
                        field = 0
                    }else{
                        field = 23
                    }
                }else{
                    field = 29
                }
            }else{
                field = 31
            }
        }else{
            field = 37
        }
        
        return field
    }
}
