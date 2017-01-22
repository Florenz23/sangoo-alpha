//
//  RegisterPageViewController.swift
//  UserLoginAndRegistration
//
//  Created by Florenz Erstling on 29.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData


class RegisterPageViewController: UIViewController {
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let context = DatabaseController.getContext()

    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        if ((userEmail?.isEmpty)! || userPassword!.isEmpty || (userRepeatPassword?.isEmpty)!) {
            // Display alert message
            
            displayMyAlertMessage(userMessage: "All fields are required")
            
            return
        }
        
        if (userPassword != userRepeatPassword){
            
            displayMyAlertMessage(userMessage: "Passwords do not match")
            
        }
        
        //Send data to server
        
        //let url = "https://sangoo.de/php/userRegister.php?email=\(userEmail)&password=\(userPassword)"
        let path = "https://sangoo.de/php/userRegister.php?userEmail="
        let part1 = "&userPassword="
        let url = path + userEmail! + part1 + userPassword!
        let myUrl = URL(string: url)
        var request = URLRequest(url: myUrl!)
        //request.httpMethod = "POST"
        
        //var postString = "email=\(userEmail)&password=\(userPassword)"
        
        
        //request.httpBody = postString.data(using: .utf8)
        
        //URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    //let currentConditions = parsedData["currently"] as! [String:Any]
                    
                    var resultValue = parseJSON["status"] as? String
                    var userId = parseJSON["lastInsertId"] as? Int
                    print (userId)
                    var isUserRegistered:Bool = false
                    if(resultValue == "Success") {
                        isUserRegistered = true
                        self.deleteAllUserDataLocally()
                        self.saveDataInLocalDb(userId: userId!)
                    }
                    var messageToDisplay: String = parseJSON["message"] as! String!
                    if (!isUserRegistered) {
                        messageToDisplay = parseJSON["message"] as! String!
                    }
                    //let currentTemperatureF = currentConditions["temperature"] as! Double
                    //print(currentTemperatureF)
                    
                    DispatchQueue.main.async(execute: {
                        // display Alert message with confirmation
                        var myAlert = UIAlertController(title:"Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
                        myAlert.addAction(okAction)
                        
                        myAlert.addAction(okAction)
                        
                        self.present(myAlert,animated:true, completion:nil)
                    })
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
        
    }
    
    func saveDataInLocalDb(userId: Int) {
        
        let storeDescription = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        
        
        //toDo email muss zu name geändert werden
        let newContact = UserData(entity: storeDescription!, insertInto: context)
        newContact.name = userEmailTextField.text
        newContact.phone = "testPhone"
        newContact.owner = true
        newContact.userId = Int64(userId)
        
        do {
            try context.save()
            print("saved")
        }
        catch {
            print("nein")
        }
    }
    
    func deleteAllUserDataLocally() {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
           try context.execute(request)
            print("saved")
        }
        catch {
            print("nein")
        }
    }
    
    
    
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated:true, completion:nil)
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
