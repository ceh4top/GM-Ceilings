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
                                self.loginEntryTF.text = parameters["username"]!
                                self.user.password = parameters["password"]!
                                self.user.changePassword = true
                                ConstantDataManagement.setUser(user: self.user)
                                
                                self.Entry.isHidden = true
                                self.Password.isHidden = true
                                self.Profile.isHidden = false
                                self.navigationItem.title = "Профиль"
                                
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
                    if let calc = object as? [String:String] {
                        let measurement = Measurement()
                        measurement.address = ((calc["project_info"] != nil) ? calc["project_info"] : "")
                        measurement.status = ((calc["project_status"] != nil) ? calc["project_status"] : "")
                        measurement.projectId = ((calc["id"] != nil) ? calc["id"] : "")
                        measurement.projectSum = ((calc["project_sum"] != nil) ? calc["project_sum"] : "")
                    }
                }
                CoreDataManager.instance.saveContext()
            }
        }
    }
}
