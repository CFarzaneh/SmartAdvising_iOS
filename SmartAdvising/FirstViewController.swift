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

    let service = OutlookService.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        service.logout()
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save() // <- remember to put this :)
            } catch {
                print("Could not save context")
            }
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
        self.present(controller, animated: true, completion: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if (userNotLoggedIn == true) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
            self.present(controller, animated: true, completion: nil)
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

