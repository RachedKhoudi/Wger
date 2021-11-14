//
//  NetworkingAPI.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Alamofire

struct API {
    enum ExercisesViewController {
        case exercises
        case exerciseImage(isMain: Bool, exerciseBase: Int)
    }
}

extension API.ExercisesViewController: NetworkUrl {
    
    var method: HTTPMethod {
        switch self {
        case .exercises, .exerciseImage :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .exercises:
            return "/exercise/"
        case .exerciseImage:
            return "/exerciseimage/"
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
        }
    }
    
    var headers: HTTPHeaders {
        return Network.securedHeaders
    }
}
