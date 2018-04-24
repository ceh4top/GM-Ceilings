//
//  UserData.swift
//  GM Ceilings
//
//  Created by GM on 24.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
class UserData {
    public var id : Int
    public var login : String
    public var password : String
    public var changePassword : Bool
    
    init(id: Int, login: String, password: String, changePassword: Bool) {
        self.id = id
        self.login = login
        self.password = password
        self.changePassword = changePassword
    }
    
    init() {
        self.id = 0
        self.login = ""
        self.password = ""
        self.changePassword = false
    }
    
    public func toString() -> String {
        return "id: \(self.id); login: \(self.login); password: \(self.password); change: \(self.changePassword)"
    }
}
