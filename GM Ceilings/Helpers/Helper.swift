//
//  Helper.swift
//  GM Ceilings
//
//  Created by GM on 19.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation

public class Helper {    
    static func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    static func checkStringByPhone(string: String) -> Bool {
        let abc = "+0123456789"
        
        let lastSymbol = string.characters.last
        let firstSymbol = string.characters.first
        let countSymbols = string.characters.count
        
        if !abc.characters.contains(lastSymbol!) {
            return false
        }
        else if countSymbols > 1 && lastSymbol == "+" {
            return false
        }
        else if countSymbols > 12 && firstSymbol == "+" {
            return false
        }
        else if countSymbols > 11 && firstSymbol != "+" {
            return false
        }
        
        return true
    }
    
    public static func execTask(request: URLRequest, taskCallback: @escaping (Bool,
        AnyObject) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    taskCallback(true, json as AnyObject)
                } else {
                    taskCallback(false, 0 as AnyObject)
                }
            }
        }).resume()
    }
    
    public static func sendServer(parameters: [String : AnyObject], href: String, callback: @escaping (Bool, AnyObject) -> ()) {
        
        guard let urlPath = URL(string: href) else { return }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        self.execTask(request: request) { (status, json) in
            DispatchQueue.main.async {
                callback(status, json)
            }
        }
    }
}

extension UserDefaults{
    @nonobjc static var user : UserData = UserData()
    @nonobjc static var updatedUser : Bool = false
    
    static func loadUser() {
        let user = standard.dictionary(forKey: "user")
        
        if let id = user?["id"] as? String {
            self.user.id = id
        }
        if let login = user?["login"] as? String {
            self.user.login = login
        }
        if let password = user?["password"] as? String {
            self.user.password = password
        }
        if let changePassword = user?["changePassword"] as? Bool {
            self.user.changePassword = changePassword
        }
        if let firstLoad = user?["firstLoad"] as? Bool {
            self.user.firstLoad = firstLoad
        }
        
        Log.msg(self.user.toString())
        updatedUser = true
    }
    
    static func getUser() -> UserData {
        if !self.updatedUser {
            loadUser()
        }
        
        Log.msg(self.user.toString())
        return self.user
    }
    
    static func setUser(_ user: UserData) {
        self.user = user
        
        var userResult : [String : Any] = [:]
        userResult.updateValue(self.user.id, forKey: "id")
        userResult.updateValue(self.user.login, forKey: "login")
        userResult.updateValue(self.user.password, forKey: "password")
        userResult.updateValue(self.user.changePassword, forKey: "changePassword")
        userResult.updateValue(self.user.firstLoad, forKey: "firstLoad")
        
        standard.set(userResult, forKey: "user")
        self.updatedUser = false
        
        Log.msg(self.user.toString())
    }
    
    static func isChangePassword() -> Bool {
        if !self.updatedUser {
            loadUser()
        }
        
        return self.user.changePassword
    }
    
    static func isFirstLoad() -> Bool {
        if !self.updatedUser {
            loadUser()
        }
        
        return self.user.firstLoad
    }
}
