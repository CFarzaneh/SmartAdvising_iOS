//
//  LoginViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var schoolField: CustomUITextField!
    @IBOutlet weak var majorField: CustomUITextField!
    @IBOutlet weak var yearField: CustomUITextField!
    
    struct University {
        // structure definition goes here
        var id = 0
        var name: String?
        var email_tld: String?
        
    }
    
   
    @IBOutlet weak var login: UIButton!
    var schoolOption = [University]()
    var majorsOption = [String]()
    let yearOption = ["Undergraduate", "Graduate"]
    
    let schoolPickerView = UIPickerView()
    let majorPickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    
    let service = OutlookService.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        login.backgroundColor = UIColor(red: 200.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        login.layer.cornerRadius = 10.0
        
        login.layer.borderWidth = 2.0
        login.layer.borderColor = UIColor.clear.cgColor
        
        login.layer.shadowColor = UIColor(red: 100.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        login.layer.shadowOpacity = 1.0
        login.layer.shadowRadius = 1.0
        login.layer.shadowOffset = CGSize(width: 0, height: 3)
        login.setTitleColor(.white, for: .normal)
        
        login.isUserInteractionEnabled = false
        login.alpha = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        loginFieldsView.layer.cornerRadius = 10
        
        setLogInState(loggedIn: service.isLoggedIn)
        
        let schoolToolBar = UIToolbar()
        schoolToolBar.barStyle = UIBarStyle.default
        schoolToolBar.isTranslucent = true
        schoolToolBar.sizeToFit()
        
        let majorsToolBar = UIToolbar()
        majorsToolBar.barStyle = UIBarStyle.default
        majorsToolBar.isTranslucent = true
        majorsToolBar.sizeToFit()
        
        let gradeToolBar = UIToolbar()
        gradeToolBar.barStyle = UIBarStyle.default
        gradeToolBar.isTranslucent = true
        gradeToolBar.sizeToFit()

        let nextSchoolButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextSchool(_:)))
        let prevMajorButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.prevMajor(_:)))
        let nextMajorButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextMajor(_:)))
        let prevGradeButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.prevGrade(_:)))
        let loginButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.toolbarLogin(_:)))
        
        let schoolLabel = UILabel(frame: CGRect(x:0,y:0,width:200,height:21))
        schoolLabel.text = "School"
        schoolLabel.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        schoolLabel.textAlignment = NSTextAlignment.center
        let schoolTitle = UIBarButtonItem(customView: schoolLabel)
        
        let majorLabel = UILabel(frame: CGRect(x:0,y:0,width:200,height:21))
        majorLabel.text = "Major"
        majorLabel.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        majorLabel.textAlignment = NSTextAlignment.center
        let majorTitle = UIBarButtonItem(customView: majorLabel)
        
        let yearLabel = UILabel(frame: CGRect(x:0,y:0,width:200,height:21))
        yearLabel.text = "Year"
        yearLabel.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        yearLabel.textAlignment = NSTextAlignment.center
        let yearTitle = UIBarButtonItem(customView: yearLabel)

        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        schoolToolBar.setItems([spaceButton,schoolTitle,spaceButton, nextSchoolButton], animated: false)
        schoolToolBar.isUserInteractionEnabled = true
        
        majorsToolBar.setItems([prevMajorButton, spaceButton,majorTitle,spaceButton, nextMajorButton], animated: false)
        majorsToolBar.isUserInteractionEnabled = true
        
        gradeToolBar.setItems([prevGradeButton, spaceButton, yearTitle, spaceButton, loginButton], animated: false)
        gradeToolBar.isUserInteractionEnabled = true
        
        schoolPickerView.delegate = self
        majorPickerView.delegate = self
        yearPickerView.delegate = self
        
        schoolField.inputAccessoryView = schoolToolBar
        schoolField.inputView = schoolPickerView
        majorField.inputAccessoryView = majorsToolBar
        majorField.inputView = majorPickerView
        yearField.inputAccessoryView = gradeToolBar
        yearField.inputView = yearPickerView
        
        getSchools()
        
    }
    
    func getSchools() {
        let schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/colleges"
        
        let parameters: Parameters = [
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            
            switch response.result {
            case .success(let value):
                self.parseResults(theJSON: JSON(value),id:0)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getMajors(id: Int) {
        var schoolUrl = "https://bvet7wmxma.execute-api.us-east-1.amazonaws.com/prod/colleges/"
        
        schoolUrl = schoolUrl + String(id) + "/majors"
        
        let parameters: Parameters = [
            "app_token": "6vDahPFC9waiEwI3UMHbz5paBkTPRFZshJeDL7ZYnFXvbcoYRGtFPD6Ogh8iy6nI"
        ]
        
        AF.request(schoolUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON(completionHandler: {
            response in
            
            
            switch response.result {
            case .success(let value):
                self.parseResults(theJSON: JSON(value),id:1)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func parseResults(theJSON: JSON, id: Int) {
        
        if id == 0 {
            for item in theJSON["colleges"].arrayValue {
                var school = University()
                school.id = item["id"].intValue
                school.name = item["name"].stringValue
                school.email_tld = item["email_tld"].stringValue
                schoolOption.append(school)
            }
            schoolPickerView.reloadAllComponents()
        }
        else if id == 1 {
            for item in theJSON["majors"].arrayValue {
                majorsOption.append(item["name"].stringValue)
            }
            majorPickerView.reloadAllComponents()
        }
    }
    
    @IBAction func touched(_ sender: Any) {
        login.layer.shadowOpacity = 0
        login.layer.shadowRadius = 0
        login.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    @IBAction func weBack(_ sender: Any) {
        login.layer.shadowOpacity = 0
        login.layer.shadowRadius = 0
        login.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func touchExit(_ sender: Any) {
        login.layer.shadowOpacity = 1.0
        login.layer.shadowRadius = 1.0
        login.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        schoolField.resignFirstResponder()
        majorField.resignFirstResponder()
        yearField.resignFirstResponder()
        enableLogin()
    }
    
    @objc func nextSchool(_ sender:UIBarButtonItem!) {
        schoolField.text = schoolOption[schoolPickerView.selectedRow(inComponent: 0)].name!
        majorField.becomeFirstResponder()
        
        getMajors(id: schoolOption[schoolPickerView.selectedRow(inComponent: 0)].id)
        
    }
    
    @objc func nextMajor(_ sender:UIBarButtonItem!) {
        
        majorField.text =  majorsOption[majorPickerView.selectedRow(inComponent: 0)]
        yearField.becomeFirstResponder()
    }
    
    @objc func prevMajor(_ sender:UIBarButtonItem!) {
        //majorField.text = majorsOption[majorPickerView.selectedRow(inComponent: 0)]
        schoolField.becomeFirstResponder()
    }
    
    @objc func prevGrade(_ sender:UIBarButtonItem!) {
        //yearField.text = yearOption[yearPickerView.selectedRow(inComponent: 0)]
        majorField.becomeFirstResponder()
    }
    
    @objc func toolbarLogin(_ sender:UIBarButtonItem!) {
        yearField.text = yearOption[yearPickerView.selectedRow(inComponent: 0)]
        yearField.resignFirstResponder()
        enableLogin()

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func enableLogin() {

        if !schoolField.text!.isEmpty && !majorField.text!.isEmpty && !yearField.text!.isEmpty {
            login.isUserInteractionEnabled = true
            login.alpha = 1.0
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        login.layer.shadowOpacity = 1.0
        login.layer.shadowRadius = 1.0
        login.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        if (service.isLoggedIn) {
            // Logout
            service.logout()
            setLogInState(loggedIn: false)
        } else {
            // Login
            service.login(from: self) {
                error in
                if let unwrappedError = error {
                    NSLog("Error logging in: \(unwrappedError)")
                } else {
                    NSLog("Successfully logged in.")
                    self.setLogInState(loggedIn: true)
                    self.loadUserData()
                }
            }
        }
    }
    
    func loadUserData() {
        service.getUserEmail() {
            email in
            if let unwrappedEmail = email {
                NSLog("Hello \(unwrappedEmail)")
                
                
                if !unwrappedEmail.contains("fsu") {
                    let alert = UIAlertController(title: "Login Error", message: "It's appears you did not login with an FSU outlook email. Please login with an FSU email.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { action in
                        self.service.logout()
                        self.setLogInState(loggedIn: false)
                    }))
                    
                    self.present(alert, animated: true)
                }
                else {
                
                    let user = User(context: PersistenceService.context)
                    user.email = unwrappedEmail
                    user.major = self.majorField.text
                    user.school = self.schoolField.text
                    if self.yearField.text == "Undergraduate" {
                        user.undergrad = true
                    }
                    else {
                        user.undergrad = false
                    }
                
                    PersistenceService.saveContext()
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    

    
    
    func setLogInState(loggedIn: Bool) {
        if (loggedIn) {
            login.setTitle("Log Out", for: UIControl.State.normal)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            login.setTitle("Log In", for: UIControl.State.normal)
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPickerView {
            return schoolOption.count
        }
        else if pickerView == majorPickerView {
            return majorsOption.count
        }
        else if pickerView == yearPickerView {
            return yearOption.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == schoolPickerView {
            return schoolOption[row].name!
        }
        else if pickerView == majorPickerView {
            return majorsOption[row]
        }
        else if pickerView == yearPickerView {
            return yearOption[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == schoolPickerView {
            schoolField.text = schoolOption[row].name!
        }
        else if pickerView == majorPickerView {
            majorField.text = majorsOption[row]
        }
        else if pickerView == yearPickerView {
            yearField.text = yearOption[row]
        }
    }
    
}

