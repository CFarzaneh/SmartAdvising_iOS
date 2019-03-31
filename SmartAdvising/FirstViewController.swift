//
//  FirstViewController.swift
//  SmartAdvising
//
//  Created by Cameron Farzaneh on 3/27/19.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
        self.present(controller, animated: true, completion: nil)

    }


}

