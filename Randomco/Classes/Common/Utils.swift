//
//  Utils.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import UIKit

class Utils {
    
    static func getXib(xibFile: XibFile) -> String {
        xibFile.rawValue
    }
    
    static func getAppVersionWithBuild() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return "" }
        
        return "\(appVersion) (\(build))"
    }
    
    static func getAppVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        return appVersion
    }
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        
        #if DEBUG
        
        var idx = items.startIndex
        let endIdx = items.endIndex
        
        repeat {
            Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
            idx += 1
        }
            while idx < endIdx
        
        #endif
    }
    
    static func isIpad() -> Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
}
