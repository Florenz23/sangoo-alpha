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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var user:UserData?

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBAction func updateDataButton(_ sender: UIButton) {
        print("moin")
        user?.name = textFieldName.text
        user?.phone = textFieldPhone.text
        
        do {
            try context.save()
            print("saved")
        }
        catch {
            print("nein")
        }
    }
    
    //var users = [UserData]()
    //var user: UserData
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        textFieldName.text = user?.name
        textFieldPhone.text = user?.phone
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
