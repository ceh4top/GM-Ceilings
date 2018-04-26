//
//  EntryProfileUIViewController.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

extension ProfileViewController {
    func assembleEntryForSend(username : String, password : String) {
        var parameters : [String : String] = [:]
        
        parameters.updateValue(username, forKey: "username")
        parameters.updateValue(password, forKey: "password")
        
        if !InternetConnection.isConnectedToNetwork() {
            InternetConnection.messageConnection(controller: self)
        }
        else {
            sendServerEntry(parameters: parameters)
        }
    }
    
    func sendServerEntry(parameters: [String : String]) {
        guard let urlPath = URL(string: "http://test1.gm-vrn.ru/index.php?option=com_gm_ceiling&task=api.iOSauthorisation") else { return }
        
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
                    if let json = json as? [String : AnyObject] {
                        Log.msg(json as Any)
                        if let statusAnswer = json["status"] as? String {
                            if statusAnswer == "success" {
                                self.user.password = parameters["password"]!
                                self.user.changePassword = true
                                UserDefaults.setUser(self.user)
                                
                                self.Entry.isHidden = true
                                self.Password.isHidden = true
                                self.Profile.isHidden = false
                                self.navigationItem.title = "Профиль"
                                
                                self.loginEntryTF.text = self.user.login
                                
                                self.setData(json)
                            }
                            
                            if let t = json["title"] as? String {
                                title = t
                            }
                            
                            if let m = json["message"] as? String {
                                message = m
                            }
                        }
                    }
                }
                
                Message.Show(title: title, message: message, controller: self)
            }
        }
    }
    
    func setData(_ json : [String : AnyObject]) {
        if let data = json["data"] as? [String : AnyObject] {
            if let projects = data["rgzbn_gm_ceiling_projects"] as? [AnyObject] {
                for object in projects {
                    if let calc = object as? [String:AnyObject] {
                        let measurement = Measurement()
                        
                        if let address = calc["project_info"] as? String {
                            if address != "<null>" {
                                measurement.address = address
                            }
                        }
                        
                        if let status = calc["project_status"] as? String {
                            if status != "<null>" {
                                measurement.status = status
                            }
                        }
                        
                        if let projectId = calc["id"] as? String {
                            if projectId != "<null>" {
                                measurement.projectId = projectId
                            }
                        }
                        
                        if let projectSum = calc["project_sum"] as? String {
                            if projectSum != "<null>" {
                                measurement.projectSum = projectSum
                            }
                        }
                    }
                }
                CoreDataManager.instance.saveContext()
            }
        }
    }
}
