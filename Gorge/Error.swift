//
//  Error.swift
//  Gorge
//
//  Created by Joey on 07/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation

func error(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "com.joeytat.gorge", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}
