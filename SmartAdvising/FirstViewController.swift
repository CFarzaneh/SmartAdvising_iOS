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
import CircleProgressBar

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
    
    @IBOutlet weak var circleBar: CircleProgressBar!
    
    var yourArray = [User]()
    var queue = [Student]()
    
    var queueNumber = 0

    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var addToQueue: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    var timer: Timer!
    let service = OutlookService.shared()
    
    @IBAction func addQueue(_ sender: Any) {
        
        if (addToQueue.titleLabel?.text! != "Remove from Queue") {
            let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/queuers"
            
            let parameters: Parameters = [
                "student_id": yourArray[0].studentId,
                "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
            ]
            
            AF.request(schoolUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {
                response in
                
                switch response.result {
                case .success(let value):
                    let theJSON = JSON(value)
                    let theDictionary = theJSON["queuer"].dictionaryValue
                    
                    print("Successfully added into queue at position", theDictionary["position"]!.intValue)
                    
                    self.queueNumber = theDictionary["id"]!.intValue
                    self.yourArray[0].position = theDictionary["position"]!.int32Value
                    
                    self.loadQueue()
                case .failure(let error):
                    print(error)
                }
            })
        }
        else {
            dequeue(id: queueNumber)
        }
        addToQueue.setTitle("Remove from Queue", for: .normal)
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (userNotLoggedIn != true) {
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
            
            addToQueue.backgroundColor = UIColor(red: 200.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            addToQueue.layer.cornerRadius = 10.0
            
            addToQueue.layer.borderWidth = 2.0
            addToQueue.layer.borderColor = UIColor.clear.cgColor
            
            addToQueue.layer.shadowColor = UIColor(red: 100.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
            addToQueue.layer.shadowOpacity = 1.0
            addToQueue.layer.shadowRadius = 1.0
            addToQueue.layer.shadowOffset = CGSize(width: 0, height: 3)
            addToQueue.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func updateCounting(){
        self.loadQueue()
    }
    
    func dequeue(id: Int) {
        var schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/queuers/"
        schoolUrl += String(id)
        
        let parameters: Parameters = [
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .delete, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(_):
                print("Successfully removed from queue")
                self.queueNumber = 0
                self.addToQueue.setTitle("Add to Queue", for: .normal)
                self.positionLabel.text = ""
                self.yourArray[0].position = 0
                self.loadQueue()
                self.circleBar.setProgress(0.0, animated: true, duration: 1)
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func loadQueue() {
        
        self.queue.removeAll()
        let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/queues"
        let parameters: Parameters = [
            "major_id": yourArray[0].majorId,
            "is_undergrad":yourArray[0].undergrad,
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                let theJSON = JSON(value)
                
                let theArray = theJSON["queue"].arrayValue
                
                print(theArray)

                if theArray.isEmpty == false {
                    for item in theArray {
                        var student = Student()
                        student.id = item["id"].intValue
                        student.major_id = item["major_id"].intValue
                        student.is_undergraduate = item["is_undergraduate"].boolValue
                        student.student_id = item["student_id"].intValue
                        student.position = item["position"].intValue
                        self.queue.append(student)
                        
                        if (student.student_id == self.yourArray[0].studentId) {
                            self.queueNumber = student.id
                            self.addToQueue.setTitle("Remove from Queue", for: .normal)
                            self.positionLabel.text = "You are in position " + String(student.position)
                            
                            let percentage = CGFloat(1.0 - Double(student.position)/Double(self.yourArray[0].position))
                            
                            if ((student.position) == 1) {
                                self.circleBar.setProgress(0.95, animated: true, duration: 1)
                            }
                            else {
                                self.circleBar.setProgress(percentage, animated: true, duration: 1)
                            }
 
                        }
                        
                    }
                    if (self.queue.count == 1) {
                        self.queueLabel.text = "There is " + String(self.queue.count) + " person in the queue"
                    }
                    else {
                        self.queueLabel.text = "There are " + String(self.queue.count) + " people in the queue"
                    }
                }
                else {
                    self.positionLabel.text = ""
                    if (self.yourArray[0].position != 0) {
                        self.circleBar.setProgress(1.0, animated: true, duration: 1)
                        self.positionLabel.text = "It's your turn!"
                        self.yourArray[0].position = 0
                    }
                    self.queue.removeAll()
                    self.addToQueue.setTitle("Add to Queue", for: .normal)
                    self.queueLabel.text = "There is no one in the queue!"
                }
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
            
            print("POSITION",yourArray[0].position)
            
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

