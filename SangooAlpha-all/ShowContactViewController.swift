//
//  ShowContactViewController.swift
//  SangooAlpha-all
//
//  Created by Florenz Erstling on 25.12.16.
//  Copyright © 2016 Florenz. All rights reserved.
//

import UIKit

class ShowContactViewController: UIViewController {
    
    var contact: UserData?
    @IBOutlet weak var nameTxtLabel: UILabel!
    @IBOutlet weak var phoneTxtLabel: UILabel!
    
    @IBOutlet weak var faceBookTxtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTxtLabel.text = contact?.userName
        phoneTxtLabel.text = contact?.phoneNumber
        faceBookTxtLabel.text = contact?.faceBookUrl

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
