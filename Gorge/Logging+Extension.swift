//
//  Console+Extension.swift
//  Gorge
//
//  Created by Joey on 16/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
public func logging<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String
        
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            stringRepresentation = "\(value)"
        }
        let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
    #endif
}
