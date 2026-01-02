//
//  Alert.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI
import Combine

class Alert: ObservableObject {
    static let shared = Alert()
    
    @Published var buttonText: String = ""
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var isPresented: Bool = false
    
    func show(buttonText: String = "Ok".local, title: String = "", message: String = "") {
        self.buttonText = buttonText
        self.title = title
        self.message = message
        self.isPresented = true
    }
    
    func dismiss() {
        self.isPresented = false
    }
}

struct AlertModifier: ViewModifier {
    @ObservedObject var alert = Alert.shared
    
    func body(content: Content) -> some View {
        content
            .alert(
                alert.title,
                isPresented: $alert.isPresented,
                actions: {
                    Button(alert.buttonText) {
                        alert.dismiss()
                    }
                },
                message: {
                    Text(alert.message)
                }
            )
    }
}

extension View {
    func withAlert() -> some View {
        self.modifier(AlertModifier())
    }
}
