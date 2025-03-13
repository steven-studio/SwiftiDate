//
//  FlowStack.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI

struct FlowStack<Content: View>: View {
    let spacing: CGFloat
    let content: Content

    init(spacing: CGFloat = 10, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            content
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width + d.width) > geometry.size.width) {
                        width = 0
                        height -= d.height + self.spacing
                    }
                    let result = width
                    if d[.trailing] == geometry.size.width {
                        width = 0 // last item
                    } else {
                        width += d.width + self.spacing
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { d in
                    let result = height
                    if d[.trailing] == geometry.size.width {
                        height = 0 // last item
                    }
                    return result
                })
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return .clear
        }
    }
}
