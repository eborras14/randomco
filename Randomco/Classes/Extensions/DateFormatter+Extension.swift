//
//  DateFormatter+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 4/2/23.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
