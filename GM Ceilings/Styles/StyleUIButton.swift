//
//  StyleUIButton.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class StyleUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }
    
    func drawButton() {
        layer.cornerRadius = 5
    }
    
}
