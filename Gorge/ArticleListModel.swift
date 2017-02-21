//
//  ArticleListModel.swift
//  Gorge
//
//  Created by Joey on 09/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import Moya
import Moya_ObjectMapper
import ObjectMapper
import RxRealm
import RealmSwift

enum ParseResult {
    case finished(article: Article)
    case failed(message: String)
}

struct ArticleListModel {
    //    let articles: Observable<[Article]>
    let urlValidation: Observable<String>
    let addArticle: Observable<ParseResult>
    let articles: Observable<[Article]>
    
    
    init(addButtonTap: Observable<Void>) {
        let pasteboardChanged = NotificationCenter.default.rx
            .notification(Notification.Name.UIPasteboardChanged)
        let didBecomeActive = NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationDidBecomeActive)
        
        urlValidation = Observable
            .of(pasteboardChanged, didBecomeActive)
            .merge()
            .flatMap{ n -> Observable<String> in
                guard let clipStr = UIPasteboard.general.string, clipStr.isURL() else {
                    return Observable.never()
                }
                return  Observable.just(clipStr)
            }
            .distinctUntilChanged()
            .shareReplay(1)
        
        addArticle = Observable
            .zip(urlValidation, addButtonTap) { $0.0 }
            .do(onNext: { url in
                let realm = try! Realm()
                let article = Article()
                article.originalURL = url
                try! realm.write {
                    realm.add(article)
                }
            })
            .flatMap{ MercuryProvider.request(Mercury.parse(url: $0))}
            .mapObject(Article.self)
            .map {article -> ParseResult in
                article.state = .downloaded
                if let url = UIPasteboard.general.string, url.isURL() {
                    article.originalURL = url
                } else {
                    article.originalURL = article.url
                }
                return .finished(article: article)
            }
            .do(onNext: { result in
                switch result {
                case .finished(let article) :
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(article, update: true)
                    }
                case .failed(let message):
                    logging(message)
                }
            })
            .catchErrorJustReturn(.failed(message: "Failed to add article"))
        
        let realm = try! Realm()
        articles = Observable.array(from: realm.objects(Article.self))
    }
}
