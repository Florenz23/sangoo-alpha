//
//  LoginViewController.swift
//  UserLoginAndRegistration
//
//  Created by Florenz Erstling on 29.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let userEmail = EmailTextField.text
        let userPassword = PasswordTextField.text
        
        let path = "https://sangoo.de/php/userLogin.php?email="
        let part1 = "&password="
        let url = path + userEmail! + part1 + userPassword!
        let myUrl = URL(string: url)
        var request = URLRequest(url: myUrl!)
        
        //URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    //let currentConditions = parsedData["currently"] as! [String:Any]
                    
                    
                    var resultValue = parseJSON["status"] as? String
                    print(resultValue)
                    
                    if(resultValue == "Success") {
                        // Login Sucessfully
                        UserDefaults.standard.set(true,forKey:"isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.dismiss(animated: true, completion:nil)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
    }
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
