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
}
