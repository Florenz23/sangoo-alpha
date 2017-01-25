//
//  LibCoreData.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 24.01.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import Foundation
import CoreData

class LibCoreData {
    
    
    let context = DatabaseController.getContext()

    func saveOwnUserData(userData : [String:Any]) {
        
        let storeDescription = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        
        
        //toDo email muss zu name geändert werden
        let newContact = UserData(entity: storeDescription!, insertInto: context)
        newContact.phoneNumber = userData["phoneNumber"] as! String?
        newContact.lastName = userData["lastName"] as! String?
        newContact.userName = userData["userName"] as! String?
        newContact.userAddress = userData["userAddress"] as! String?
        newContact.userEmail = userData["userEmail"] as! String?
        newContact.firstName = userData["firstName"] as! String?
        newContact.owner = true
        guard let userId = userData["userId"] as! Int? else {
            return
        }
        newContact.userId = Int64(userId)

        do {
            try context.save()
            print("saved")
        }
        catch {
            print("nein")
        }
    }
    
    func deleteAllUserDataLocally() {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            print("saved")
        }
        catch {
            print("nein")
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
