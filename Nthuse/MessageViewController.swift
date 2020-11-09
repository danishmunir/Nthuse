//
//  MessageViewController.swift
//  Nthuse
//
//  Created by Muhammad Imran on 20/10/2020.
//

import UIKit
import ContactsUI

class MessageViewController: UIViewController {
    @IBOutlet weak var textView : UITextView!
    @IBOutlet weak var messageView : UIView!
    let contactpicker = CNContactPickerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactpicker.delegate = self
        self.present(contactpicker, animated: true, completion: nil)
        
        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = #colorLiteral(red: 0.09965629131, green: 0.5471510887, blue: 0.8613092899, alpha: 1)
        messageView.layer.shadowColor  = UIColor(ciColor: .gray).cgColor
        messageView.layer.shadowRadius = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissimsKeyboard))
        self.view.addGestureRecognizer(tap)
       let mesgae =  UserDefaults.standard.string(forKey: "Message")
    
        textView.text = mesgae

    }
    
    
    @objc func dissimsKeyboard(){
        self.view.endEditing(true)
    }
    @IBAction func saveAction(_ sender : UIButton){
        if textView.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please Set a Message", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
        else{
        UserDefaults.standard.set(textView.text, forKey: "Message")

            let alert = UIAlertController(title: "Success", message: "Message Save Succsessfuly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default) { (UIAlertAction) in
                let mesgae =  UserDefaults.standard.string(forKey: "Message")
                self.textView.text = mesgae
            })
           
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}
extension MessageViewController : CNContactPickerDelegate ,UIImagePickerControllerDelegate{
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let cn = contact.phoneNumbers
        print(cn)
    }

}
