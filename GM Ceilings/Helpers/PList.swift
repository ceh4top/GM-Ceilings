//
//  PList.swift
//  GM Ceilings
//
//  Created by GM on 26.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation

public class PList {
    static let server = "http://calc.gm-vrn.ru/"
    static let api = server + "index.php?option=com_gm_ceiling&task=api."
    static let calculation = server + "client_calculate.php?device=ios"
    static let addNewClient = api + "addNewClient"
    static let iOSauthorisation = api + "iOSauthorisation"
    static let changePswd = api + "changePswd"
    static let getTimes = api + "getTimes"
    static let termsofuse = "https://xn--c1akfdemag2a.xn--p1ai/footer/terms_of_use.html"
    
    static var property : [String : String] = [:]
    
    static func loadProperty() {
        Helper.loadServer(href: "http://calc.gm-vrn.ru/iOS/property.json") { (status, json) in
            Log.msg(json)
            if status {
                self.property = json as! [String : String]
            }
            Log.msg(self.property)
        }
    }
    
    static func isEmptyProperty() -> Bool {
        return !(property.count > 0)
    }
}
