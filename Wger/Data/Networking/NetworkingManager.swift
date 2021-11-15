//
//  NetworkingManager.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import RxSwift
import Alamofire

// MARK: - Networking Manager Protocol
protocol NetworkingManagerProtocol {
    func request<T: Codable>(source: API.Wger, ofType: T.Type) -> Single<T>
}

// MARK: - Networking Manager

class NetworkingManager: NetworkingManagerProtocol {
    private let session: Session

    init() {
        let configuration = URLSessionConfiguration.default
        session = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Codable>(source: API.Wger, ofType: T.Type) -> Single<T> {
        do {
            
            let urlRequest = try getRequestAPI(source: source).asURLRequest()
            
            return Observable<T>.create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                
                
                self.session.request(urlRequest)
                    .validate()
                    .responseJSON(completionHandler: { response in
                        guard response.error == nil else {
                            observer.onError(Network.Errors.serverError)
                            return
                        }
                        
                        guard response.response?.statusCode != nil else {
                            observer.onError(Network.Errors.serverError)
                            return
                        }
                        
                        switch response.result {
                        case .success:
                            do {
                                let decoder = JSONDecoder()
                                let data = try decoder.decode(T.self, from: response.data!)
                                observer.onNext(data)
                                observer.onCompleted()
                            } catch{
                                observer.onError(Network.Errors.serverError)
                            }
                        case .failure:
                            observer.onError(Network.Errors.serverError)
                            break
                        }
                    })
                return Disposables.create()
            }.asSingle()
        } catch {
            return Observable<T>.create { _ in return Disposables.create() }.asSingle()
        }
    }
    
    private func getRequestAPI(source: API.Wger) -> API.Wger {
        switch source {
        case .exercises:
            return API.Wger.exercises
        case .exerciseImage(let isMain, let exerciseBase):
            return API.Wger.exerciseImage(isMain: isMain, exerciseBase: exerciseBase)
        case .exerciseInfo(let exerciseId):
            return API.Wger.exerciseInfo(exerciseId: exerciseId)
        case .variation(let variationId):
            return API.Wger.variation(variationId: variationId)
        }
    }
}
