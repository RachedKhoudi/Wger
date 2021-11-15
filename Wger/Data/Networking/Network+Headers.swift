//
//  Network+Headers.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Alamofire

extension Network {
    
    static var securedHeaders: HTTPHeaders {
        let defaultsHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        let tokenHeader = HTTPHeader(name: "Authorization", value: Environment.Api.token)

        return HTTPHeaders([defaultsHeader, tokenHeader])
    }
}
