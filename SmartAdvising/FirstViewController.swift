//
//  FirstViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController {
    
    let context: NSManagedObjectContext = PersistenceService.context
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    struct Student {
        var id = 0
        var major_id = 0
        var is_undergraduate: Bool?
        var student_id = 0
        var position = 0
    }
    
    var yourArray = [User]()
    var queue = [Student]()

    let service = OutlookService.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
        
    }
    
    func loadQueue() {
        
        let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/queues/"
        let parameters: Parameters = [
            "major_id": yourArray[0].majorId,
            "email":yourArray[0].undergrad,
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                
                print(response)
//                let theJSON = JSON(value)
//                let theArray = theJSON["students"].arrayValue
//
//                if theArray.isEmpty == false {
//                    for item in theJSON["students"].arrayValue {
//                        returnNum = item["id"].intValue
//                    }
//                }
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
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
        else {
            do {
                yourArray = try context.fetch(fetchRequest)
            } catch {
                exit(0)
            }
            loadQueue()

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

