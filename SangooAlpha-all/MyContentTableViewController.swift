//
//  MyContentTableViewController.swift
//  Sangoo-Alpha
//
//  Created by Florenz Erstling on 14.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit

class MyContentTableViewController: UITableViewController {
    var products: [NewUserData]?
    var sendData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let product1 = NewUserData()
        let product2 = NewUserData()
        
        product1.content = "Hans"
        product1.cellImage = "icon-about-phone"
        product1.identifier = "phone"
        
        product2.content = "112"
        product2.cellImage = "icon-about-email"
        product2.identifier = "mail"
        
        
        
        products = [product1,product2]
    }
    // set number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = products {
            return p.count
        }
        return 0
    }
    // content of cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath)
        
        let product = products?[indexPath.row]
        
        if let p = product {
            cell.textLabel?.text = p.content
            if let i = p.cellImage {
                cell.imageView?.image = UIImage(named: i)
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index : Int
        index = indexPath.row
        //sendData.append((products?[index].identifier)!)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.selectionStyle = .none
        let data = products?[index]
        data?.selected = !(data?.selected)!
        if (data?.selected)! {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        var i = 0
        sendData = []
        for data in products! {
            if data.selected! {
                sendData.append((products?[i].identifier)!)
            }
            i += 1
        }
        print(sendData)
        
    }
    
}
