//
//  LoginViewController.swift
//  UserLoginAndRegistration
//
//  Created by Florenz Erstling on 29.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!

    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let userEmail = EmailTextField.text
        let userPassword = PasswordTextField.text
        
        let request = setRequestUrl(userEmail: userEmail!, userPassword: userPassword!)
        
        //URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error!)
            } else {
                
                self.getJson(data: data!,userEmail: userEmail!)
                
            }
            
            }.resume()
        
        
    }
    
    func setRequestUrl(userEmail:String, userPassword:String) -> URLRequest {
        
        let path = "https://sangoo.de/php/userLogin.php?email="
        let part1 = "&password="
        let url = path + userEmail + part1 + userPassword
        let myUrl = URL(string: url)
        let request = URLRequest(url: myUrl!)
        return request
        
    }

    
    
    func getJson(data: Data, userEmail: String) {
        do {
            
            let parseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if checkIfPasswordIsCorrect(parseJSON: parseJSON) {
                    self.setLocalCookie()
                    UserDbCommunication().getUserData(userEmail: userEmail)
                OperationQueue.main.addOperation {
                    self.changeToProtectedView()
                }
                
            } else {
                return
            }
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func setLocalCookie() -> Void {
        
        UserDefaults.standard.set(true,forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
    }
    
    func changeToProtectedView() {
        //self.dismiss(animated: true, completion:nil)
        self.performSegue(withIdentifier: "goToSecurePage", sender: self)
        
    }
    
    func checkIfPasswordIsCorrect(parseJSON: [String:Any]) -> Bool {
        
        var passwordCorrect : Bool = false
        //let currentConditions = parsedData["currently"] as! [String:Any]
        
        
        let resultValue = parseJSON["status"] as? String
        
        if(resultValue == "Success") {
            
            passwordCorrect = true
        
        }
        return passwordCorrect
        
    }
    
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
