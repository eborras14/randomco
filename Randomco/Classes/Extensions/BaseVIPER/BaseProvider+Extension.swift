//
//  BaseProvider+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import VIPERPLUS

extension BaseProvider {
    func customRequest(_ customRequest: CustomRequest,
                       success: @escaping (Data?) -> Void,
                       failure: @escaping (BaseErrorModel) -> Void) -> URLSessionTask? {
        if !NetworkManager.shared.checkNetwork() {
            failure(BaseErrorModel(httpClientError: HTTPClientError.ErrorType.networkError, backendError: BackendError.ErrorType.unknownError))
            self.delegate?.networkNotReachable()
            return nil
        }
    
        let requestDto = BaseProviderDTO(params: customRequest.params,
                                         method: customRequest.method,
                                         domain: "",
                                         endpoint: customRequest.endpoint,
                                         baseUrl: URLEndpoint.getBaseUrl(urlContext: customRequest.urlContext),
                                         acceptType: customRequest.acceptType,
                                         additionalHeader: customRequest.headers,
                                         flagsDto: BaseFlagsProviderDTO(
                                            isLogin: customRequest.additionalConfiguration.authenticated,
                                            printLog: customRequest.additionalConfiguration.printLog,
                                            encrypted: customRequest.additionalConfiguration.encrypted,
                                            timeout: customRequest.additionalConfiguration.timeout))
        BaseProviderUtils.printRequest(customRequest)
        if var manager = self.manager {
            manager.delegate = self.delegate
            let request  = self.request(requestDto: requestDto) { responseData in
                switch responseData {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            }
            self.task = request
            return request
        } else {
            let customError: BaseErrorModel
            customError = BaseErrorModel(httpClientError: .notFound, backendError: .invalidUserData)
            failure(customError)
            return nil
        }
    }
    
    internal func request(_ customRequest: CustomRequest, completion: @escaping (Result<Data?, BaseErrorModel>) -> Void) -> URLSessionTask? {
        if !NetworkManager.shared.checkNetwork() {
            completion(.failure(BaseErrorModel(httpClientError: HTTPClientError.ErrorType.networkError, backendError: BackendError.ErrorType.unknownError)))
            self.delegate?.networkNotReachable()
            return nil
        }
    
        let requestDto = BaseProviderDTO(params: customRequest.params,
                                         method: customRequest.method,
                                         domain: "",
                                         endpoint: customRequest.endpoint,
                                         baseUrl: URLEndpoint.getBaseUrl(urlContext: customRequest.urlContext),
                                         acceptType: customRequest.acceptType,
                                         additionalHeader: customRequest.headers,
                                         flagsDto: BaseFlagsProviderDTO(
                                            isLogin: customRequest.additionalConfiguration.authenticated,
                                            printLog: customRequest.additionalConfiguration.printLog,
                                            encrypted: customRequest.additionalConfiguration.encrypted,
                                            timeout: customRequest.additionalConfiguration.timeout))
        BaseProviderUtils.printRequest(customRequest)
        if var manager = self.manager {
            manager.delegate = self.delegate
            
            let request = manager.request(requestDto: requestDto) { result in
                switch result {
                case .success(let data):

                    DispatchQueue.main.async {
                        completion(.success(data))
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            self.task = request
            return request
        } else {
            let customError: BaseErrorModel
            customError = BaseErrorModel(httpClientError: .notFound, backendError: .invalidUserData)
            completion(.failure(customError))
            return nil
        }
    }
}
