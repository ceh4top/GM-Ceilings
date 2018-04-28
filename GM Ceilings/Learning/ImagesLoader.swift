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
        
        imagesURL.append("https://psv4.userapi.com/c834700/u29834478/docs/d17/d23a9e9bdebf/karta.png?extra=mqWEobmObWKoJXDMJUGklCWq3JUyWCCT8oRWw4Gawr5y18KtUE8O2xn8FZYOdUzyQ3LCcQmeZ6hHcNaafzALQn3qJDU5j5Em0cATetoEKxStK4H5x5LNI4mf1scKETCAoJm_XVOeDv4")
        
        imagesURL.append("https://psv4.userapi.com/c834700/u29834478/docs/d16/b020bf419bc0/zapis.png?extra=vcT6i0XrcK2jCDTkJwKvXUYU8osIw9zt4K67nvxu95Y2E6QhyN2hdA84KhaBS5_rwtXOStnT9npurOMbTsh7amIeGYJ9v7wwxSeoiFH0Rsx59UvbIXr9lT2oW6CEqRyL0ax9kC8V0_M")
        
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
}
