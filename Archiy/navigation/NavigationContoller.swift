//
//  NavigationContoller.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI
import Combine

class NavigationContoller: ObservableObject {
    
    @Published var path: [Route] = [.Login]
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func popBackStack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popBackStack(to route: Route) {
        if let index = findRouteTypeIndex(for: route) {
            path.removeSubrange((index + 1)..<path.count)
        } else {
            path.removeAll()
            path.append(route)
        }
    }
    
    private func findRouteTypeIndex(for route: Route) -> Int? {
        return path.firstIndex { currentRoute in
            routesMatchByType(currentRoute, route)
        }
    }
    
    private func routesMatchByType(_ route1: Route, _ route2: Route) -> Bool {
        switch (route1, route2) {
        case (.Login, .Login):
            return true
        case (.Register, .Register):
            return true
        case (.Home, .Home):
            return true
        case (.ItemDetail, .ItemDetail):
            return true
        default:
            return false
        }
    }
}
