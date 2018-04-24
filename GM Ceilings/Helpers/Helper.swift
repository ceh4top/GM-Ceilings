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
        AnyObject?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    taskCallback(true, json as AnyObject?)
                } else {
                    taskCallback(false, nil)
                }
            }
        }).resume()
    }
}
