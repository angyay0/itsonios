//
//  DataProvider.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import Firebase

class DataProvider: DataSource {
    
    static let sharedInstance = DataProvider()
    
    static func getInstance() -> DataProvider {
        return sharedInstance
    }
    
    // MARK: User Methods
    func authenticate(user: String, password: String, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void) {
        
        let token = Messaging.messaging().fcmToken
        let device = UIDevice.current.model + " " + UIDevice.current.systemName
        
        if isConnectedToNetwork() {
            let path = self.pathForCoconut(Service: "authenticate/")
            
            let body = [
                "nut": user,
                "password": password,
                "device_id": device,
                "fcm_token": token
            ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default)
                .responseJSON(completionHandler: {(response)-> Void in
                
                    switch response.result {
                        case .success:
                            let statusCode = response.response!.statusCode
                            
                            switch statusCode {
                                case 200: //Exito
                                    let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                                
                                    completion(nut,nil)
                                    break;
                                
                                default:
                                    completion(nil,self.responseWithError(.unknownAPICode))
                                    break
                            }
                            
                            break;
                        
                        case .failure:
                            completion(nil,self.responseWithError(.internalServerError))
                            break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func signupFor(Request json: Dictionary<String, String>, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void) {
        
        if isConnectedToNetwork() {
            let path = self.pathForCoconut(Service: "signup/")
            
            var body = [
                "device_id": "iPhone Debug",
                "fcm_token": "asdhgashdaidahi"
            ]
            
            for(k,v) in json {
                body.updateValue(v, forKey: k)
            }
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default)
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            switch(nut.code){
                                case 111:
                                    completion(nil, self.responseWithError(.emailExists))
                                    break
                                
                                default:
                                    completion(nut, nil)
                                break
                            }
                            
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func update(Preferences json: Dictionary<String, Bool>, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ) {
        
        if isConnectedToNetwork() {
            let path = self.pathForCoconut(Service: "preferences/")
            
            Alamofire.request(path, method: .post, parameters: json, encoding: JSONEncoding.default, headers:  self.authorizationHeader())
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func update(Message json: Dictionary<String, String>, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ) {
        
        if isConnectedToNetwork() {
            let path = self.pathForCoconut(Service: "message/")
            
            Alamofire.request(path, method: .post, parameters: json, encoding: JSONEncoding.default, headers:  self.authorizationHeader())
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func hangCoconutTo(Fruit fruit: String,WithAnswer ans: Int, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ) {
        
        if isConnectedToNetwork() {
            let path = self.pathForCoconut(Service: "hang/")
            
            let body = [
                "fruit": fruit,
                "accept": ans
            ] as [String : Any]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers:  self.authorizationHeader())
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func coconutHang(ToFruit fruit: String,AComment comment: String, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ) {
        
        if isConnectedToNetwork() {
            let path = self.pathForFruit(Service: "comment/")
            
            let body = [
                "fruit": fruit,
                "comment": comment
            ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers:  self.authorizationHeader())
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    // MARK: Event Methods
    func fetchFruits(completion: @escaping (_ :NutMessage?, _ :ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "fruit/")
            
            Alamofire.request(path, method: .get, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    print(response)
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
            
        }else{
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func createNew(Fruit tree: Dictionary<String, Any>, completion: @escaping (_ : NutMessage?, _ :ErrorHandler?) -> Void){
        
        if isConnectedToNetwork() {
            let path = self.pathForFruit(Service: "fruit/")
            
            Alamofire.request(path, method: .post, parameters: tree, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func fetchFruit(Tree fruit: String,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "tree/")
            
            let body = [ "fruit": fruit ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    //TODO: UpdateFruitTree & UpdateDynamic
    
    func fetchDemolitions(For fruit: String,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "fdems/")
            
            let body = [ "fruit": fruit ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func fetchComments(For fruit: String,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "fcoms/")
            
            let body = [ "fruit": fruit ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func fetchHangedCoconuts(For fruit: String,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "fhangs/")
            
            let body = [ "fruit": fruit ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func hangTo(Fruit fruit: String,A coconut: String,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "invite/")
            
            let body = [ "fruit": fruit, "hangings": [coconut] ] as [String : Any]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func update(Fruit tree: Dictionary<String,Any>,completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ){
        if isConnectedToNetwork(){
            let path = self.pathForFruit(Service: "cut/")
            
            let body = [ "action": 0, "params": tree ] as [String : Any]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.authorizationHeader())
                .responseJSON(completionHandler: { (response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        } else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    // MARK: External Methods
    func updateToken(ForUser user: String, completion: @escaping (_ : NutMessage?, _ : ErrorHandler?) -> Void ) {
        
        if isConnectedToNetwork() {
            let path = self.pathForFruit(Service: "session/")
            
            let body = [
                "gamertag": user
            ]
            
            Alamofire.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers:  self.authorizationHeader())
                .responseJSON(completionHandler: {(response) -> Void in
                    
                    switch response.result {
                    case .success:
                        let statusCode = response.response!.statusCode
                        
                        switch statusCode {
                        case 200: //Exito
                            
                            print(response.value.debugDescription)
                            
                            let nut = NutMessage(json: response.value as! Dictionary<String, Any>)
                            
                            completion(nut, nil)
                            break;
                            
                        default:
                            completion(nil,self.responseWithError(.unknownAPICode))
                            break
                        }
                        
                        break;
                        
                    case .failure:
                        completion(nil,self.responseWithError(.internalServerError))
                        break;
                    }
                    
                })
        }else {
            completion(nil, self.responseWithError(.internetConnectionError))
        }
    }
    
    func triggerCommentAutoRefresh() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: AppConfigs.RECEIVER_COMMENTS), object: nil,
                userInfo: ["message":"update"])
    }
    

}
