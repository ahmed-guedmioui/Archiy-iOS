//
//  Route.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

enum Route: Hashable {
    case Login
    case Register
    case Home
    case ItemDetail(
        itemId: String
    )
}
