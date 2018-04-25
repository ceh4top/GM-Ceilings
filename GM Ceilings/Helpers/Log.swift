//
//  Log.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
class Log {
    class func msg(_ message: Any,
                   functionName:  String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line )
    {
        #if DEBUG
            let message = String(describing: message)
            let output = "\(NSDate()): \(message) [\(functionName) in \(fileNameWithPath), line \(lineNumber)]"
            print("\n----------------------------------------------------\n\n\n")
            print(output)
            print("\n\n\n----------------------------------------------------\n")
        #endif
    }
}
