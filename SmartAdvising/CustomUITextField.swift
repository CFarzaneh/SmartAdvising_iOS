//
//  CustomUITextField.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 4/1/19.
//

import Foundation
import UIKit  // don't forget this

class CustomUITextField: UITextField {    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
