//
//  MyContentTableViewController.swift
//  Sangoo-Alpha
//
//  Created by Florenz Erstling on 14.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData

class MyContentTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var contacts = [UserData]()
    var contact: UserData?
    var products = [NewUserData]()
    var sendData : [String] = []
    @IBAction func sendMyData(_ sender: Any) {
        print("moin")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        let product1 = NewUserData()
        let product2 = NewUserData()
        
        product1.content = contact?.name
        product1.cellImage = "icon-about-phone"
        product1.identifier = "phone"
        
        product2.content = contact?.phone
        product2.cellImage = "icon-about-email"
        product2.identifier = "mail"
        
        products = [product1,product2]
    }
    
    func getData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            contacts = results as! [UserData]
            contact = contacts[0]
            //user = users[0]
            
        }
        catch {
            print ("error")
        }
        
    }

    // set number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return products.count
    }
    // content of cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath)
        
        let product = products[indexPath.row]
        
        cell.textLabel?.text = product.content
        cell.imageView?.image = UIImage(named: product.cellImage!)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index : Int
        index = indexPath.row
        //sendData.append((products?[index].identifier)!)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.selectionStyle = .none
        let data = products[index]
        data.selected = !(data.selected)!
        if (data.selected)! {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        var i = 0
        sendData = []
        for data in products {
            if data.selected! {
                sendData.append((products[i].identifier)!)
            }
            i += 1
        }
        print(sendData)
        
    }
    
}
