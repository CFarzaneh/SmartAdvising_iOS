//
//  SecondViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    struct FAQ {
        var id = 0
        var question = ""
        var answer = ""
    }
    
    var faqs = [FAQ]()
    var filteredFAQS = [FAQ]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getFAQS()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredFAQS.removeAll(keepingCapacity: false)
        
        var myArray = [String]()
        for i in faqs {
            myArray.append(i.question)
        }
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (myArray as NSArray).filtered(using: searchPredicate) as! [String]
        print(array.count)
        
        if (array.count != 0) {
            for i in 0...array.count-1 {
                for faq in faqs {
                    if (array[i] == faq.question) {
                        filteredFAQS.append(faq)
                    }
                }
            }
        }
    
        self.tableView.reloadData()
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (searchController.isActive) {
            return filteredFAQS.count
        } else {
            return faqs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;

        if (searchController.isActive) {
            cell.textLabel?.text = String(indexPath.row+1) + ". " + filteredFAQS[indexPath.row].question
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = filteredFAQS[indexPath.row].answer
            cell.detailTextLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        }
        else {
            let text = String(indexPath.row+1) + ". " + faqs[indexPath.row].question
            cell.textLabel?.text = text
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = faqs[indexPath.row].answer
            cell.detailTextLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        }
    }
    
    
    
    
    func getFAQS() {
        let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/faqs"
        
        let parameters: Parameters = [
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
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

