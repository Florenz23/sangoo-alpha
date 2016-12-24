//
//  UserEditDataViewController.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 17.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData

class UserEditDataViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBAction func updateDataButton(_ sender: UIButton) {
        print("moin")
        updateData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let firstName = true
        request.predicate = NSPredicate(format: "owner == %@", firstName as CVarArg)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let list = try context.fetch(request) as? [NSManagedObject]
            if list!.count == 0 // Check notificationId available then not save
            {
                let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: request)
                newManagedObject.setValue("Himmler", forKey: "name")
                newManagedObject.setValue("11", forKey: "phone")
                newManagedObject.setValue(false, forKey: "owner")

            }
            do {
                //try context.save()
                try context.save()
                print("saved")
                getData()
            }
            catch {
                print("nein")
                
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }


    }
    func saveData (){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into:context)
        
        newContact.setValue("Hans", forKey: "name")
        
        do {
            try context.save()
            print("saved")
        }
        catch {
            print("nein")
        }
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
                        textFieldName.text = name
                        print (name)
                    }
                    if let name = result.value(forKey: "phone") as? String {
                        textFieldPhone.text = name
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
