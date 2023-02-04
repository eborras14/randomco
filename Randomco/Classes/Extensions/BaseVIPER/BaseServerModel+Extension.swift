//
//  BaseServerModel+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation
import VIPERPLUS

extension BaseServerModel {
    func encode() -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        else { return nil }
        
        return json
    }
}

extension Array where Element: BaseServerModel {
    func encode() -> [[String: Any]]? {
        guard let jsonData = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
        else { return nil }
        
        return json
    }
}
