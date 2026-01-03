//
//  Color.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation
import SwiftUI

extension Color {
    static let scheme = ColorScheme()
}

struct ColorScheme {
    let primary = Color("primary")
    let primaryContainer = Color("primaryContainer")
    let onPrimary = Color("onPrimary")
    let background = Color("background")
    let onBackground = Color("onBackground")
    let secondary = Color("secondary")
    let onSecondary = Color("onSecondary")
    let tertiary = Color("tertiary")
    let onTertiary = Color("onTertiary")
    let error = Color("ErrorColor")
}
