//
//  Date+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 3/2/23.
//

import Foundation

extension Date {
    
    static let dateFormat = "yyyy-MM-dd"
    
    func format(identifier: String = Locale.current.identifier, format: String = dateFormat) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func getDateWithHoursAndMin() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return  "\(dateFormatter.string(from: self))"
    }
}
