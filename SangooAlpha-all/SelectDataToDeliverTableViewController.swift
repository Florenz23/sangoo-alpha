//
//  MyContentTableViewController.swift
//  Sangoo-Alpha
//
//  Created by Florenz Erstling on 14.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class SelectDataToDeliverTableViewController: UITableViewController,CLLocationManagerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var newContactTextField: UILabel!
    var contacts = [UserData]()
    var contact: UserData?
    var products = [NewUserData]()
    var sendData : [String] = []
    @IBAction func sendMyData(_ sender: Any) {
        
        //create new object to save the data
        let storeDescription = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        
        let newContact = UserData(entity: storeDescription!, insertInto: context)
        
        // save only what is selected
        for data in sendData {
            
            if data == "phone" {
                newContact.phone = contact?.phone
            }
            if data == "facebook" {
                newContact.facebook = contact?.facebook
            }
        }
        
        // send Data to server
        getLocationData()
        
        // Teil, nachdem der richtige Kontakt rausgesucht wurde
        saveNewUserData()
    }
    
    func saveNewUserData() {
        // name is always needed
        //        newContact.name = contact?.name
        //
        //        do {
        //            try context.save()
        //            print("saved")
        //        }
        //        catch {
        //            print("nein")
        //        }
    }
    
    func sendGeoDataToServer(geoData: CLLocationCoordinate2D) {
        let id = getUserId()
        print(id)
        let long = geoData.longitude
        let lat = geoData.latitude
        let longString:String = String(format:"%f", long)
        let latString:String = String(format:"%f", lat)

        print(long)
        print(lat)
        print("Data delivered to server")
        let path = "https://sangoo.de/php/userConnect.php?userId="
        let part1 = "&long="
        let part2 = "&lat="
        let url1 = path + String(id) + part1
        let url2 = longString + part2 + latString
        let url = url1 + url2
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
                    var resultMessage = parseJSON["message"] as? String
                    var contactName = parseJSON["name"] as? String
                    print(contactName)
                    
                    if(resultValue == "Success") {
                        // Data saved successfully
                        print("GeoData are Saved in Server")
                        self.displayMyAlertMessage(userMessage: contactName!)
                    } else {
                        print(resultMessage)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getUserId() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let identifier = true
        fetchRequest.predicate = NSPredicate(format: "owner == %@", identifier as CVarArg)
        do
        {
            let results = try context.fetch(fetchRequest)
            let result = results[0] as! UserData
            let id = result.userId
            return Int(id)
        }
        catch {
            print ("error")
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        let product1 = NewUserData()
        let product2 = NewUserData()
        
        product1.content = contact?.phone
        product1.cellImage = "icon-about-phone"
        product1.identifier = "phone"
        
        product2.content = contact?.facebook
        product2.cellImage = "icon-about-email"
        product2.identifier = "facebook"
        
        products = [product1,product2]
    }
    
    func getData() {
        
        
        // hier werden die Daten vom Server geholt
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
    
    // get the Location
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            
            //let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
            //let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            //let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            //map.setRegion(region, animated:true)
            // Do any additional setup after loading the view, typically from a nib.
            
            
            // show dot
            let coords = location.coordinate
            print(location)
            let xValue = coords.latitude
            let yValue = coords.longitude
            sendGeoDataToServer(geoData: coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func getLocationData() {
        print("Wait for Location")
                manager.requestLocation()
    }
    
    func setGeoSettings() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGeoSettings()
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
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated:true, completion:nil)
    }
    
}
