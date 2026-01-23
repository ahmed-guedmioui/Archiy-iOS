//
//  CoreButton.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI

struct CoreButton<Content: View>: View {
    @SwiftUI.Environment(\.layoutDirection) var direction
    
    var text: String?
    var isLoading: Bool
    var enabled: Bool
    var verticalPadding: CGFloat
    var horizontalPadding: CGFloat
    var fontSize: CGFloat
    var textMaxLines: Int
    var textColor: Color
    var containerColor: Color
    var cornerRadius: CGFloat
    var height: CGFloat?
    var width: CGFloat?
    var onClick: () -> Void
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
        containerColor: Color = Color.scheme.primary,
        cornerRadius: CGFloat = 50,
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
        self.fontSize = fontSize
        self.textMaxLines = textMaxLines
        self.textColor = textColor
        self.containerColor = containerColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
        self.onClick = onClick
        self.content = content?()
    }
    
    var body: some View {
        Button(action: {
            if enabled && !isLoading {
                onClick()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                    
                    Spacer().frame(width: 8)
                }
                
                if let text = text {
                    Text(text)
                        .foregroundColor(textColor)
                        .lineLimit(textMaxLines)
                } else if let content = content {
                    content
                        .opacity(isLoading ? 0 : 1)
                }
            }
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
        }
        .frame(width: width)
        .frame(height: height)
        .background(enabled ? containerColor : Color.scheme.onBackground.opacity(0.2))
        .cornerRadius(cornerRadius)
        .disabled(!enabled || isLoading)
    }
}

extension CoreButton where Content == EmptyView {
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
        containerColor: Color = Color.scheme.primary,
        cornerRadius: CGFloat = 50,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        onClick: @escaping () -> Void
    ) {
        self.text = text
        self.isLoading = isLoading
        self.enabled = enabled
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.fontSize = fontSize
        self.textMaxLines = textMaxLines
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.containerColor = containerColor
        self.height = height
        self.width = width
        self.onClick = onClick
        self.content = nil
    }
}
