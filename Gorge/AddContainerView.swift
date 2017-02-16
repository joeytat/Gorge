//
//  AddContainerView.swift
//  Gorge
//
//  Created by Joey on 06/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit

class AddContainerView: UIView {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
        layer.borderColor = Color.divider.color(alpha: 0.7).cgColor
        layer.borderWidth = 0.5
        layer.shadowColor = Color.darkPrimary.color(alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: -0.5)
        layer.shadowOpacity = 1.0
    }
    
    func populate(url: String) {
        urlLabel.text = url
    }
}
