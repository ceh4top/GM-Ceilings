//
//  ConstantDataManagement.swift
//  GM Ceilings
//
//  Created by GM on 24.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation

class ConstantDataManagement {
    private static var auth : [String:Any] = [:]
    private static let userDefaults = UserDefaults.standard
    
    public static func loadData() {
        if let auth = userDefaults.dictionary(forKey: "auth") {
            self.auth = auth
        }
    }
    
    public static func getUser() -> UserData {
        let userData = UserData()
        
        if let id = self.auth["id"] as? Int {
            userData.id = id
        }
        
        if let login = self.auth["login"] as? String {
            userData.login = login
        }
        
        if let password = self.auth["password"] as? String {
            userData.password = password
        }
        
        if let changePassword = self.auth["changePassword"] as? Bool {
            userData.changePassword = changePassword
        }
        
        return userData
    }
    
    public static func setUser(user: UserData) {
        self.auth["id"] = user.id
        self.auth["login"] = user.login
        self.auth["password"] = user.password
        self.auth["changePassword"] = user.changePassword
        userDefaults.set(self.auth, forKey: "auth")
        userDefaults.synchronize()
    }
}
