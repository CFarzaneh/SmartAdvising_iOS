//
//  SecondViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getFAQS()
    }
    
    @IBOutlet var tableView: UITableView!
    struct FAQ {
        var id = 0
        var question = ""
        var answer = ""
    }
    
    var faqs = [FAQ]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = faqs[indexPath.row].question
        cell.detailTextLabel?.text = faqs[indexPath.row].answer
        return (cell)
    }
    
    
    
    
    func getFAQS() {
        let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/faqs"
        
        let parameters: Parameters = [
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            print(response)
            
            switch response.result {
            case .success(let value):
                let theJSON = JSON(value)
                for item in theJSON["faqs"].arrayValue {
                    var faq = FAQ()
                    faq.id = item["id"].intValue
                    faq.question = item["question"].stringValue
                    faq.answer = item["answer"].stringValue
                    self.faqs.append(faq)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    

}

