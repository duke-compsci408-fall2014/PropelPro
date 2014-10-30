//
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 9/29/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class DoctorsVC: UIViewController {
    @IBOutlet weak var doctorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("loaded view");
        // Do any additional setup after loading the view, typically from a nib.
        
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        println("Device ID: \(deviceId)");

        var fetchUrl = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/select.php?attribute=*&patient_id="+deviceId;
        println("fetchUrl: \(fetchUrl)");
        // TODO: make http request
        
    }
}

