//
//  LoadingPopup.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI
import Combine

class LoadingPopup: ObservableObject {
    static let shared = LoadingPopup()
    
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    
    func show(message: String = "Loading...".local) {
        self.message = message
        self.isLoading = true
    }
    
    func hide() {
        self.isLoading = false
    }
}

struct LoadingView: View {
    var message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text(message)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground).opacity(0.8))
            )
            .shadow(radius: 10)
        }
    }
}

struct LoadingModifier: ViewModifier {
    @ObservedObject var loadingPopup = LoadingPopup.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if loadingPopup.isLoading {
                LoadingView(message: loadingPopup.message)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: loadingPopup.isLoading)
    }
}

extension View {
    func withLoadingPopup() -> some View {
        self.modifier(LoadingModifier())
    }
}
