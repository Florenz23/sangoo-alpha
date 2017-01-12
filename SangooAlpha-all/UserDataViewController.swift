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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var users = [UserData]()
    //var user: UserData
    @IBOutlet weak var labelFaceBook: UILabel!


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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        
        
        do
        {
            let results = try context.fetch(request)
            users = results as! [UserData]
            //user = users[0]
            labelUserName.text = users[0].name
            labelUserPhone.text = users[0].phone
            labelFaceBook.text = users[0].facebook
            
        }
        catch {
            print ("error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editUserData" {
            let v = segue.destination as! UserEditDataViewController
            
            v.user = users[0]
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


    

    
}
