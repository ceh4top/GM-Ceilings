//
//  UserData.swift
//  GM Ceilings
//
//  Created by GM on 24.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
class UserData {
    public var id : String
    public var login : String
    public var password : String
    public var changePassword : Bool
    public var firstLoad : Bool
    
    init(id: String, login: String, password: String, changePassword: Bool, firstLoad: Bool) {
        self.id = id
        self.login = login
        self.password = password
        self.changePassword = changePassword
        self.firstLoad = firstLoad
    }
    
    init() {
        self.id = ""
        self.login = ""
        self.password = ""
        self.changePassword = false
        self.firstLoad = true
    }
    
    public func toString() -> String {
        return "id: \(self.id); login: \(self.login); password: \(self.password); change: \(self.changePassword); first: \(self.firstLoad)"
    }
}
