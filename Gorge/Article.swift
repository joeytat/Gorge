//
//  Article.swift
//  Gorge
//
//  Created by Joey on 07/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Article: Object, Mappable {
    @objc enum State: Int {
        case error
        case invisible
        case parsing
        case downloaded
    }
    
    dynamic var url: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var leadImageURL: String = ""
    dynamic var domain: String = ""
    dynamic var excerpt: String = ""
    dynamic var wordCount: Int = 0
    dynamic var datePublished: Date = Date()
    dynamic var state: State = .invisible
    dynamic var uuid: String = UUID().uuidString
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        content <- map["content"]
        datePublished <- map["date_published"]
        leadImageURL <- map["lead_image_url"]
        url <- map["url"]
        domain <- map["domain"]
        excerpt <- map["excerpt"]
        wordCount <- map["word_count"]
        state <- map["stateRaw"]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? Article else { return false }
        return self.uuid == rhs.uuid
    }
}
