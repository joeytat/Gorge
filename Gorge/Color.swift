//
//  Color.swift
//  Gorge
//
//  Created by Joey on 05/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case darkPrimary
    case primary
    case lightPrimary
    case text
    case accent
    case primaryText
    case secondaryText
    case divider
    
    func color(alpha: CGFloat = 1.0) -> UIColor {
        switch self {
        case .darkPrimary:
            return UIColor(hue:0.55, saturation:0.33, brightness:0.39, alpha:alpha)
        case .primary:
            return UIColor(hue:0.55, saturation:0.33, brightness:0.54, alpha:alpha)
        case .lightPrimary:
            return UIColor(hue:0.55, saturation:0.06, brightness:0.86, alpha:alpha)
        case .text:
            return UIColor(hue:0.00, saturation:0.00, brightness:1.00, alpha:alpha)
        case .accent:
            return UIColor(hue:0.94, saturation:0.76, brightness:1.00, alpha:alpha)
        case .primaryText:
            return UIColor(hue:0.00, saturation:0.00, brightness:0.13, alpha:alpha)
        case .secondaryText:
            return UIColor(hue:0.00, saturation:0.00, brightness:0.46, alpha:alpha)
        case .divider:
            return UIColor(hue:0.00, saturation:0.00, brightness:0.74, alpha:alpha)
        }
    }
}
