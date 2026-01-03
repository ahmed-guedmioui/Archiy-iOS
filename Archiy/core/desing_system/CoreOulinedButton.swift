//
//  CoreOutlinedButton.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI

struct CoreOutlinedButton<Content: View>: View {
    @SwiftUI.Environment(\.layoutDirection) var direction
    
    let text: String?
    let isLoading: Bool
    let enabled: Bool
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat
    let borderWidth: CGFloat
    let fontSize: CGFloat
    let textMaxLines: Int
    let textColor: Color
    let borderColor: Color
    let containerColor: Color
    let icon: String?
    let iconColor: Color?
    let cornerRadius: CGFloat
    let height: CGFloat?
    var width: CGFloat?
    let onClick: () -> Void
    let content: Content?
    
    init(
        text: String? = nil,
        isLoading: Bool = false,
        enabled: Bool = true,
        verticalPadding: CGFloat = 10,
        horizontalPadding: CGFloat = 20,
        borderWidth: CGFloat = 0.5,
        fontSize: CGFloat = 16,
        textMaxLines: Int = 1,
        textColor: Color = Color.scheme.onPrimary,
        borderColor: Color = Color.scheme.primary,
        containerColor: Color = .clear,
        cornerRadius: CGFloat = 50,
        icon: String? = nil,
        iconColor: Color = Color.scheme.primary,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        onClick: @escaping () -> Void,
        content: (() -> Content)? = nil
    ) {
        self.text = text
        self.isLoading = isLoading
        self.enabled = enabled
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.borderWidth = borderWidth
        self.fontSize = fontSize
        self.textMaxLines = textMaxLines
        self.textColor = textColor
        self.borderColor = borderColor
        self.containerColor = containerColor
        self.cornerRadius = cornerRadius
        self.icon = icon
        self.iconColor = iconColor
        self.height = height
        self.width = width
        self.onClick = onClick
        self.content = content?()
    }
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                HStack() {
                    if let icon = icon {
                        Image(icon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(iconColor)
                            .frame(width: 20, height: 20)
                            .opacity(isLoading ? 0 : 1)
                    }
                    
                    if let text = text {
                        Text(text)
                            .foregroundColor(textColor)
                            .lineLimit(textMaxLines)
                            .opacity(isLoading ? 0 : 1)
                    } else if let content = content {
                        content
                            .opacity(isLoading ? 0 : 1)
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.7)
                }
            }
            .frame(width: width)
            .frame(height: height)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(containerColor)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(enabled ? borderColor : borderColor.opacity(0.3), lineWidth: borderWidth)
        )
        .cornerRadius(cornerRadius)
        .disabled(!enabled || isLoading)
    }
}

extension CoreOutlinedButton where Content == EmptyView {
    init(
        text: String? = nil,
        isLoading: Bool = false,
        enabled: Bool = true,
        verticalPadding: CGFloat = 10,
        horizontalPadding: CGFloat = 20,
        borderWidth: CGFloat = 0.5,
        fontSize: CGFloat = 16,
        textMaxLines: Int = 1,
        textColor: Color = Color.scheme.onPrimary,
        borderColor: Color = Color.scheme.primary,
        containerColor: Color = .clear,
        cornerRadius: CGFloat = 50,
        icon: String? = nil,
        iconColor: Color = Color.scheme.primary,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        onClick: @escaping () -> Void
    ) {
        self.text = text
        self.isLoading = isLoading
        self.enabled = enabled
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.borderWidth = borderWidth
        self.fontSize = fontSize
        self.textMaxLines = textMaxLines
        self.textColor = textColor
        self.borderColor = borderColor
        self.containerColor = containerColor
        self.cornerRadius = cornerRadius
        self.icon = icon
        self.iconColor = iconColor
        self.height = height
        self.width = width
        self.onClick = onClick
        self.content = nil
    }
}
