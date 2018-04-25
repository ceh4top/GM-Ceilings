//
//  ProfileViewController.swift
//  GM Ceilings
//
//  Created by GM on 24.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var Password: UIStackView!
    @IBOutlet weak var Entry: UIStackView!
    @IBOutlet weak var Profile: UIStackView!
    
    var user : UserData = UserData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Password.isHidden = true
        self.Entry.isHidden = true
        self.Profile.isHidden = true
        
        self.user = ConstantDataManagement.getUser()
        
        if user.login == "" {
            self.Entry.isHidden =  false
        }
        else if !user.changePassword {
            self.Password.isHidden = false
        }
        else {
            self.Profile.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
