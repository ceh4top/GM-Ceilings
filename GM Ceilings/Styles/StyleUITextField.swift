//
//  StyleUITextField.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class StyleUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawTextField()
    }
    
    func drawTextField() {
        layer.cornerRadius = 5
    }

}
