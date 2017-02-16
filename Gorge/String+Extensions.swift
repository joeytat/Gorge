//
//  Validation.swift
//  Gorge
//
//  Created by Joey on 05/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation

protocol Validation {
    func isURL() -> Bool
}

extension String: Validation {
    internal func isURL() -> Bool {
        guard let url = NSURL(string: self) else { return false }
        return (url.host != nil)
    }
}
