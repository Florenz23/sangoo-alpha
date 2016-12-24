//
//  UserDataViewController.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 17.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData


class UserDataViewController: UIViewController {

    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var labelUserPhone: UILabel!
    
    var contacts = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //saveData()
        getData()

        // Do any additional setup after loading the view.
    }
    

    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let firstName = true
        request.predicate = NSPredicate(format: "owner == %@", firstName as CVarArg)
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let name = result.value(forKey: "name") as? String {
                        labelUserName.text = name
                        print (name)
                    }
                    if let name = result.value(forKey: "phone") as? String {
                        labelUserPhone.text = name
                        print (name)
                    }
                    if let name = result.value(forKey: "owner") as? Bool {
                        print (name)
                    }
                }
            }
        }
        catch {
            print ("error")
        }
        
    }
    
    func saveData (){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newContact = NSEntityDescription.insertNewObject(forEntityName: "UserData", into:context)
        
        newContact.setValue("Adolfo", forKey: "name")
        newContact.setValue("11288", forKey: "phone")
        newContact.setValue(true, forKey: "owner")

        do {
            try context.save()
            print("saved")
        }
        catch {
            print("nein")
        }
    }

}
