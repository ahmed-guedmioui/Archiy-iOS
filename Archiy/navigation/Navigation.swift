//
//  Navigation.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI

struct Navigation: View {
    @StateObject private var navController = NavigationContoller()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navController.path) {
                if let firstRoute = navController.path.first {
                    destinationView(for: firstRoute)
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                                .navigationPopGestureDisabled(navController.path.count == 1)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                } else {
                    // default view if path is empty
                    VStack{}
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                                .navigationPopGestureDisabled(navController.path.count == 1)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                }
                
            }
            .environmentObject(navController)
            .withAlert()
            .withLoadingPopup()
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .Login:
            VStack{}
                .navigationBarBackButtonHidden(true)
            
        case .Register:
            VStack{}
                .navigationBarBackButtonHidden(true)
            
        case .Home:
            VStack{}
                .navigationBarBackButtonHidden(true)
            
        case .ItemDetail(let itemId):
            VStack{}
                .navigationBarBackButtonHidden(true)
        }
    }
}
