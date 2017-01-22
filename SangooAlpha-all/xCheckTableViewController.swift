//
//  StoreListTVCTableViewController.swift
//  CoreDataExample
//
//  Created by Norbert Erstling on 23.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData


class xCheckTableViewController: UITableViewController {
    
    //let context = DatabaseController()
    let moContext = DatabaseController.getContext()
    //let moContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var stores = [UserData]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //saveData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //deleteAllUserDataLocally()
        saveData()
        getData()
        
    }
    
    func getData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        
        
        do
        {
            let results = try moContext.fetch(request)
            stores = results as! [UserData]
            self.tableView.reloadData()
        }
        catch {
            print ("error")
        }
        
    }
    func saveData(){
        
        var store: UserData?
        
        // Get Description
        let storeDescription = NSEntityDescription.entity(forEntityName: "UserData", in: moContext)
        
        //let store = Store(entity: storeDescription!, insertIntoManagedObjectContext: moContext)
        //let newContact = NSEntityDescription.insertNewObject(forEntityName: "Store", into: moContext)
        
        store = UserData(entity: storeDescription!, insertInto: moContext)
        
        
        store?.name = "jo"
        store?.facebook = "jo"
               
        do {
            try moContext.save()
            print("saved")
        }
        catch {
            print("nein")
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        let store = stores[indexPath.row]
        cell.textLabel?.text = store.name
        cell.detailTextLabel?.text = store.facebook
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    
    
}
