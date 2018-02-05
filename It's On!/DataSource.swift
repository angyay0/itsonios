//
//  DataSource.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import Foundation

class DataSource {
    
    
    let user_system = "coconut"
    
    let event_system = "fruit"
    
    let external_system = "external"
    
    func getBaseURL() -> String {
        switch AppConfigs.ENVIRONMENT {
            case 0:
                return PROD_URL;
                break;
            case 1:
                return TEST_URL;
                break;
            default:
                return DEV_URL;
                break;
        }
    }
    
    func authorizationHeader() -> [String: String]? {
        let accessToken = AppConfigs.RUNTIME_TOKEN
        
        if accessToken != "" {
            return ["CoconutKey": accessToken]
        }
        
        return nil
    }
    
    func pathForCoconut(Service: String) -> String {
        return getBaseURL()+user_system+"/"+Service
    }
    
    func pathForFruit(Service: String) -> String {
        return getBaseURL()+event_system+"/"+Service
    }
    
    func pathForExternal(Service: String) -> String {
        return getBaseURL()+external_system+"/"+Service
    }
    
    func responseWithError(_ errorType : ErrorHandler.ErrorType) -> ErrorHandler {
        
        let errorHandler = ErrorHandler()
        errorHandler.initializeWithErrorType(errorType)
        
        return errorHandler
    }
    
    func isReachable() -> Bool {/*
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) */
        return true
    }
    
    func isConnectedToNetwork() -> Bool {
        if isReachable() {
            return true
        }else{
            //Show Dialog
            //TODO
        }
        
        return false
    }
    
}
