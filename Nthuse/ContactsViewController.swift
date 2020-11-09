//
//  ContactsViewController.swift
//  Nthuse
//
//  Created by Muhammad Imran on 20/10/2020.
//

import UIKit
import ContactsUI
import CoreData
class ContactsViewController: UIViewController, CNContactPickerDelegate {
    var array = [ContactsModel]()
    private let contactPicker = CNContactPickerViewController()
    @IBOutlet weak var tableView : UITableView!
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactPicker.delegate = self
//        let obj = ContactsModel(name: "Imran", numner: "03084706656")
//        array.append(obj)
        //save()
        fetchData()
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
        let navigationBar = navigationController?.navigationBar
        navigationBar!.isTranslucent = false
        navigationBar!.barTintColor = #colorLiteral(red: 0.09965629131, green: 0.5471510887, blue: 0.8613092899, alpha: 1)

    }
    
    @IBAction func addContacts(_ sender : UIButton){
        self.present(contactPicker, animated: true, completion: nil)
    }

}
extension ContactsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        
        cell.nameCell.text = array[indexPath.row].name
        cell.numberCell.text = array[indexPath.row].numner
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
         return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            array.remove(at: indexPath.row)
            deleteObject(number: array[indexPath.row].numner)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
}
extension ContactsViewController {
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumberCount = contact.phoneNumbers.count

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue , name: contact.givenName)
         
        }
        else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue , name: contact.givenName)
                    
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in
             
            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func setNumberFromContact(contactNumber: String , name : String) {
        
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
                contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
                contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        contactNumber = contactNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard contactNumber.count >= 14 else {
            dismiss(animated: true) {
            }
            return
        }
       print(String(contactNumber))
        if Search(number: contactNumber) == 0
        {
            save(name: name, number: contactNumber)
        }else{
            print("already")
        }
        //save()

    }
    func Search(number: String) -> Int
    {
        var count: Int = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        let searchString = number
        request.predicate = NSPredicate(format: "number == %@", searchString)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for online in result {
                    _ = (online as AnyObject).value(forKey: "number") as? String
                }
                count = result.count
            }
            else {
                
            }
         
        } catch {
            print(error)
        }
        
        return count
    }

    func save(name : String , number : String) {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext =
        appDelegate.persistentContainer.viewContext
      let entity =
        NSEntityDescription.entity(forEntityName: "Contacts",
                                   in: managedContext)!
      
        let contactsNumber = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        contactsNumber.setValue(name, forKey: "name")
        contactsNumber.setValue(number, forKey: "number")
    
      do {
        try managedContext.save()
    
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    func deleteObject(number: String){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        let searchString = number
        request.predicate = NSPredicate(format: "number == %@", searchString)  // equal
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for object in result {
                    context.delete(object as! NSManagedObject)
                    array.removeAll(where: { $0.numner == number })
                }
                if result.count > 0 {
                    context.delete(result[0] as! NSManagedObject)
                }
                try context.save()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                
            }
            
        } catch {
            print(error)
        }
    }
    
    func fetchData(){
        
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
                array.append(obj)
            }
        } catch {
            
            print("Failed")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        dump(array)
    }
}

struct ContactsModel {
    var name : String!
    var numner : String!
}
