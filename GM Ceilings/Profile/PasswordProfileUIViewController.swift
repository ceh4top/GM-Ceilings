//
//  PasswordProfileUIViewController.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

extension ProfileViewController {
    func changePassword() {
        let passwordOld = self.passwordOldTF.text!
        let passwordOne = self.passwordOneTF.text!
        let passwordTwo = self.passwordTwoTF.text!
        let user_id = String(UserDefaults.getUser().id)
        
        if (passwordOne != passwordTwo) {
            Message.Show(title: "Пароли не совпадают", message: "Пароли не совпадают! Повторите ввод пароля", controller: self)
            return
        }
        
        assembleDataForSend(oldPassword: passwordOld, password: passwordOne, user_id: user_id!)
    }
    
    func assembleDataForSend(oldPassword : String, password : String, user_id : String) {
        var parameters : [String : String] = [:]
        
        parameters.updateValue(password, forKey: "password")
        parameters.updateValue(oldPassword, forKey: "old_password")
        parameters.updateValue(user_id, forKey: "user_id")
        
        if !InternetConnection.isConnectedToNetwork() {
            InternetConnection.messageConnection(controller: self)
        }
        else {
            sendServerChangePassword(parameters: parameters)
        }
    }
    
    func sendServerChangePassword(parameters: [String : String]) {
        guard let urlPath = URL(string: PList.changePswd) else { return }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        Helper.execTask(request: request) { (status, json) in
            DispatchQueue.main.async {
                var title = "Сервер не отвечает"
                var message = "Сервер не отвечает, попробуйте позже."
                
                if status {
                    Log.msg(json as Any)
                    if let statusAnswer = json["status"] as? String {
                        if statusAnswer == "success" {
                            let user = UserDefaults.getUser()
                            user.password = parameters["password"]!
                            user.changedPassword = true
                            UserDefaults.setUser(user)
                            
                            self.hideAll()
                            self.Profile.isHidden = false
                            self.navigationItem.title = "Профиль"
                            
                            self.loginProfileL.text = user.login
                        }
                        
                        if let t = json["title"] as? String {
                            title = t
                        }
                        
                        if let m = json["message"] as? String {
                            message = m
                        }
                    }
                }
                
                Message.Show(title: title, message: message, controller: self)
            }
        }
    }
    
}
