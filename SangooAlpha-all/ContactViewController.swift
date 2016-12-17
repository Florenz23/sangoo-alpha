//
//  ContactViewController.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 17.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mgdContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contacts = [String]()

/*

    var userContacts = [Contact]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func loadListen(){
        let loadRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        userContacts = try! mgdContext.executeFetchRequest(loadRequest) as! [Contact]
    }
     
*/


    override func viewDidLoad() {
        super.viewDidLoad()
        //saveData()
        getData()
        // Register the table view cell class and its reuse id
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let name = result.value(forKey: "name") as? String {
                        contacts.append(name)
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        
        let contact = contacts[indexPath.row]
        cell.textLabel!.text = contact
        
        return cell
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
