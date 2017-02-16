//
//  View.swift
//  Gorge
//
//  Created by Joey on 06/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import UIKit

protocol ViewFrame {
    var x: CGFloat { get }
    var y: CGFloat { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}
extension UIView: ViewFrame {
    var x: CGFloat {
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
    }
}


protocol UIViewLoading {}
extension UIView : UIViewLoading {}
extension UIViewLoading where Self : UIView {
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
