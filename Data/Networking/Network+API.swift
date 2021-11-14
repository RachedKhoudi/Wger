//
//  NetworkingAPI.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Alamofire

struct API {
    enum Wger {
        case exercises
        case exerciseImage(isMain: Bool, exerciseBase: Int)
        case exerciseInfo(exerciseId: Int)
        case variation(variationId: Int)
    }
}

extension API.Wger: NetworkUrl {
    
    var method: HTTPMethod {
        switch self {
        case .exercises, .exerciseImage, .exerciseInfo, .variation :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .exercises:
            return "/exercise/"
        case .exerciseImage:
            return "/exerciseimage/"
        case .exerciseInfo(let exerciseId):
            return "/exerciseinfo/\(exerciseId)"
        case .variation(let variationId):
            return "/exercise/\(variationId)"
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var parameters: Parameters? {
        switch self {
        case .exercises:
            return nil
        case .exerciseImage(let isMain, let exerciseBase):
            return ["is_main":isMain, "exercise_base":exerciseBase]
        case .exerciseInfo, .variation:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        return Network.securedHeaders
    }
}
