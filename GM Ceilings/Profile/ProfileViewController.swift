//
//  ProfileViewController.swift
//  GM Ceilings
//
//  Created by GM on 24.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var Password: UIStackView!
    @IBOutlet weak var Entry: UIStackView!
    @IBOutlet weak var Profile: UIStackView!
    
    // Entry
    @IBOutlet weak var loginEntryTF: UITextField!
    @IBOutlet weak var passwordEntryTF: UITextField!
    
    @IBAction func EntryAction(_ sender: UIButton) {
        let username = self.loginEntryTF.text!
        let password = self.passwordEntryTF.text!
        self.assembleEntryForSend(username: username, password: password)
    }
    
    // Password
    @IBOutlet weak var passwordOldL: UILabel!
    @IBOutlet weak var passwordOldTF: UITextField!
    @IBOutlet weak var passwordOneTF: UITextField!
    @IBOutlet weak var passwordTwoTF: UITextField!
    
    @IBAction func EditPassword(_ sender: UIButton) {
        self.changePassword()
    }
    
    // Profile
    @IBOutlet weak var loginProfileL: UILabel!
    
    @IBAction func ExitAction(_ sender: UIButton) {
        self.user = UserData(id: 0, login: "", password: "", changePassword: false)
        ConstantDataManagement.setUser(user: self.user)
        
        self.Profile.isHidden = true
        self.Password.isHidden = true
        self.Entry.isHidden = false
        self.navigationItem.title = "Вход"
        
        CoreDataManager.instance.removeAll()
    }
    
    @IBAction func ShowChangePassword(_ sender: UIButton) {
        self.passwordOldL.isHidden = false
        self.passwordOldTF.isHidden = false
        
        self.Profile.isHidden = true
        self.Password.isHidden = false
        self.navigationItem.title = "Изменение пароля"
    }
    
    
    var user : UserData = UserData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Password.isHidden = true
        self.Entry.isHidden = true
        self.Profile.isHidden = true
        
        self.user = ConstantDataManagement.getUser()
        
        if user.login == "" {
            self.navigationItem.title = "Вход"
            
            self.Entry.isHidden =  false
            
            self.loginEntryTF.delegate = self
            self.passwordEntryTF.delegate = self
        }
        else if !user.changePassword {
            self.navigationItem.title = "Изменение пароля"
            
            self.passwordOldL.isHidden = true
            self.passwordOldTF.isHidden = true
            
            self.Password.isHidden = false
            
            self.passwordOneTF.delegate = self
            self.passwordTwoTF.delegate = self
        }
        else {
            self.navigationItem.title = "Профиль"
            
            self.Profile.isHidden = false
            
            loginProfileL.text = user.login
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
