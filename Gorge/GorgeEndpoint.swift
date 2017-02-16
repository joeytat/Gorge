//
//  Mercury.swift
//  Gorge
//
//  Created by Joey on 09/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import Foundation
import Moya

enum Mercury {
    case parse(url: String)
}

extension Mercury: TargetType {
    var baseURL: URL { return URL(string: "https://mercury.postlight.com")!}
    
    var path: String {
        switch self {
        case .parse(_):
            return "/parser"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .parse(let url):
            return ["url": url]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        switch self {
        case .parse(_):
            guard let path = Bundle.main.path(forResource: "article", ofType: "json"),
                let data = Data(base64Encoded: path) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        return .request
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

// MARK: - Provider

fileprivate let mercuryClosure = { (target: Mercury) -> Endpoint<Mercury> in
    let defaultEndpoint = MoyaProvider<Mercury>.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["x-api-key": "SOhtMyGPi5grRBD1fv7OD6XEsnD15vjFA8VAUU6o"])
}

let MercuryProvider = RxMoyaProvider(endpointClosure: mercuryClosure, plugins: [NetworkLoggerPlugin(verbose: true)])
