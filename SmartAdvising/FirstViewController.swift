//
//  FirstViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    let context: NSManagedObjectContext = PersistenceService.context
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    var yourArray = [User]()

    let service = OutlookService.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        do {
            yourArray = try context.fetch(fetchRequest)
            
        } catch {
            
        }
        
        print(yourArray[0].email!)
        
        
        var undergrad = ""
        if yourArray[0].undergrad == true {
            undergrad = "Undergraduate"
        }
        else {
            undergrad = "Graduate"
        }
        
        let message = "Email: " + yourArray[0].email! + "\nMajor: "
            + yourArray[0].major! + "\nYear: " + undergrad + "\nSchool: " + yourArray[0].school!
        
        
        
        let alert = UIAlertController(title: "Profile", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { action in
            self.service.logout()
            if let result = try? self.context.fetch(self.fetchRequest) {
                for object in result {
                    self.context.delete(object)
                }
                do {
                    try self.context.save() // <- remember to put this :)
                } catch {
                    print("Could not save context")
                }
            }
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
            self.present(controller, animated: true, completion: nil)

        }))
        
        
        self.present(alert, animated: true)
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if (userNotLoggedIn == true) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
            self.present(controller, animated: false, completion: nil)
        }
    
    }
    
    var userNotLoggedIn: Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let count = try PersistenceService.context.count(for: fetchRequest)
            return count == 0 ? true : false
        } catch {
            return true
        }
    }


}

