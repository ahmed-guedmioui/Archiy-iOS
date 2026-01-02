//
//  StringsExtensions.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

extension String {
    var local: String {
        NSLocalizedString(self, comment: "")
    }
}
