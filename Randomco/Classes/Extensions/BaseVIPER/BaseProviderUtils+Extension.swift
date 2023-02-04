//
//  BaseProviderUtils+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import VIPERPLUS

extension BaseProviderUtils {
    static func getHeadersFromContext(_ context: BaseURLContext, authenticated: Bool) -> [String: String] {

        switch context {
        case .randomco:
            return [:]
        default:
            return [:]
        }
    }
    
    static func printRequest(_ customRequest: CustomRequest) {
        let data = customRequest.arrayParams != nil
            ? try? JSONSerialization.data(withJSONObject: customRequest.arrayParams ?? [:], options: .prettyPrinted)
            : try? JSONSerialization.data(withJSONObject: customRequest.params ?? [], options: .prettyPrinted)
        
        Utils.print("************* REQUEST **************")
        Utils.print("Request Date: \(Date().format(format: dateFormat))")
        Utils.print("URL: \(customRequest.fullEndpoint)")
        Utils.print("METHOD \(customRequest.method.rawValue)")
        if customRequest.additionalConfiguration.printLog {
            Utils.print("PARAMETERS: ")
            Utils.print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            Utils.print("HEADERS: \(customRequest.headers)")
        }
        Utils.print("************* END *************")
    }
    
    
    static func manageCustomResponse(flagsDto: BaseProviderDTO,
                                            response: HTTPURLResponse,
                                            data: Data?,
                                            delegate: BaseProviderDelegate?,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (BaseErrorModel) -> Void) {
        DispatchQueue.main.async {
            delegate?.responseGet()
        }
        if flagsDto.flagsDto.printLog {
            print(response.statusCode)
        }
        if (200..<300).contains(response.statusCode) {
            guard let data = data else {
                let error = self.apiResponseError(responseData: data,
                                                  responseStatusCode: response.statusCode,
                                                  printData: flagsDto.flagsDto.printLog)
                error.originalObject = data
                failure(error)

                return
            }

            let decryptedBytes = Self.manageResponseData(data: data,
                                                         encrypted: flagsDto.flagsDto.encrypted)
            printSuccessResponse(endpoint: flagsDto.endpoint,
                                 data: data,
                                 decryptedBytes: decryptedBytes,
                                 printData: flagsDto.flagsDto.printLog)
            
            success(decryptedBytes ?? Data())
        } else {
            let decryptedBytes = Self.manageResponseData(data: data,
                                                         encrypted: flagsDto.flagsDto.encrypted)
            printFailureResponse(endpoint: flagsDto.endpoint,
                                 data: data,decryptedBytes: decryptedBytes,
                                 printData: flagsDto.flagsDto.printLog)
            let error = self.apiResponseError(responseData: decryptedBytes,
                                              responseStatusCode: response.statusCode,
                                              printData: flagsDto.flagsDto.printLog)
            error.originalObject = data
            failure(error)

            return
        }
    }
}
