//
//  UserDbCommunication.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 24.01.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import Foundation


class UserDbCommunication {
    
    var receivedData : [String:Any] = [:]
    
    
    func getUserData(userEmail : String) -> [String:String] {
        let request = setRequestUrl(userEmail: userEmail)
        sendDataToServer(request: request)
        return self.receivedData as! [String : String]
    }
    
    func setRequestUrl(userEmail:String) -> URLRequest {
        
        let path = "https://sangoo.de/php/getUserData.php?userEmail="
        let url = path + userEmail
        let myUrl = URL(string: url)
        let request = URLRequest(url: myUrl!)
        return request
        
    }
    
    func sendDataToServer(request : URLRequest) -> Void {
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            if error != nil {
                print(error!)
            } else {
                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                   
                    if self.checkIfDbActionSuccessfullyExecuted(parseJSON: parseJSON) {
                       
                        self.receivedData = self.getDbDataArray(parseJSON: parseJSON)
                    
                    }
                }
                catch let error as NSError {
                   
                    print(error)
               
                }
            }
            }.resume()
        
    }
    
    func checkIfDbActionSuccessfullyExecuted(parseJSON : [String:Any]) -> Bool {
        
        let resultValue = parseJSON["status"] as? String
        let resultError = parseJSON["error"] as? String
        var dbActinSuccess:Bool = false
        if(resultValue == "Success") {
            dbActinSuccess = true
        } else {
            print(resultError!)
        }
        return dbActinSuccess
    }
    
    func getDbDataArray(parseJSON : [String:Any]) -> [String:Any] {
        
        guard let resultValue = parseJSON["data"] as? [String:Any] else {
            return ["nono":"jö"]
        }
        LibCoreData().deleteAllUserDataLocally()
        LibCoreData().saveOwnUserData(userData : resultValue as! [String : Any])
        return resultValue
        
    }

    
}
