//
//  Network+Url.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Alamofire

protocol NetworkUrl: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
}

extension NetworkUrl {
    func asURLRequest() throws -> URLRequest {
        let urlString = Environment.Api.baseURL + Environment.Api.api + self.path
        guard let url = URL(string: urlString),
              let urlRequest = try? URLRequest(url: url, method: self.method, headers: self.headers),
              let encodedURLRequest = try? self.encoding.encode(urlRequest, with: self.parameters)
        
        else { throw Network.Errors.encodingError }
        return encodedURLRequest
    }
}
