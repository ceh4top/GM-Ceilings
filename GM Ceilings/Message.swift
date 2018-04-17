//
//  Message.swift
//  GM Celings
//
//  Created by GM on 10.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import UIKit

public class Message {
    static func Show(title: String, message: String, controller: UIViewController) {
        let alert = getShow(title: title, message: message, controller: controller)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func getShow(title: String, message: String, controller: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.default, handler: nil))
        return alert
        
    }
}
