//
//  Network+Error.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation

// MARK: - Networking Error

extension Network {
    enum Errors: Error {
        
        //MARK:- Networking errors
        case serverError
        case noDataFound
        case wrongCredentials
        
        //MARK:- Credentials errors
        case missing
        case wrongFormat
        case encodingError
        
        case unkown
    }
}


// MARK: - Networking Error Localizables

class ErrorLocalizables {
    
    // MARK: - fetch Message
    
    static func fetchNetworkingMessage(from error: Network.Errors) -> String {
        switch error {
        case .noDataFound:
            return "error_no_data_found"
        case .missing:
            return "missing_credentials"
        case .wrongFormat:
            return "wrong_format"
        case .wrongCredentials:
            return "wrong_credentials"
        default:
            return "error_server"
        }
    }
}
