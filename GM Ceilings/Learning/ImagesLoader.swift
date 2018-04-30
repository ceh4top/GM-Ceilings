//
//  ImagesLoader.swift
//  GM Ceilings
//
//  Created by GM on 27.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import UIKit

public class ImagesLoader {
    static var images : [UIImage] = []
    
    static func loadImages() {
        var imagesURL : [String] = []
        
        switch UIDevice().model {
        case "iPad":
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPad/png/0.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPad/png/1.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPad/png/2.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPad/png/3.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPad/png/4.png")
            break
        default:
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPhone/png/0.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPhone/png/1.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPhone/png/2.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPhone/png/3.png")
            imagesURL.append("http://calc.gm-vrn.ru/images/ios/iPhone/png/4.png")
            break
        }        
        
        for str in imagesURL {
            Log.msg(str)
            if let url = NSURL(string: str) {
                Log.msg(url as Any)
                let contentsOfURL = NSData(contentsOf: url as URL)
                if let imageData = contentsOfURL {
                    self.images.append(UIImage(data: imageData as Data)!)
                }
            }
        }
    }
    
    static func clearImages() {
        self.images.removeAll()
    }
}
