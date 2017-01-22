//
//  ConnectViewController.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 25.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ConnectViewController: UIViewController {
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let context = DatabaseController.getContext()

    
    @IBAction func logoutButton(_ sender: Any) {
        print("jojo")
        UserDefaults.standard.set(false, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "loginView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
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
