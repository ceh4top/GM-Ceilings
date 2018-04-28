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
    public var changedPassword : Bool
    public var firstLoad : Bool
    
    init(id: String, login: String, password: String, changedPassword: Bool, firstLoad: Bool) {
        self.id = id
        self.login = login
        self.password = password
        self.changedPassword = changedPassword
        self.firstLoad = firstLoad
    }
    
    init() {
        self.id = ""
        self.login = ""
        self.password = ""
        self.changedPassword = false
        self.firstLoad = true
    }
    
    public func toString() -> String {
        return "id: \(self.id); login: \(self.login); password: \(self.password); change: \(self.changedPassword); first: \(self.firstLoad)"
    }
}
