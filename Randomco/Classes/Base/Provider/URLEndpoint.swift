//
//  URLEndpoint.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import UIKit

public enum Environment: Int {
    case DEV = 0
}

/// Base Url Context
public enum BaseURLContext {
    /// No Base Url
    case providedByService
    /// RandomCo
    case randomco
}

struct AppStore {
    static let url: String = ""
}

struct URLEndpoint {
    static let environmentDefault: Environment = Environment.DEV
    
    // MARK: Endpoints
    //TODO: Add endpoints
}

extension URLEndpoint {
    
    static func getBaseUrl(urlContext: BaseURLContext) -> String {
        
        switch urlContext {
        case .providedByService:
            return ""
        case .randomco:
            switch self.environmentDefault {
            case .DEV:
                let version = URLEndpoint.getVersion(urlContext: urlContext)
                if version.isEmpty {
                    return "https://api.randomuser.me/"
                } else {
                    return "https://api.randomuser.me/\(version)/"
                }
            //TODO: Add more enviroments
            }
        }
    }
    
    static func getVersion(urlContext: BaseURLContext) -> String {
        
        switch urlContext {
        case .randomco:
            return getBackendVersion()
        case .providedByService:
            return ""
        }
    }
    
    
    static func getBackendVersion() -> String {
        switch self.environmentDefault {
        case .DEV:
            return ""
        }
    }
}
