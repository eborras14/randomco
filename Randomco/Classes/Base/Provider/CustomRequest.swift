//
//  CustomRequest.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import VIPERPLUS

protocol CustomRequestProtocol {
    var headers: [String: String]? { get set }
    
    static func getCustomRequest(params: BaseServerModel?, headers: [String: String]?) -> CustomRequest
}

class CustomRequest {
    
    var method: HTTPMethod
    var urlContext: BaseURLContext
    var endpoint: String
    var fullEndpoint: String {
        let baseURL = URLEndpoint.getBaseUrl(urlContext: urlContext)
        return "\(baseURL)\(endpoint)"
    }
    var headers: [String: String] = [:]
    var params: [String: Any]?
    var arrayParams: [[String: Any]]?
    var acceptType = AcceptResponseType.json
    
    var additionalConfiguration: AdditionalConfiguration = AdditionalConfiguration()
    
    init() {
        method = .get
        urlContext = .randomco
        endpoint = ""
    }
    
    init(method: HTTPMethod,
         urlContext: BaseURLContext,
         endpoint: String,
         headers: [String: String]? = nil,
         params: [String: Any]?,
         acceptType: AcceptResponseType = AcceptResponseType.json,
         additionalConfiguration: AdditionalConfiguration = AdditionalConfiguration()) {
        
        self.method = method
        self.urlContext = urlContext
        self.endpoint = endpoint
        self.headers = headers ?? [:]
        self.params = params
        self.acceptType = acceptType
        self.additionalConfiguration = additionalConfiguration
        self.addHeaders(BaseProviderUtils.getHeadersFromContext(urlContext, authenticated: additionalConfiguration.authenticated))
    }
    
    init(method: HTTPMethod,
         urlContext: BaseURLContext,
         endpoint: String,
         headers: [String: String]? = nil,
         arrayParams: [[String: Any]]?,
         acceptType: AcceptResponseType = AcceptResponseType.json,
         additionalConfiguration: AdditionalConfiguration = AdditionalConfiguration()) {
        
        self.method = method
        self.urlContext = urlContext
        self.endpoint = endpoint
        self.headers = headers ?? [:]
        self.arrayParams = arrayParams
        self.acceptType = acceptType
        self.additionalConfiguration = additionalConfiguration
        
        self.addHeaders(BaseProviderUtils.getHeadersFromContext(urlContext, authenticated: additionalConfiguration.authenticated))
    }
    
    func addHeaders(_ newHeaders: [String: String]) {
        
        var headers = self.headers
        headers.merge(newHeaders) { _, new in new }
        self.headers = headers
    }
}

extension CustomRequest {
    struct AdditionalConfiguration {

        var timeout: TimeInterval = 30
        var printLog = true
        var encrypted = false
        var authenticated = false
        
        init(timeout: TimeInterval = 30, printLog: Bool = true, encrypted: Bool = false, authenticated: Bool = false) {
            
            self.timeout = timeout
            self.printLog = printLog
            self.encrypted = encrypted
            self.authenticated = authenticated
        }
    }
}

extension CustomRequestProtocol {
    static func getCustomRequest(params: BaseServerModel?, headers: [String: String]?) -> CustomRequest { CustomRequest() }
}
