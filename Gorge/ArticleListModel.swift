//
//  ArticleListModel.swift
//  Gorge
//
//  Created by Joey on 09/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import Moya
import Moya_ObjectMapper
import ObjectMapper

enum ParseResult {
    case finished(article: Article)
    case failed(message: String)
}

enum ArticleResult {
    case finished(article: Article)
    case failed(message: String)
}

struct ArticleListModel {
    let provider: RxMoyaProvider<Mercury>
    let articleURL: Observable<String>
    let articles: Variable<[Article]> = Variable([])
    
    func addArticle() -> Observable<ArticleResult> {
        return articleURL
            .observeOn(MainScheduler.asyncInstance)
            .flatMap {url in
                return self.parseURL(url: url)
            }
            .flatMap {(result: ParseResult) -> Observable<ArticleResult> in
                switch result {
                case .failed(let message):
                    return Observable.just(ArticleResult.failed(message: message))
                case .finished(let article):
                    guard let index = self.articles.value.index(of: article) else {
                        self.articles.value.insert(article, at: 0)
                        return Observable.just(ArticleResult.finished(article: article))
                    }
                    self.articles.value.remove(at: index)
                    self.articles.value.insert(article, at: index)
                    return Observable.just(ArticleResult.finished(article: article))
                }
            }
    }
    
    internal func parseURL(url: String) -> Observable<ParseResult> {
        // TODO: - I don't think placeholder data should be here
        let parsingArticle = Article()
        parsingArticle.url = url
        parsingArticle.state = .parsing
        self.articles.value.insert(parsingArticle, at: 0)
        
        return self.provider
            .request(Mercury.parse(url: url))
            .mapObject(Article.self)
            .map {article in
                article.state = .downloaded
                article.uuid = parsingArticle.uuid
                return ParseResult.finished(article: article)
            }
            .catchErrorJustReturn(ParseResult.failed(message: "Parse Failed"))
    }
}
