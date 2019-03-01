//
//  NetworkClient.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct APIRequest {
    let method: HTTPMethod
    let request: URL
}

class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let sessionManager = SessionManager.default
    private var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func execute<T>(request: URLRequest) -> Observable<(Result<T>)> where T: Codable {
        return sessionManager.rx
            .request(urlRequest: request)
            .validate(statusCode: 200...299)
            .data()
            .flatMap { data -> Observable<(Result<T>)> in
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    return Observable.just(.success(obj))
                } catch let error {
                    print("PARSE ERROR = \(error)")
                    return Observable.just(.failure(error))
                }
                
            }
        
    }
    
    func downloadImage(request: URLRequest) -> Observable<(Result<UIImage>)> {
        return sessionManager.rx
            .request(urlRequest: request)
            .validate(statusCode: 200...299)
            .data()
            .flatMap { downloadedData -> Observable<(Result<UIImage>)> in
                guard let image = UIImage(data: downloadedData) else { return Observable.just(.failure(RequestError.ParsingRequest.imageDataCorrupt)) }
                return Observable.just(.success(image))
            }
        
    }
    
}
