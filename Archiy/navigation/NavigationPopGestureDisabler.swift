//
//  NavigationPopGestureDisabler.swift
//  iosApp
//
//  Created by ahmed on 13/04/2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

private struct NavigationPopGestureDisabler: UIViewRepresentable {
    let disabled: Bool
    
    func makeUIView(context: Context) -> some UIView { UIView() }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            uiView
                .parentViewController?
                .navigationController?
                .interactivePopGestureRecognizer?.isEnabled = !disabled
        }
    }
}
public extension View {
    @ViewBuilder
    func navigationPopGestureDisabled(_ disabled: Bool) -> some View {
        background {
            NavigationPopGestureDisabler(disabled: disabled)
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) { $0.next}.first { $0 is UIViewController } as? UIViewController
    }
}
