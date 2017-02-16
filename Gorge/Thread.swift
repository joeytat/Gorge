//
//  Thread.swift
//  Gorge
//
//  Created by Joey on 05/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation

func delay(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
