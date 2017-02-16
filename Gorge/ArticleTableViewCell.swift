//
//  ArticleTableViewCell.swift
//  Gorge
//
//  Created by Joey on 05/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(_ article: Article) {
        switch article.state {
        case .parsing:
            self.nameLabel.text = article.url
            self.summaryLabel.text = "donwloading..."
        case .downloaded:
            self.nameLabel.text = article.title
            self.summaryLabel.text = article.excerpt
        default:
            self.nameLabel.text = article.title
            self.summaryLabel.text = "错误"
        }
    }
}
