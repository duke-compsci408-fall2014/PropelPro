
import UIKit

class EditContactController : UIViewController {

    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let patientID = UIDevice.currentDevice().identifierForVendor.UUIDString;
    var name:String!;
    var number:String!;
    var contactID:String!;
    
    var isStepHighLighted:Int!;
    var isBodyMassHighLighted:Int!;
    var isOxySelectHighLighted:Int!;
    var isHRHighLighted:Int!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contactName.text = self.name
        contactNumber.text = self.number
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        // Do the saving
    }
    
    func makeHTTPRequest(urlStringWithParameters : String) {
        let url = NSURL(string: urlStringWithParameters)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("success! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            }
        }
        task.resume()
    }
    
}

