
import UIKit

class EditContactController : UIViewController {

    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let patientID = UIDevice.currentDevice().identifierForVendor.UUIDString;
    var name:String!;
    var number:String!;
    var contactID:String!;
    
    //tuple - (text, call)
    var stepHighLightTuple = (text:-1,call:-1)
    var bodyMassHighLightTuple = (text:-1,call:-1)
    var oxyHighLightTuple = (text:-1,call:-1)
    var hRHighLightTuple = (text:-1,call:-1)
    
    //tuple - (stat_id, text_on, call_on)
    var stepsNotificationTuple = (statId:7, isText: false, isCall: false)
    var bodyMassNotificationTuple = (statId: 1,isText: false, isCall: false)
    var oxyNotificaitonTuple = (statId: 6, isText: false,isCall: false)
    var hrNotificaitionTuple = (statId: 9,isText: false,isCall: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        contactName.text = self.name
//        contactNumber.text = self.number
    }


    @IBAction func oxyTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.oxyHighLightTuple.text == -1){
                sender.highlighted = true;
                self.oxyNotificaitonTuple.isText = true;
                self.oxyHighLightTuple.text = 2;
            }else{
                sender.highlighted = false;
                self.oxyNotificaitonTuple.isText = false;
                self.oxyHighLightTuple.text = -1;
            }
        });
    }
    
    @IBAction func stepsTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.stepHighLightTuple.text == -1) {
                sender.highlighted = true;
                self.stepsNotificationTuple.isText = true;
                self.stepHighLightTuple.text = 0;
            }else{
                sender.highlighted = false;
                self.stepHighLightTuple.text = -1;
                self.stepsNotificationTuple.isText = false;
            }
        });
    }
    
    @IBAction func hrTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.hRHighLightTuple.text == -1){
                sender.highlighted = true;
                self.hrNotificaitionTuple.isText = true;
                self.hRHighLightTuple.text = 3;
            }else{
                sender.highlighted = false;
                self.hrNotificaitionTuple.isText = false
                self.hRHighLightTuple.text = -1;
            }
        });
    }
    
    @IBAction func bmTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.bodyMassHighLightTuple.text == -1){
                sender.highlighted = true;
                self.bodyMassNotificationTuple.isText = true;
                self.bodyMassHighLightTuple.text = 1;
            }else{
                sender.highlighted = false;
                self.bodyMassNotificationTuple.isText = false;
                self.bodyMassHighLightTuple.text = -1;
            }
        });
    }
    
    @IBAction func oxyCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.oxyHighLightTuple.call == -1){
                sender.highlighted = true;
                self.oxyNotificaitonTuple.isCall = true;
                self.oxyHighLightTuple.call = 2;
            }else{
                sender.highlighted = false;
                self.oxyNotificaitonTuple.isCall = false;
                self.oxyHighLightTuple.call = -1;
            }
        });
    }
    
    @IBAction func stepsCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.stepHighLightTuple.call == -1) {
                sender.highlighted = true;
                self.stepsNotificationTuple.isCall = true;
                self.stepHighLightTuple.call = 0;
            }else{
                sender.highlighted = false;
                self.stepsNotificationTuple.isCall = false;
                self.stepHighLightTuple.call = -1;
            }
        });
    }
    
    @IBAction func hrCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.hRHighLightTuple.call == -1){
                sender.highlighted = true;
                self.hrNotificaitionTuple.isCall = true;
                self.hRHighLightTuple.call = 3;
            }else{
                sender.highlighted = false;
                self.hrNotificaitionTuple.isCall = false
                self.hRHighLightTuple.call = -1;
            }
        });
    }
    
    @IBAction func bmCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.bodyMassHighLightTuple.call == -1){
                sender.highlighted = true;
                self.bodyMassNotificationTuple.isCall = true;
                self.bodyMassHighLightTuple.call = 1;
            }else{
                sender.highlighted = false;
                self.bodyMassNotificationTuple.isCall = false;
                self.bodyMassHighLightTuple.call = -1;
            }
        });
    }
    
    
    
    @IBAction func saveAction(sender: UIButton) {
        // Do the saving - make request to db with all the info
        
        
    }
    
    func checkSelected(tuple : (text:Int,call:Int)) -> Bool{
        if(tuple.text != -1 || tuple.call != -1){
            return true;
        }
        return false;
    }

    //for dismissing keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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

