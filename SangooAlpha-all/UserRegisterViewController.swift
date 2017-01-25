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
    
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated:true, completion:nil)
    }

    func validateRegistrationForm(userEmail:String, userPassword:String, userRepeatPassword:String) -> Bool {
        if ((userEmail.isEmpty) || userPassword.isEmpty || (userRepeatPassword.isEmpty)) {
            // Display alert message
            
            displayMyAlertMessage(userMessage: "All fields are required")
            
            return false
        }
        
        if (userPassword != userRepeatPassword){
            
            displayMyAlertMessage(userMessage: "Passwords do not match")
            
            return false
            
        }
        
        return true
    }
    
    func setRequestUrl(userEmail:String, userPassword:String) -> URLRequest {
        
        let path = "https://sangoo.de/php/userRegister.php?userEmail="
        let part1 = "&userPassword="
        let url = path + userEmail + part1 + userPassword
        let myUrl = URL(string: url)
        let request = URLRequest(url: myUrl!)
        return request
        
    }


    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        if (!validateRegistrationForm(userEmail: userEmail!,userPassword: userPassword!,userRepeatPassword: userRepeatPassword!)){
            return
        }
        
        let request = setRequestUrl(userEmail: userEmail!,userPassword: userPassword!)

        sendDataToServer(request: request)
        
    }
    
    func sendDataToServer(request : URLRequest) -> Void {
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            var messageToDisplay : String

            if error != nil {
                print(error!)
            } else {
                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    if self.checkIfUserSuccessfullyRegistered(parseJSON: parseJSON) {
                        let userId = parseJSON["lastInsertId"] as! Int!
                        self.triggerDbActions(userId: userId!)
                        messageToDisplay = parseJSON["message"] as! String!
                    } else {
                        messageToDisplay = parseJSON["message"] as! String!
                    }
                    DispatchQueue.main.async(execute: {
                        self.setMessageToDisplay(messageToDisplay: messageToDisplay)
                    })
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    func triggerDbActions(userId : Int) {
        
        self.deleteAllUserDataLocally()
        self.saveDataInLocalDb(userId: userId)

    }
    
    func checkIfUserSuccessfullyRegistered(parseJSON : [String:Any]) -> Bool {
        
        let resultValue = parseJSON["status"] as? String
        var isUserRegistered:Bool = false
        if(resultValue == "Success") {
            isUserRegistered = true
        }
        return isUserRegistered
    }
    
    func setMessageToDisplay(messageToDisplay: String) {
        
        let myAlert = UIAlertController(title:"Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
        
    }
    
    
    
    func saveDataInLocalDb(userId: Int) {
        
        let storeDescription = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        
        
        //toDo email muss zu name geändert werden
        let newContact = UserData(entity: storeDescription!, insertInto: context)
        newContact.userName = userEmailTextField.text
        newContact.phoneNumber = "testPhone"
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
    
    
    
        
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
