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
    
    @IBAction func EntryAction(_ sender: StyleUIButton) {
        let username = self.loginEntryTF.text!
        let password = self.passwordEntryTF.text!
        self.assembleEntryForSend(username: username, password: password)
    }
    
    // Password
    @IBOutlet weak var passwordOldL: UILabel!
    @IBOutlet weak var passwordOldTF: UITextField!
    @IBOutlet weak var passwordOneTF: UITextField!
    @IBOutlet weak var passwordTwoTF: UITextField!
    
    @IBAction func EditPassword(_ sender: StyleUIButton) {
        self.changePassword()
    }
    
    @IBAction func getProfilePage(_ sender: StyleUIButton) {
        self.loginProfileL.text = UserDefaults.getUser().login
        
        let user = UserDefaults.getUser()
        user.changedPassword = true
        UserDefaults.setUser(user)
        
        self.hideAll()
        self.Profile.isHidden = false
    }
    
    func hideAll() {
        self.Entry.isHidden = true
        self.Profile.isHidden = true
        self.Password.isHidden = true
        self.view.endEditing(true)
        self.clearAll()
    }
    
    func clearAll() {
        self.loginEntryTF.text = "+7"
        self.passwordEntryTF.text = ""
        self.passwordOldTF.text = ""
        self.passwordOneTF.text = ""
        self.passwordTwoTF.text = ""
    }
    
    // Profile
    @IBOutlet weak var loginProfileL: UILabel!
    
    @IBAction func ExitAction(_ sender: UIButton) {
        let user = UserData(id: "", login: "", password: "", changedPassword: false, firstLoad: false)
        UserDefaults.setUser(user)
        
        self.hideAll()
        self.Entry.isHidden = false
        self.navigationItem.title = "Вход"
        
        CoreDataManager.instance.removeAll()
    }
    
    @IBAction func ShowChangePassword(_ sender: UIButton) {
        self.passwordOldL.isHidden = false
        self.passwordOldTF.isHidden = false
        
        self.hideAll()
        self.Password.isHidden = false
        self.navigationItem.title = "Изменение пароля"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAll()
        
        let user = UserDefaults.getUser()
        
        if user.login == "" {
            self.navigationItem.title = "Вход"
            
            self.Entry.isHidden =  false
        }
        else if !user.changedPassword {
            self.navigationItem.title = "Изменение пароля"
            
            self.passwordOldL.isHidden = true
            self.passwordOldTF.isHidden = true
            
            self.Password.isHidden = false
        }
        else {
            self.navigationItem.title = "Профиль"
            
            self.Profile.isHidden = false
            
            loginProfileL.text = user.login
        }
        self.loginEntryTF.delegate = self
        self.passwordEntryTF.delegate = self
        
        self.passwordOneTF.delegate = self
        self.passwordTwoTF.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case loginEntryTF:
            return Helper.checkStringByPhone(string: (textField.text?.appending(string))!)
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
