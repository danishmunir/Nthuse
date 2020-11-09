//
//  ViewController.swift
//  Nthuse
//
//  Created by Muhammad Imran on 20/10/2020.
//

import UIKit
import MessageUI
import CoreData
class ViewController: UIViewController,MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var button: UIButton!
    var numbersArray = [ContactsModel]()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setRounded()
        fetchData()
    }
 
    
    @IBAction func sendMessgae(_ sender : UIButton){
        var phoneNumberString = String()
        if (MFMessageComposeViewController.canSendText())
                {
                    let controller = MFMessageComposeViewController()
            controller.body = UserDefaults.standard.string(forKey: "Message")
                 
            for number in numbersArray{
                phoneNumberString += ",\(number.numner!)"
            }
            
            print(phoneNumberString)// = "123456789,987654321,2233445566"
            var recipientsArray = phoneNumberString.components(separatedBy: ",")
            recipientsArray.remove(at: 0)
            controller.recipients = recipientsArray
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
                }
                else
                {
                    print("Error")
                }
    }

    
    func fetchData(){
        numbersArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let number = data.value(forKey: "number") as! String
                let name = data.value(forKey: "name") as! String
                let obj = ContactsModel(name: name, numner: number)
                numbersArray.append(obj)
            }
        } catch {
            
            print("Failed")
        }
        
        

    }
}

extension UIButton{
    func setRounded() {
        let radius = self.frame.width / 2
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true
        self.clipsToBounds = true
       }
}
