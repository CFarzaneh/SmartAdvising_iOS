//
//  LoginViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    let schoolOption = ["Florida State University"]
    let majorsOption = ["Computer Science", "Physics", "Mathematics"]
    let yearOption = ["Undergraduate", "Graduate"]
    
    let schoolPickerView = UIPickerView()
    let majorPickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        loginFieldsView.layer.cornerRadius = 5
        
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
        let loginButton = UIBarButtonItem(title: "Login", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.toolbarLogin(_:)))

        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        schoolToolBar.setItems([spaceButton, nextSchoolButton], animated: false)
        schoolToolBar.isUserInteractionEnabled = true
        
        majorsToolBar.setItems([prevMajorButton, spaceButton, nextMajorButton], animated: false)
        majorsToolBar.isUserInteractionEnabled = true
        
        gradeToolBar.setItems([prevGradeButton, spaceButton, loginButton], animated: false)
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
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        schoolField.resignFirstResponder()
        majorField.resignFirstResponder()
        yearField.resignFirstResponder()
    }
    
    @objc func nextSchool(_ sender:UIBarButtonItem!) {
        schoolField.text = schoolOption[schoolPickerView.selectedRow(inComponent: 0)]
        majorField.becomeFirstResponder()
    }
    
    @objc func nextMajor(_ sender:UIBarButtonItem!) {
        
        majorField.text =  majorsOption[majorPickerView.selectedRow(inComponent: 0)]
        yearField.becomeFirstResponder()
    }
    
    @objc func prevMajor(_ sender:UIBarButtonItem!) {
        majorField.text = majorsOption[majorPickerView.selectedRow(inComponent: 0)]
        schoolField.becomeFirstResponder()
    }
    
    @objc func prevGrade(_ sender:UIBarButtonItem!) {
        yearField.text = yearOption[yearPickerView.selectedRow(inComponent: 0)]
        majorField.becomeFirstResponder()
    }
    
    @objc func toolbarLogin(_ sender:UIBarButtonItem!) {
        yearField.text = yearOption[yearPickerView.selectedRow(inComponent: 0)]
        yearField.resignFirstResponder()
        print("Login")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
            return schoolOption[row]
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
            schoolField.text = schoolOption[row]
        }
        else if pickerView == majorPickerView {
            majorField.text = majorsOption[row]
        }
        else if pickerView == yearPickerView {
            yearField.text = yearOption[row]
        }
    }
    
}

